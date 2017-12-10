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
 * This is a {@link GtkClutter.Embed} object that holds and renders {@link GtkCanvas.CanvasItem} and their subclasses
 *
 * This class should take care of zoom-in/out, and maintaing the aspect ratio of this and it's CanvasItems when the canvas is resized.
 */
public class GtkCanvas.Canvas : GtkClutter.Embed {

    construct {
        var actor = get_stage ();
        actor.background_color = Clutter.Color.from_string ("white");
        set_use_layout_size (false);
    }

   /**
    * Adds a test shape. Great for testing the library!
    *
    * @param color the color the test-shape will be, in CSS format
    * @param rotation the amount of degrees the item will be rotated
    */
    public void add_test_shape (string color, double rotation) {
        var item = new CanvasItem ();
        item.background_color = Clutter.Color.from_string (color);

        var rotate = new Clutter.RotateAction ();
        rotate.rotate (item, rotation);

        get_stage ().add_child (item);
    }
}