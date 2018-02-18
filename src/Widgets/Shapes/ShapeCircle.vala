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
 * ShapeCircle is a child class of the parent CanvasItem {@link Clutter.Actor}.
 *
 * This is a specific shape class to handle the generation of a Circle geometry
 */
public class Gcav.ShapeCircle : Gcav.CanvasItem {
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

    public Clutter.Color? clutter_color {
        get {
            return _clutter_color;
        } set {
            if (value == null) return;

            _clutter_color = value;
        }
    }
    private Clutter.Color _clutter_color;

    public ShapeCircle (string color, double rotation) {
        this.color = color;
        this.rotation = rotation;

        double angle1 = 0.0  * (Math.PI/180.0); // angles are specified
        double angle2 = 360.0 * (Math.PI/180.0); // in radians

        var _canvas = new Clutter.Canvas ();
        _canvas.set_size (100, 100);

        set_rectangle (0, 0, 100, 100);

        _canvas.draw.connect((ctx, w, h) => {
            ctx.set_source_rgb (clutter_color.red, clutter_color.green, clutter_color.blue);
            ctx.arc (w/2, h/2, w/2, angle1, angle2);
            ctx.fill ();

            return true;
        });

        set_content (_canvas);
        _canvas.invalidate (); // forces the redraw
    }
}