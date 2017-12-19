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

internal class HoverEffect : Clutter.Effect {
    private class Shadow {
        public int users;
        public Cogl.Texture texture;

        public Shadow (Cogl.Texture _texture) {
            texture = _texture;
            users = 1;
        }
    }

    public int shadow_size { get; construct; }
    public int shadow_spread { get; construct; }

    public float scale_factor { get; set; default = 1; }
    public uint8 shadow_opacity { get; set; default = 255; }

    Cogl.Material material;

    public HoverEffect (int shadow_size, int shadow_spread) {
        Object (shadow_size: shadow_size, shadow_spread: shadow_spread);
    }

    construct {
        material = new Cogl.Material ();
    }

    Cogl.Texture? get_shadow (int width, int height, int shadow_size, int shadow_spread) {
        var buffer = new Granite.Drawing.BufferSurface (width, height);
        buffer.context.rectangle (shadow_size - shadow_spread, shadow_size - shadow_spread,
            width - shadow_size * 2 + shadow_spread * 2, height - shadow_size * 2 + shadow_spread * 2);
        buffer.context.set_source_rgba (0, 130, 255, 1.0);
        buffer.context.fill ();

        var surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
        var cr = new Cairo.Context (surface);

        cr.set_source_surface (buffer.surface, 0, 0);
        cr.paint ();

        var texture = new Cogl.Texture.from_data (width, height, 0, Cogl.PixelFormat.BGRA_8888_PRE,
            Cogl.PixelFormat.ANY, surface.get_stride (), surface.get_data ());

        return texture;
    }

    public override void paint (Clutter.EffectPaintFlags flags)    {
        var bounding_box = get_bounding_box ();
        var shadow = get_shadow ((int) (bounding_box.x2 - bounding_box.x1), (int) (bounding_box.y2 - bounding_box.y1),
            shadow_size, shadow_spread);

        if (shadow != null) {
            material.set_layer (0, shadow);
        }

        var opacity = actor.get_paint_opacity () * shadow_opacity / 255;
        var alpha = Cogl.Color.from_4ub (255, 255, 255, opacity);
        alpha.premultiply ();

        material.set_color (alpha);

        Cogl.set_source (material);
        Cogl.rectangle (bounding_box.x1, bounding_box.y1, bounding_box.x2, bounding_box.y2);

        actor.continue_paint ();
    }

    public virtual Clutter.ActorBox get_bounding_box () {
        var size = shadow_size * scale_factor;
        var bounding_box = Clutter.ActorBox ();

        bounding_box.set_origin (-size, -size);
        bounding_box.set_size (actor.width + size * 2, actor.height + size * 2);

        return bounding_box;
    }
}