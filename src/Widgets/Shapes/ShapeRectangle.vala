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
 * ShapeRectangle is a child class of the parent CanvasItem {@link Clutter.Actor} that handles move, rotate, scale, etc.
 * 
 * This is a specific shape class to handle the generation of a Rectangular geometry
 */
public class GtkCanvas.ShapeRectangle : GtkCanvas.CanvasItem {
    public ShapeRectangle (string color, double rotation) {
        this.color = color;
        this.rotation = rotation;

        background_color = Clutter.Color.from_string (color);
        
        real_x = 0;
        real_y = 0;
        
        real_w = 100;
        real_h = 100;
        
        apply_ratio (ratio);
        apply_rotation (rotation);
    }
}