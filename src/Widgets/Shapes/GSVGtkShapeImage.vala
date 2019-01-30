/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
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
 * GSVGtk Image Shape is a child class of the parent CanvasItem {@link Clutter.Actor},
 * to be used to render SVG images
 */
using GSvg;
using Rsvg;
public class Gcav.GSvgtkShapeImage : GSvgtk.ActorImageClutter, Gcav.Item {
    private MoveAction move_action;
    private HoverAction hover_action;

    public bool on_hover_effect {
        get {
            return _on_hover_effect;
        } set {
            if (!value) {
                hover_action.toggle (false);
            }

            _on_hover_effect = value;
        }
    }
    private bool _on_hover_effect = true;

    public bool dragging { get; internal set; default = false; }

    public bool clicked { get; internal set; default = false; }

    public float real_x {
        get {
            return _real_x;
        } set {
            _real_x = value;
            apply_ratio (ratio);
        }
    }
    private float _real_x;

    public float real_y {
        get {
            return _real_y;
        } set {
            _real_y = value;
            apply_ratio (ratio);
        }
    }
    private float _real_y;

    public float real_w {
        get {
            return _real_w;
        } set {
            _real_w = value;
            apply_ratio (ratio);
        }
    }
    private float _real_w;

    public float real_h {
        get {
            return _real_h;
        } set {
            _real_h = value;
            apply_ratio (ratio);
        }
    }
    private float _real_h;

    public double rotation {
        get {
            return _rotation;
        } set {
            if (value < 0) return;

            _rotation = value % 360;
            rotation_angle_z = value % 360;
            updated ();
        }
    }
    private double _rotation = 0.0;
    public float ratio { get; set; }

    construct {
        reactive = true;
        set_pivot_point (0.5f, 0.5f);

        move_action = new MoveAction (this);
        hover_action = new HoverAction (this);

        enter_event.connect (() => {
            if (on_hover_effect) {
                hover_action.toggle (true);
            }
        });

        leave_event.connect (() => {
            if (on_hover_effect) {
                hover_action.toggle (false);
            }
        });
    }

    public GSvgtkShapeImage.with_values (float x, float y, float w, float h, string color) {
        Object (background_color: Clutter.Color.from_string (color));
        set_rectangle (x, y, w, h);
    }

    public GSvgtkShapeImage () {
        set_rectangle (0, 0, 300, 300);
    }
}
