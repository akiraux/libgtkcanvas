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
 * ShapeCircle is a child class of the parent {@link Clutter.Actor} that handles move, rotate, scale, etc.
 * 
 * This is a specific shape class to handle the generation of a Rectangular geometry
 */
public class GtkCanvas.ShapeCircle : GtkCanvas.CanvasItem {
    private string color;
    private double rotation;

    public ShapeCircle (string color, double rotation) {
        this.color = color;
        this.rotation = rotation;

        //  background_color = Clutter.Color.from_string (color);
        
        real_x = 0;
        real_y = 0;
        
        real_w = 100;
        real_h = 100;

        double angle1 = 0.0  * (Math.PI/180.0); // angles are specified
        double angle2 = 360.0 * (Math.PI/180.0); // in radians

        var _canvas = new Clutter.Canvas ();
        _canvas.set_size (100, 100);
        set_size (100, 100);

        set_rectangle (null, null, 100, 100);
        set_content (_canvas);

        _canvas.draw.connect((ctx, w, h) => {
            ctx.set_line_width (1.0);
            ctx.set_source_rgb (0.0, 0.8, 0.0);
            ctx.arc (w/2+1, h/2+1, w/2-2, angle1, angle2);
            ctx.fill ();

            // Create the stroke
            // ctx.set_source_rgba (1, 0.2, 0.2, 0.6);
            // ctx.arc (w/2+1, h/2+1, w/2-2, angle1, angle2);
            // ctx.stroke ();

            return true;
        });

        set_content (_canvas);
        _canvas.invalidate (); // forces the redraw

        apply_ratio (ratio);

        var rotate = new Clutter.RotateAction ();
        rotate.rotate (this, rotation);
    }
}