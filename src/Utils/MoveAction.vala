/*
* Copyright (c) 2017
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

/**
 * Manages and controls a CanvasItem's movement.
 */
internal class GtkCanvas.MoveAction : Clutter.DragAction {
    private int x_offset_press = 0;
    private int y_offset_press = 0;

    private unowned CanvasItem item;

    public MoveAction (CanvasItem item) {
        this.item = item;

        drag_begin.connect (on_move_begin);
        drag_end.connect (on_move_end);

        item.add_action (this);
    }

    private void on_move_begin (Clutter.Actor actor, float event_x, float event_y, Clutter.ModifierType modifiers) {
        float px, py;
        get_press_coords (out px, out py);

        x_offset_press = (int)(px - item.x);
        y_offset_press = (int)(py - item.y);

        item.clicked = true;
        item.dragging = false;

        item.selected (modifiers);
    }

    protected override bool drag_progress (Clutter.Actor actor, float delta_x, float delta_y) {
        if (!item.clicked) {
            return false;
        }

        float motion_x, motion_y;
        get_motion_coords (out motion_x, out motion_y);

        var x = (int) ((motion_x - x_offset_press) / item.ratio);
        var y = (int) ((motion_y - y_offset_press) / item.ratio);
        item.set_rectangle (x, y, null, null);

        if (!item.dragging) {
            item.dragging = true;
        }

        return false;
    }

    private void on_move_end () {
        item.clicked = false;

        if (item.dragging) {
            item.dragging = false;
        }
    }
}