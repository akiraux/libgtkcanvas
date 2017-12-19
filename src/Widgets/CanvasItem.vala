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
 * CanvasItem is a {@link Clutter.Actor} which is the base class of all items that can appear on the Canvas.
 *
 * This class should take care of the basics such as dragging, clicks and rotation,
 * and leave more specific implementations to child classes.
 */
public class GtkCanvas.CanvasItem : Clutter.Actor {
    /**
     * Signal triggered when this is selected by the user.
     *
     * @param modifiers this is a mask that contains all the modifiers for the event such as if Shift/Ctrl were pressed, or which button on the mouse was clicked
     */
    public signal void selected (Clutter.ModifierType modifiers);

    private MoveAction move_action;
    private HoverAction hover_action;

    /**
     * True if this is currently being dragged
     */
    public bool dragging { get; internal set; default = false; }

    /**
     * True if this was just clicked, but not yet moved
     */
    public bool clicked { get; internal set; default = false; }

    public int real_x { get; private set; }
    public int real_y { get; private set; }
    public int real_w { get; private set; }
    public int real_h { get; private set; }

    internal double ratio;

    construct {
        reactive = true;

        set_rectangle (0, 0, 100, 100);
        move_action = new MoveAction (this);
        hover_action = new HoverAction (this);

        enter_event.connect (() => {
            hover_action.toggle (true);
        });

        leave_event.connect (() => {
            hover_action.toggle (false);
        });
    }

    /**
    * Set's the coordenates and size of this, ignoring nulls. This is where the "real_n" should be set.
    */
    public void set_rectangle (int? x, int? y, int? w, int? h) {
        if (x != null) {
            real_x = x;
        }

        if (y != null) {
            real_y = y;
        }

        if (w != null) {
            real_w = w;
        }

        if (h != null) {
            real_h = w;
        }

        apply_ratio (ratio);
    }

    internal void apply_ratio (double ratio) {
        this.ratio = ratio;

        width = (int) Math.round (real_w  * ratio);
        height = (int) Math.round (real_h * ratio);
        x = (int) Math.round (real_x * ratio);
        y = (int) Math.round (real_y * ratio);

        // Set the bounding box size to parent's size
        hover_action.set_size (width, height);
    }
}
