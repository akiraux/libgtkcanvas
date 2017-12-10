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
    window.title = "GtkCanvas Demo";

    var canvas = new GtkCanvas.Canvas ();
    canvas.add_test_shape ("blue", 45.0);
    canvas.add_test_shape ("red", 30.0);
    canvas.add_test_shape ("green", 0.0);
    window.add (canvas);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}