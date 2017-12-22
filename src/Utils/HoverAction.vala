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

internal class GtkCanvas.HoverAction : Object  {
    /**
     * Toggle the visibility of the HoverEffect()
     */
    public bool toggled {
        get {
            return visible;
        } set {
            if (value && effect == null) {
                effect = new HoverEffect (2);
                item.add_effect (effect);
            } else if (!value && effect != null) {
                item.remove_effect (effect);
                effect = null;
            }

            visible = value;
        }
    }

    bool visible = false;

    /**
     * Parent CanvasItem passed on mouse enter
     */
    private unowned CanvasItem item;

    /**
     * HoverEffect (int border_width ) 
     */
    private HoverEffect? effect { get; set; default = null; }

    /**
     * Initialize Class
     * @param CanvasItem item [hovered item from canvas]
     */
    public HoverAction (CanvasItem item) {
        this.item = item;
    }

    /**
     * Toggle the visibility of the bounding box
     * @param bool toggle
     * return void
     */
    public void toggle (bool toggle) {
        toggled = toggle;
    }
}