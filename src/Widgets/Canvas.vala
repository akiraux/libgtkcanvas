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
 * This is a widget that holds and renders {@link GtkCanvas.CanvasItem} and their subclasses
 *
 * This class should take care of zoom-in/out, and maintaing the aspect ratio of this and it's CanvasItems when the canvas is resized.
 */
public class GtkCanvas.Canvas : Gtk.AspectFrame {
    private List<CanvasItem> items;

    private int current_allocated_width;
    private double current_ratio;

    private GtkClutter.Embed stage;

    /**
    * This value controls the zoom level the items will use.
    * A value of 0.5 will make items half as big, while a value of 2.0 make them twice as large
    *
    * Defaults to 1.0, and must be larger than 0
    */
    public double zoom_level {
        get {
            return _zoom_level;
        } set {
            if (value > 0) {
                _zoom_level = value;
                update_current_ratio ();
            }
        }
    }
    private double _zoom_level = 1.0;

    public int width {
        get {
            return _width;
        } set {
            _width = value;
            ratio = width / height;
        }
    }
    private int _width = 100;

    public int height {
        get {
            return _height;
        } set {
            _height = value;
            ratio = width / height;
        }
    }
    private int _height = 100;

    public Canvas (int width, int height) {
        Object (width: width, height: height, obey_child: false);
    }

    construct {
        stage = new GtkClutter.Embed ();
        stage.set_use_layout_size (false);

        var actor = stage.get_stage ();
        actor.background_color = Clutter.Color.from_string ("white");

        items = new List<CanvasItem>();

        add (stage);
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

        add_item (item);
    }

    /**
    * Adds a {@link CanvasItem} to this
    *
    * @param item the canvas item to be added
    */
    public void add_item (CanvasItem item) {
        items.prepend (item);
        stage.get_stage ().add_child (item);
    }

    // TODO: Keep canvas on the same aspect ratio (like 16:9). Maybe use a Gtk.AspectFrame?
    private void update_current_ratio () {
        current_allocated_width = stage.get_allocated_width ();
        if (current_allocated_width < 0) return;

        current_ratio = ((double)(current_allocated_width) / width) * zoom_level;

        foreach (var item in items) {
            item.apply_ratio (current_ratio);
        }
    }

    public override bool draw (Cairo.Context cr) {
        if (current_allocated_width != stage.get_allocated_width ()) {
            update_current_ratio ();
        }

        return base.draw (cr);
    }
}