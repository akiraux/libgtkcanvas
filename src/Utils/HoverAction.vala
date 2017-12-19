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
internal class GtkCanvas.HoverAction : Object  {
    public bool toggled {
        get {
            return visible;
        } set {
            if (value && effect == null) {
                effect = new HoverEffect (1, 10);
                item.add_effect (effect);
            } else if (!value && effect != null) {
                item.remove_effect (effect);
                effect = null;
            }

            visible = value;
        }
    }

    bool visible = false;
    private unowned CanvasItem item;
    HoverEffect? effect;

    public HoverAction (CanvasItem item) {
        this.item = item;
    }

    public void toggle (bool toggle) {
        toggled = toggle;
    }
}