/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 2; tab-width: 2 -*-  */
/*
* Copyright (c) 2018 Daniel Espinosa <esodan@gmail.com>
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
* Authored by: Daniel Espinosa <esodan@gmail.com>
*/

/**
 * ShapeSVG is a child class of the parent CanvasItem {@link Clutter.Actor},
 * to be used to render SVG images
 */
using GSvg;
using Rsvg;
public class GtkCanvas.ShapeSVG : GtkCanvas.CanvasItem {
    private string default_image = """<?xml version="1.0"?>
  <svg xmlns:svg="http://www.w3.org/2000/svg" width="998" height="298">
   <g font-family="Verdana" font-size="45">
     <text fill="blue" x="250" y="150">No <tspan font-weight="bold" fill="red">Image</tspan> has been set</text>
   </g>
   <rect fill="none" stroke="blue" stroke-width="2" x="1" y="1" width="998" height="298"/>
 </svg>""";
    public GSvg.Document svg { get; set; }

    public void set_svg_string (string str) throws GLib.Error {
      if (svg == null) svg = new GSvg.GsDocument ();
      svg.read_from_string (str);
    }
    construct {
        var _canvas = new Clutter.Canvas ();
        _canvas.set_size (998, 298);

        set_rectangle (0, 0, 100, 100);

        _canvas.draw.connect((ctx, w, h) => {
            if (svg == null) set_svg_string (default_image);
            var rsvg = new Rsvg.Handle ();
            rsvg.write (svg.write_string ().data);
            rsvg.close ();
            rsvg.render_cairo (ctx);
            return true;
        });

        set_content (_canvas);
        _canvas.invalidate (); // forces the redraw
    }
}
