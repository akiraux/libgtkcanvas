

public class GtkCanvas.Canvas : GtkClutter.Embed {

    construct {
        var actor = get_stage ();
        actor.background_color = Clutter.Color.from_string ("white");

        set_use_layout_size (true);
    }

    public void add_test_shape (string color) {
        var item = new CanvasItem ();
        item.background_color = Clutter.Color.from_string (color);

        item.rotation_angle_z = 50.0;

        var rotate = new Clutter.RotateAction ();
        rotate.rotate (item, 45.0);

        get_stage ().add_child (item);
    }
}