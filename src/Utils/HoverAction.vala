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
 * Show/Hide the bounding box for the item selection
 * Clutter.Rectangle is deprecated, needs to be converted in an element that can handle border color
 */
internal class GtkCanvas.HoverAction : Clutter.Rectangle {
    public bool toggled { get { return visible; } set { visible = value; } }
    
    private unowned CanvasItem item;

    public HoverAction (CanvasItem item) {
        this.item = item;
        color = Clutter.Color.from_string ("transparent");
		has_border = true;
        border_width = 1;
        border_color = Clutter.Color.from_string ("#0082ffff");
        visible = false;

        item.add_child (this);
    }

    public void toggle (bool toggle) {
        toggled = toggle;
        // change window cursor
        // new Gtk.Cursor.from_name ("move");
        // new Gtk.Cursor.from_name ("default");
    }
}