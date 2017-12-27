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
* Authored by: Alessandro Castellani <castellani.ale@gmail.com>
*/

/**
 * ShapeRectangle is a child class of the parent CanvasItem {@link Clutter.Actor}.
 * 
 * This is a specific shape class to handle the generation of a Rectangular geometry
 */
public class GtkCanvas.ShapeRectangle : GtkCanvas.CanvasItem {
    /**
    * Fill color of the shape
    */
    public string color {
        get {
            return _color;
        } set {
            if (value == "") return;

            _color = value;
            clutter_color = Clutter.Color.from_string (value);
        }
    }
    private string _color;
    private Clutter.Color clutter_color;

    public ShapeRectangle (string color, double rotation) {
        this.color = color;
        this.rotation = rotation;

        var _canvas = new Clutter.Canvas ();
        _canvas.set_size (100, 100);

        set_rectangle (0, 0, 100, 100);

        _canvas.draw.connect((ctx, w, h) => {
            ctx.set_source_rgb (clutter_color.red, clutter_color.green, clutter_color.blue);
            ctx.rectangle (0, 0, w, h);
            ctx.fill ();

            return true;
        });

        set_content (_canvas);
        _canvas.invalidate (); // forces the redraw
    }
}