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

int main (string argv[]) {
    GtkClutter.init (ref argv);

    var window = new Gtk.Window ();
    window.title = "GtkCanvas (Gcav) Demo";

    window.resize (1000, 800);

    var canvas = new Gcav.Canvas (600, 400);

    canvas.clicked.connect ((modifier) => {
        canvas.resizer.visible = false;
    });

    var canvas_label = new Gtk.Label ("Canvas Properties");
    canvas_label.get_style_context ().add_class ("h4");

    var width = new Gtk.SpinButton.with_range (100, 10000, 10);
    width.value = canvas.width;
    width.value_changed.connect (() => {
        canvas.width = (int) width.value;
    });

    var height = new Gtk.SpinButton.with_range (100, 10000, 10);
    height.value = canvas.height;
    height.value_changed.connect (() => {
        canvas.height = (int) height.value;
    });

    var testing_grid = new Gtk.Grid ();
    testing_grid.orientation = Gtk.Orientation.VERTICAL;
    testing_grid.row_spacing = 6;

    var new_circle = new Gtk.Button.with_label ("Add Circle");
    new_circle.clicked.connect (() => {
        var actor = canvas.add_shape ("circle", "green", 0.0);

        // Example on how you can add an animation
        actor.set_pivot_point (0.5f, 0.5f);
        actor.set_scale (0.01f, 0.01f);
        actor.opacity = 0;

        actor.save_easing_state ();
        actor.set_easing_mode (Clutter.AnimationMode.EASE_OUT_EXPO);
        actor.set_easing_duration (200);
        actor.set_scale (1.0f, 1.0f);
        actor.opacity = 255U;
        actor.restore_easing_state ();
    });
    var new_shape = new Gtk.Button.with_label ("Add Rectangle");
    new_shape.clicked.connect (() => {
        var actor = canvas.add_shape ("rectangle", "red", 0.0);

        // Example on how you can add an animation
        actor.set_pivot_point (0.5f, 0.5f);
        actor.set_scale (0.01f, 0.01f);
        actor.opacity = 0;

        actor.save_easing_state ();
        actor.set_easing_mode (Clutter.AnimationMode.EASE_OUT_EXPO);
        actor.set_easing_duration (200);
        actor.set_scale (1.0f, 1.0f);
        actor.opacity = 255U;
        actor.restore_easing_state ();
    });

    var new_svg = new Gtk.Button.with_label ("Add SVG");
    new_svg.clicked.connect (() => {
        Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
            "Select a SVG file", window, Gtk.FileChooserAction.OPEN,
            "_Cancel",
            Gtk.ResponseType.CANCEL,
            "_Open",
            Gtk.ResponseType.ACCEPT);
        chooser.set_select_multiple (false);
        var filter = new Gtk.FileFilter();
        filter.add_pattern("*.svg");
        filter.set_filter_name("SVG files");
        chooser.add_filter(filter);
        chooser.run ();
        chooser.close ();

        if (chooser.get_file () != null) {
          string contents;
          var file_choosed = chooser.get_file();
          GLib.FileUtils.get_contents(file_choosed.get_path(), out contents, null);
          var actor = canvas.add_shape ("svg", "red", 0.0);
          (actor as GSvgtk.ActorClutter).set_svg_string(contents);
          // Example on how you can add an animation
          actor.set_pivot_point (0.5f, 0.5f);
          actor.set_scale (0.01f, 0.01f);
          actor.opacity = 0;

          actor.save_easing_state ();
          actor.set_easing_mode (Clutter.AnimationMode.EASE_OUT_EXPO);
          actor.set_easing_duration (200);
          actor.set_scale (1.0f, 1.0f);
          actor.opacity = 255U;
          actor.restore_easing_state ();
        }

    });
    testing_grid.add (canvas_label);
    testing_grid.add (width);
    testing_grid.add (height);
    testing_grid.add (new_shape);
    testing_grid.add (new_circle);
    testing_grid.add (new_svg);

    var main_grid = new Gtk.Grid ();
    main_grid.margin = 6;
    main_grid.column_spacing = 6;
    main_grid.orientation = Gtk.Orientation.HORIZONTAL;

    var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);

    main_grid.add (canvas);
    main_grid.add (separator);
    main_grid.add (testing_grid);

    window.add (main_grid);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}
