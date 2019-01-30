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

Gtk.TreeStore tree_store;
Gtk.TreeView tree_view;
GSvg.GsDocument svg;
GSvgtk.ActorClutter actorSVG;

void show_attribute(GXml.DomElement element, string attr_name, Gtk.TreeIter? parentIter) {
  Gtk.TreeIter childIter;
  var value = element.get_attribute(attr_name);
  if (value != null) {
  //if (element.has_attribute(attr_name)) {
    tree_store.append (out childIter, parentIter);
    tree_store.set (childIter, 0, attr_name, 1, value, 2, element, -1);
  }
}

void list_childs(GXml.DomNode node, Gtk.TreeIter? parentIter) {

  foreach (GXml.DomNode child in node.child_nodes) {
    Gtk.TreeIter? childIter = parentIter;
    if (child is GXml.DomElement) {
      tree_store.append (out childIter, parentIter);
      tree_store.set (childIter, 0, child.node_name, -1);

      var element = child as GXml.DomElement;
      Gtk.TreeIter attrIter;
      tree_store.append (out attrIter, childIter);
      tree_store.set (attrIter, 0, "attributes", -1);
      //foreach (var entry in element.attributes.entries()) {
      foreach (var param in element.get_class().list_properties()) {
        //var key = entry.key;
        var key = param.get_nick();
        show_attribute(element, key, attrIter);
      }
      show_attribute(element, "style", attrIter);
      show_attribute(element, "id", attrIter);
    }
    list_childs(child, childIter);
  }
}

int main (string[] argv) {
    GtkClutter.init (ref argv);

    var window = new Gtk.Window ();
    window.title = "GtkCanvas (Gcav) Demo";

    window.resize (1000, 800);

    var canvas = new Gcav.Canvas (600, 400);

    canvas.set_size_request(600, 400);

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
          var file_choosed = chooser.get_file();
          try {
            svg = new GSvg.GsDocument ();
            svg.read_from_file (file_choosed);
            list_childs(svg, null);
            tree_view.expand_all();
            actorSVG = canvas.add_shape ("svg", "red", 0.0) as GSvgtk.ActorClutter;
            actorSVG.svg = svg;
            // Example on how you can add an animation
            actorSVG.set_pivot_point (0.5f, 0.5f);
            actorSVG.set_scale (0.01f, 0.01f);
            actorSVG.opacity = 0;

            actorSVG.save_easing_state ();
            actorSVG.set_easing_mode (Clutter.AnimationMode.EASE_OUT_EXPO);
            actorSVG.set_easing_duration (200);
            actorSVG.set_scale (1.0f, 1.0f);
            actorSVG.opacity = 255U;
            actorSVG.restore_easing_state ();
          } catch( Error e) {
          }
        }
    });
    testing_grid.add (canvas_label);
    testing_grid.add (width);
    testing_grid.add (height);
    testing_grid.add (new_shape);
    testing_grid.add (new_circle);
    testing_grid.add (new_svg);
    tree_view = new Gtk.TreeView();
    tree_view.expand = true;
    tree_store = new Gtk.TreeStore(3, typeof(string), typeof(string), typeof(GXml.DomElement));
    tree_view.set_model(tree_store);
    tree_view.insert_column_with_attributes(-1, "Type", new Gtk.CellRendererText(), "text", 0, null);
    var renderer = new Gtk.CellRendererText();
    renderer.editable = true;
    renderer.edited.connect ((path, new_text) => {
      Gtk.TreeIter iter;
      if (tree_store.get_iter_from_string (out iter, path)) {
         Value value;
         tree_store.get_value(iter, 2, out value);
         GXml.DomElement element = value.get_object() as GXml.DomElement;
         tree_store.get_value(iter, 0, out value);
         var attr_name = value.get_string();
         try {
           element.set_attribute(attr_name, new_text);
         } catch (Error e) {
         }
         tree_store.set_value(iter, 1, new_text);

         actorSVG.svg = svg;
      }
    });
    tree_view.insert_column_with_attributes(-1, "Name", renderer, "text", 1, null);
    var scroll = new Gtk.ScrolledWindow (null, null);
    scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scroll.add (tree_view);
    testing_grid.add (scroll);

    var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

    paned.add1(canvas);
    paned.add2(testing_grid);

    window.add (paned);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}
