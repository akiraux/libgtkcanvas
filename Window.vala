

int main (string argv[]) {
    Clutter.init (ref argv);
    Gtk.init (ref argv);

    var window = new Gtk.Window ();
    var canvas = new Canvas ();
    canvas.add_test_shape ("blue");
    canvas.add_test_shape ("red");
    canvas.add_test_shape ("green");
    window.add (canvas);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}