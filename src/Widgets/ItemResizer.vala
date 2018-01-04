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
 * The grabbers needed to resize and rotate single item on the canvas
 *
 * TODO: Rotation snapping to closest 5 degree
 */
public class GtkCanvas.ItemResizer {
    /**
     * Signal triggered when a resize is starting
     */
    public signal void resize_start ();

    private const int SIZE = 10;
    private const float OFFSET = 5;

    private unowned Clutter.Actor canvas_actor;
    private unowned GtkCanvas.CanvasItem? item = null;
    private bool updating = false;

    private GtkCanvas.CanvasItem grabber[10];
    private int selected_id = -1;

    /**
    * Sets whether the resize controls on the canvas are visible or not
    */
    public bool visible {
        set {
            for (int i = 0; i < 10; i++) {
                grabber[i].visible = value;
            }
        }
    }

    /**
    * Sets whether the resize controls on the canvas will appear or not
    */
    public bool enabled {
        get {
            return _enabled;
        } set {
            _enabled = value;
            if (!value) {
                for (int i = 0; i < 10; i++) {
                    grabber[i].visible = false;
                }
            }
        }
    }
    private bool _enabled = true;

    /**
    * Creates the widgets needed to re-size {@link GtkCanvas.CanvasItem}.
    *
    * @param actor The actor from a {@link GtkCanvas.Canvas}.
    */
    public ItemResizer (Clutter.Actor actor) {
        canvas_actor = actor;

        for (int i = 0; i < 10; i++) {
            grabber[i] = make_grabber (i);
        }
    }

    /**
    * Override this function if you want to style the grabbers different.
    *
    * @param id the ID of the item we're requesting. From 0 - 8, clockwize starting at the top left corner, with 9 being the rotator
    * @return a {@link GtkCanvas.CanvasItem} or subclass of it
    */
    public virtual GtkCanvas.CanvasItem create_grabber (int id) {
        // TODO: Make a better shape for the grabbers
        if (id == 8) {
            return new GtkCanvas.CanvasItem.with_values (0, 0, SIZE, SIZE, "blue");
        } else if (id == 9) {
            return new GtkCanvas.CanvasItem.with_values (0, 0, SIZE, SIZE, "white");
        } else {
            return new GtkCanvas.CanvasItem.with_values (0, 0, SIZE, SIZE, "black");
        }
    }

    private GtkCanvas.CanvasItem make_grabber (int id) {
        var g = create_grabber (id);
        g.visible = false;
        canvas_actor.add (g);

        g.selected.connect (() => {
            selected_id = id;
            resize_start ();
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
        if (!enabled) return;

        for (int i = 0; i < 10; i++) {
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

        if (selected_id != 8) {
            var x = item.x + item.width / 2;
            var y = item.y - 48;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[8].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
        }

        if (selected_id != 9) {
            var x = item.x + item.width / 2;
            var y = item.y + item.height / 2;

            var xf = get_rot_x (x, cx, y, cy, _sin, _cos);
            var yf = get_rot_y (x, cx, y, cy, _sin, _cos);

            grabber[9].set_rectangle (xf - OFFSET, yf - OFFSET, null, null);
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

    inline float to_deg (float rad) {
        return rad * (180.0f / (float) Math.PI);
    }

    /*
    * Depending on the grabbed grabber, resize the item acordingly
    *
    * To-do: Resizing a rotated shape gives broken results
    */
    private void resize (int id) {
        float x, y;

        var cx = item.x + item.width / 2.0f;
        var cy = item.y + item.height / 2.0f;

        var radians = to_radians ((-1.0f) * item.rotation);

        var _sin = Math.sin (radians);
        var _cos = Math.cos (radians);

        x = get_rot_x (grabber[id].x, cx, grabber[id].y, cy, _sin, _cos);
        y = get_rot_y (grabber[id].x, cx, grabber[id].y, cy, _sin, _cos);

        float to_match_x = 0, to_match_y = 0;
        weak GtkCanvas.CanvasItem? to_match = null;
        float mult_x = 1f, mult_y = 1f;

        switch (id) {
            case 0:
                to_match = grabber[4];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);

                item.set_rectangle (
                    (x + OFFSET) / (item.ratio),
                    (y + OFFSET) / (item.ratio),
                    (item.width + (item.x - x - OFFSET)) / item.ratio,
                    (item.height + (item.y - y - OFFSET)) / item.ratio
                );

                break;
            case 1:
                to_match = grabber[5];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);
                mult_y = -1f;

                item.set_rectangle (
                    null,
                    (y + OFFSET) / (item.ratio),
                    null,
                    (item.height + (item.y - y - OFFSET)) / item.ratio
                );

                break;
            case 2:
                to_match = grabber[6];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);

                item.set_rectangle (
                    null,
                    (y + OFFSET) / (item.ratio),
                    ((x - (item.x) + OFFSET) / (item.ratio)),
                    (item.height + (item.y - y - OFFSET)) / item.ratio
                );

                break;
            case 3: // W
                float new_width = (x - (item.x) + OFFSET);

                float delta_w = (new_width - item.width);
                var new_x = item.x + (delta_w * ((float) Math.cos (radians) - 1.0f) ) / 2.0f;
                var new_y = item.y - (delta_w * ((float) Math.sin (radians))) / 2.0f;

                item.set_rectangle (
                    new_x / (item.ratio),
                    new_y / (item.ratio),
                    ((x - (item.x) + OFFSET) / (item.ratio)),
                    null);

                break;
            case 4:
                to_match = grabber[0];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);
                mult_y = -1.0f;

                item.set_rectangle (
                    null,
                    null,
                    (x - (item.x) + OFFSET) / (item.ratio),
                    (y - (item.y) + OFFSET) / (item.ratio));

                break;
            case 5:
                to_match = grabber[1];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);
                mult_y = -1f;

                item.set_rectangle (
                    null,
                    null,
                    null,
                    (y - item.y + OFFSET) / (item.ratio));

                break;
            case 6:
                to_match = grabber[2];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);

                item.set_rectangle (
                    (x + OFFSET) / (item.ratio),
                    null,
                    (item.width + (item.x - x - OFFSET)) / item.ratio,
                    ((y - (item.y) + OFFSET) / (item.ratio)));

                break;
            case 7:
                to_match = grabber[3];
                to_match_x = get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos);
                to_match_y = get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos);
                mult_x = -1f;

                item.set_rectangle (
                    (x + OFFSET) / (item.ratio),
                    null,
                    (item.width + (item.x - x - OFFSET)) / item.ratio,
                    null);

                break;
            case 8:
                var center_x = item.x + item.width / 2.0f;
                var center_y = item.y + item.height / 2.0f;

                item.rotation = 180f - to_deg (Math.atan2f (grabber[id].x - center_x, grabber[id].y - center_y));
                break;
        }

        //  if (to_match != null) {
        //      var new_x = (to_match_x - get_rot_x (to_match.x, cx, to_match.y, cy, _sin, _cos)) * mult_x;
        //      var new_y = (to_match_y - get_rot_y (to_match.x, cx, to_match.y, cy, _sin, _cos)) * mult_y;

        //      item.set_rectangle (
        //          ((item.x) + new_x) / (item.ratio),
        //          ((item.y) + new_y) / (item.ratio),
        //          null,
        //          null);
        //  }
    }
}