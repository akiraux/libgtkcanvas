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

/**
 * The grabbers needed to resize a single item on the canvas
 */
public class GtkCanvas.ItemResizer {
    private const int SIZE = 10;
    private const float OFFSET = 5;

    private unowned Clutter.Actor canvas_actor;
    private unowned GtkCanvas.CanvasItem? item = null;
    private bool updating = false;

    private GtkCanvas.CanvasItem grabber[8];
    private int selected_id = -1;

    /**
    * Sets whether the resize controls on the canvas are visible or not
    */
    public bool visible {
        set {
            for (int i = 0; i < 8; i++) {
                grabber[i].visible = value;
            }
        }
    }

    /**
    * Creates the widgets needed to re-size {@link GtkCanvas.CanvasItem}.
    *
    * @param actor The actor from a {@link GtkCanvas.Canvas}.
    */
    public ItemResizer (Clutter.Actor actor) {
        canvas_actor = actor;

        for (int i = 0; i < 8; i++) {
            grabber[i] = make_grabber (i);
        }
    }

    /**
    * Override this function if you want to style the grabbers different.
    *
    * @param id the ID of the item we're requesting. From 0 - 8, clockwize starting at the top left corner
    * @return a {@link GtkCanvas.CanvasItem} or subclass of it
    */
    public virtual GtkCanvas.CanvasItem create_grabber (int id) {
        // TODO: Make a better shape for the grabbers
        return new GtkCanvas.CanvasItem.with_values (0, 0, SIZE, SIZE, "black");
    }

    private GtkCanvas.CanvasItem make_grabber (int id) {
        var g = create_grabber (id);
        g.visible = false;
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

    /**
    * Positions the resize grabbers around a {@link GtkCanvas.CanvasItem}
    *
    * @param item the canvas item it will position around
    */
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

    /*
    * Updates the positioning of all the grabbers on an item
    */
    private void update () {
        if (item == null) return;
        updating = true;

        var cx = item.x + item.width / 2;
        var cy = item.y + item.height / 2;

        var radians = to_radians (item.rotation);

        var _sin = Math.sin (radians);
        var _cos = Math.cos (radians);

        if (selected_id != 0) {
            var x = item.x;
            var y = item.y;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[0].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 1) {
            var x = item.x + item.width / 2;
            var y = item.y;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[1].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 2) {
            var x = item.x + item.width;
            var y = item.y;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[2].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 3) {
            var x = item.x + item.width;
            var y = item.y + item.height / 2;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[3].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 4) {
            var x = item.x + item.width;
            var y = item.y + item.height;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[4].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 5) {
            var x = item.x + item.width / 2;
            var y = item.y + item.height;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[5].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 6) {
            var x = item.x;
            var y = item.y + item.height;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[6].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 7) {
            var x = item.x;
            var y = item.y + item.height / 2 ;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[7].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        updating = false;
    }

    /*
    * Gets the x position of point A {x,y} on a centroid {cx, cy}.
    */
    inline float get_rot_x (double x, double cx, double y, double cy, double sin, double cos) {
        return (float) ((x - cx) * cos - (y - cy) * sin + cx);
    }

    /*
    * Gets the y position of point A {x,y} on a centroid {cx, cy}.
    */
    inline float get_rot_y (double x, double cx, double y, double cy, double sin, double cos) {
        return (float) ((x - cx) * sin + (y - cy) * cos + cy);
    }

    inline double to_radians (double degrees) {
        return degrees / (180.0 / Math.PI);
    }

    inline double to_degrees (double radians) {
        return radians * (180.0 / Math.PI);
    }

    /*
    * Depending on the grabbed grabber, resize the item acordingly
    *
    * To-do: Concider the rotation on the calculations. Might need to do the oposite of get_rot_x/y
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