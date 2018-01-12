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

/**
 * This is a widget that holds and renders {@link GtkCanvas.CanvasItem} and their subclasses
 *
 * This class should take care of zoom-in/out, and maintaing the aspect ratio of this and it's CanvasItems when the canvas is resized.
 */
public class GtkCanvas.Canvas : Gtk.AspectFrame {
    /**
     * Signal triggered when a {@link GtkCanvas.CanvasItem} on this canvas is selected by the user.
     *
     * @param item The canvas item which triggered the event.
     * @param modifiers A mask that contains all the modifiers for the event such as if Shift/Ctrl were pressed, or which button on the mouse was clicked.
     */
    public signal void item_selected (CanvasItem item, Clutter.ModifierType modifiers);

    /**
     * Signal triggered when the canvas is clicked, but not any of the items in this
     */
    public signal void clicked (Clutter.ModifierType modifiers);

    private List<CanvasItem> items;

    private int current_allocated_width;
    private float current_ratio = 1.0f;

    private GtkClutter.Embed stage;

    /**
    * The resizer the {@link GtkCanvas.CanvasItem}s in this canvas will use.
    *
    * Can be overwritten to make the items use a different style of resizer.
    */
    public ItemResizer resizer { get; protected set; }

    /**
    * This value controls the zoom level the items will use.
    * A value of 0.5 will make items half as big, while a value of 2.0 make them twice as large
    *
    * Defaults to 1.0, and must be larger than 0. Currently does not do anything until scrolling gets implemented
    */
    public float zoom_level {
        get {
            return _zoom_level;
        } set {
            if (value < 1) return;

            //_zoom_level = value;
            update_current_ratio ();
        }
    }
    private float _zoom_level = 1.0f;

   /**
    * The "virtual" width of the canvas. This is the size in pixels that the canvas will represent.
    *
    * Defaults to 100, and must be larger than 0
    */
    public int width {
        get {
            return _width;
        } set {
            if (value < 1) return;

            _width = value;
            ratio = (float) width / height;
            update_current_ratio ();
        }
    }
    private int _width = 100;

    /**
    * The "virtual" height of the canvas. This is the size in pixels that the canvas will represent.
    *
    * Defaults to 100, and must be larger than 0
    */
    public int height {
        get {
            return _height;
        } set {
            if (value < 1) return;

            _height = value;
            ratio = (float) width / height;
            update_current_ratio ();
        }
    }
    private int _height = 100;

    /**
    * Creates a new {@link GtkCanvas.Canvas}.
    *
    * @param width the width in px the canvas will represent
    * @param height the height in px the canvas will represent
    */
    public Canvas (int width, int height) {
        Object (width: width, height: height, obey_child: false);
    }

    private bool item_clicked = false;

    construct {
        stage = new GtkClutter.Embed ();
        stage.set_use_layout_size (false);

        var actor = stage.get_stage ();

        items = new List<CanvasItem>();
        resizer = new ItemResizer (actor);

        var drag_action = new Clutter.DragAction ();
        actor.add_action (drag_action);

        drag_action.drag_end.connect ((a, x, y, modifiers) => {
            if (!item_clicked) {
                clicked (modifiers);
            }

            item_clicked = false;
        });

        resizer.resize_start.connect (() => {
            item_clicked = true;
        });

        item_selected.connect (() => {
            item_clicked = true;
        });

        add (stage);
    }

    /**
    * Adds a test shape. Great for testing the library!
    *
    * @param type the shape to be generated [rectangle, circle]
    * @param color the color the test-shape will be, in CSS format
    * @param rotation the amount of degrees the item will be rotated
    */
    public CanvasItem add_shape (string type, string color, double rotation) {
        CanvasItem item;

        switch (type) {
            case "rectangle":
                item = new ShapeRectangle (color, rotation);
            break;
            case "circle":
                item = new ShapeCircle (color, rotation);
            break;
            case "svg":
                item = new ShapeSVG ();
            break;
            default:
                item = new ShapeRectangle (color, rotation);
            break;
        }

        add_item (item);
        return item;
    }

    /**
    * Adds a {@link CanvasItem} to this
    *
    * @param item the canvas item to be added
    */
    public void add_item (CanvasItem item) {
        items.prepend (item);
        stage.get_stage ().add_child (item);
        item.apply_ratio (current_ratio);

        item.selected.connect ((modifiers) => {
            item_selected (item, modifiers);
            resizer.select_item (item);
        });
    }

    /**
    * Removes a {@link CanvasItem} from this
    *
    * @param item the canvas item to be removed
    */
    public void remove_item (CanvasItem item) {
        items.remove (item);
        stage.get_stage ().remove_child (item);
    }

    /**
    * Returns a read-only list of all the {@link GtkCanvas.CanvasItem}s on this canvas
    */
    public List<weak CanvasItem> get_items () {
        return items.copy ();
    }

    private void update_current_ratio () {
        current_allocated_width = stage.get_allocated_width ();
        if (current_allocated_width < 0) return;

        current_ratio = ((float) (current_allocated_width) / width) * zoom_level;

        foreach (var item in items) {
            item.apply_ratio (current_ratio);
        }
    }

    /**
    * For internal usage
    */
    public override bool draw (Cairo.Context cr) {
        if (current_allocated_width != stage.get_allocated_width ()) {
            update_current_ratio ();
        }

        return base.draw (cr);
    }
}
