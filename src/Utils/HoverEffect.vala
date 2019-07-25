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

internal class Gcav.HoverEffect : Clutter.Effect {
    public int border_size { get; construct; }
    public float scale_factor { get; set; default = 1; }

    Cogl.Material material;

    public HoverEffect (int border_size) {
        Object (border_size: border_size);
    }

    construct {
        material = new Cogl.Material ();
    }

    public override void paint (Clutter.EffectPaintFlags flags)    {
        var bounding_box = get_bounding_box ();
        var color = Cogl.Color.from_4ub (65, 201, 253, 55);

        material.set_color (color);

        Cogl.set_source (material);
        Cogl.rectangle (bounding_box.x1, bounding_box.y1, bounding_box.x2, bounding_box.y2);

        actor.continue_paint ();
    }

    public virtual Clutter.ActorBox get_bounding_box () {
        var size = border_size * scale_factor;
        var bounding_box = Clutter.ActorBox ();

        bounding_box.set_origin (-size, -size);
        bounding_box.set_size (actor.width + size * 2, actor.height + size * 2);

        return bounding_box;
    }
}