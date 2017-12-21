/*
* Copyright (C) 2017
*
* This program or library is free software; you can redistribute it
* and/or modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General
* Public License along with this library; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA.
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

public class GtkCanvas.Resizer {
    private const int SIZE = 10;
    private const float OFFSET = 5;

    private unowned Clutter.Actor canvas_actor;
    private unowned GtkCanvas.CanvasItem? item = null;
    private bool updating = false;

    /*
    Grabber Pos: 0 1 2
                 7   3
                 6 5 4
    */
    private GtkCanvas.CanvasItem grabber[8];
    private int selected_id = -1;

    public bool visible {
        set {
            for (int i = 0; i < 8; i++) {
                grabber[i].visible = value;
            }
        }
    }

    /*
    * Creates the widgets needed to re-size {@link Gtk.Canvas.CanvasItem}.
    *
    * @param actor The actor from a {@link GtkCanvas.Canvas}.
    */
    public Resizer (Clutter.Actor actor) {
        canvas_actor = actor;

        for (int i = 0; i < 8; i++) {
            grabber[i] = make_grabber (i);
        }
    }

    private GtkCanvas.CanvasItem make_grabber (int id) {
        var g = new GtkCanvas.CanvasItem.with_values (0, 0, SIZE, SIZE, "black");
        canvas_actor.add (g);

        g.selected.connect (() => {
            selected_id = id;
        });

        g.updated.connect (() => {
            if (!updating) {
                resize (id);
            }
        });

        g.on_move_end.connect (() => {
            selected_id = -1;
            update ();
        });

        return g;
    }

    public void select_item (GtkCanvas.CanvasItem item) {
        for (int i = 0; i < 8; i++) {
            canvas_actor.set_child_above_sibling (grabber[i], null);
        }

        if (this.item != null) {
            this.item.updated.disconnect (update);
        }

        this.item = item;
        item.updated.connect (update);
        selected_id = -1;
        visible = true;
        update ();
    }

    private void update () {
        if (item == null) return;
        updating = true;

        if (selected_id != 0)
            grabber[0].set_rectangle ((item.x - OFFSET), (item.y - OFFSET), null, null);
        if (selected_id != 1)
            grabber[1].set_rectangle ((item.x + item.width / 2 - OFFSET), (item.y - OFFSET), null, null);
        if (selected_id != 2) {
            var cx = item.x + item.width / 2;
            var cy = item.y + item.width / 2;

            var xr = (item.x + item.width - OFFSET) - cx;
            var yr = (item.y - OFFSET) - cy;

            var dis = Math.hypot (xr, yr);

            var radians = to_radians (item.rotation);
            var initial_angle = Math.atan (yr / xr);

            var x = (dis * (Math.cos (radians + initial_angle))) + cx;
            var y = (dis * (Math.sin (radians + initial_angle))) + cy;

            grabber[2].set_rectangle ((float) x, (float) y, null, null);
            //grabber[2].set_rectangle ((item.x + item.width - OFFSET), (item.y  - OFFSET), null, null);
        }
        if (selected_id != 3) {
            var cx = item.x + item.width / 2;
            var cy = item.y + item.width / 2;

            var x = item.x + item.width - OFFSET;
            var y = item.y + item.height / 2 - OFFSET;

            var radians = to_radians (item.rotation);

            var sin = Math.sin (radians);
            var cos = Math.cos (radians);

            var xf = (x - cx) * cos - (y - cy) * sin + cx;
            var yf = (x - cx) * sin + (y - cy) * cos + cy;

            grabber[3].set_rectangle ((float) xf, (float) yf, null, null);
            // grabber[3].set_rectangle ((item.x + item.width - OFFSET), (item.y + item.height / 2 - OFFSET), null, null);
        }
        if (selected_id != 4)
            grabber[4].set_rectangle ((item.x + item.width - OFFSET), (item.y + item.height - OFFSET), null, null);
        if (selected_id != 5)
            grabber[5].set_rectangle ((item.x + item.width / 2 - OFFSET), (item.y + item.height - OFFSET), null, null);
        if (selected_id != 6)
            grabber[6].set_rectangle ((item.x - OFFSET), (item.y + item.height - OFFSET), null, null);
        if (selected_id != 7)
            grabber[7].set_rectangle ((item.x - OFFSET), (item.y + item.height / 2 - OFFSET), null, null);

        updating = false;
    }

    static double to_radians (double degrees) {
        return degrees / (180.0 / Math.PI);
    }

    static double to_degrees (double radians) {
        return radians * (180.0 / Math.PI);
    }

    /*
    Grabber Pos: 0 1 2
                 7   3
                 6 5 4
    */
    private void resize (int id) {
        switch (id) {
            case 0:
                item.set_rectangle (
                    (grabber[0].x + OFFSET) / (item.ratio),
                    (grabber[0].y + OFFSET) / (item.ratio),
                    (item.width + (item.x - grabber[0].x - OFFSET)) / item.ratio,
                    (item.height + (item.y - grabber[0].y - OFFSET)) / item.ratio
                );
                break;
            case 1:
                item.set_rectangle (
                    null,
                    (grabber[1].y + OFFSET) / (item.ratio),
                    null,
                    (item.height + (item.y - grabber[1].y - OFFSET)) / item.ratio
                );
                break;
            case 2:
                item.set_rectangle (
                    null,
                    (grabber[2].y + OFFSET) / (item.ratio),
                    ((grabber[2].x - (item.x) + OFFSET) / (item.ratio)),
                    (item.height + (item.y - grabber[2].y - OFFSET)) / item.ratio
                );
                break;
            case 3:
                item.set_rectangle (
                    null,
                    null,
                    ((grabber[3].x - (item.x) + OFFSET) / (item.ratio)),
                    null);
                break;
            case 4:
                item.set_rectangle (
                    null,
                    null,
                    ((grabber[4].x - (item.x) + OFFSET) / (item.ratio)),
                    ((grabber[4].y - (item.y) + OFFSET) / (item.ratio)));
                break;
            case 5:
                item.set_rectangle (
                    null,
                    null,
                    null,
                    ((grabber[5].y - (item.y) + OFFSET) / (item.ratio)));
                break;
            case 6:
                item.set_rectangle (
                    (grabber[6].x + OFFSET) / (item.ratio),
                    null,
                    (item.width + (item.x - grabber[6].x - OFFSET)) / item.ratio,
                    ((grabber[6].y - (item.y) + OFFSET) / (item.ratio)));
                break;
            case 7:
                item.set_rectangle (
                    (grabber[7].x + OFFSET) / (item.ratio),
                    null,
                    (item.width + (item.x - grabber[7].x - OFFSET)) / item.ratio,
                    null);
                break;
        }
    }
}