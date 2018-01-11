/*
* Copyright (C) 2018  <@>
* Copyright (C) 2018 Daniel Espinosa <esodan@gmail.com>
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
public interface GtkCanvas.Item : Clutter.Actor {
    /**
     * Signal triggered when this is selected by the user.
     *
     * @param modifiers this is a mask that contains all the modifiers for the event such as if Shift/Ctrl were pressed, or which button on the mouse was clicked
     */
    public signal void selected (Clutter.ModifierType modifiers);

    /**
     * Signal triggered when the rectangle of this changes
     */
    public signal void updated ();

    /**
     * Triggered after a move operation, when the mouse button is lifted
     */
    public signal void on_move_end ();

    /**
    * Sets if the hover effect should appear when you hover on this. Disabling the effect if currently visible;
    */
    public abstract bool on_hover_effect { get; set; }
    /**
     * True if this is currently being dragged
     */
    public abstract bool dragging { get; internal set; }
    /**
     * True if this was just clicked, but not yet moved
     */
    public abstract bool clicked { get; internal set; }
    /**
    * Sets the position x of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public abstract float real_x { get; set; }
    /**
    * Sets the position y of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public abstract float real_y { get; set; }
    /**
    * Sets the height of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public abstract float real_w { get; set; }
    /**
    * Sets the width of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public abstract float real_h { get; set; }
    /**
     * The item's rotation. From 0 to 360 degrees
     */
    public abstract double rotation { get; set; }
    /**
     * The item's ratio to scale size
     */
    public abstract double ratio { get; set; }
    /**
    * Set's the coordenates and size of this, ignoring nulls. Use this to set multiple "real_n" properties without causing uneeded updates.
    */
    public virtual void set_rectangle (float? x, float? y, float? w, float? h) {
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
            real_h = h;
        }

        apply_ratio (this, ratio);
    }

    internal static void apply_ratio (Item item, double ratio) {
        item.ratio = ratio;

        item.width =  (float) (item.real_w  * ratio);
        item.height = (float) (item.real_h * ratio);
        item.x = (float) (item.real_x * ratio);
        item.y = (float) (item.real_y * ratio);

        item.updated ();
    }
}
