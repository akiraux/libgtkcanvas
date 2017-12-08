

public class Canvas : GtkClutter.Embed {

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

public class CanvasItem : Clutter.Actor {
    private MoveAction move_action;

    private bool dragging = false;
    private bool clicked = false;

    private int x_offset_press = 0;
    private int y_offset_press = 0;

    construct {
        reactive = true;
        x = 200;
        y = 0;
        width = 200;
        height = 200;

        move_action = new MoveAction ();
        move_action.drag_begin.connect (() => on_move_begin ());
        move_action.drag_end.connect (() => on_move_end ());
        move_action.move.connect (on_move);

        add_action (move_action);
    }

    private void on_move_begin () {
        float px, py;
        move_action.get_press_coords (out px, out py);

        x_offset_press = (int)(px - x);
        y_offset_press = (int)(py - y);

        clicked = true;
        dragging = false;
    }

    private void on_move_end () {
        clicked = false;

        if (dragging) {
            dragging = false;
        }
    }

    private void on_move () {
        if (!clicked) {
            return;
        }

        float motion_x, motion_y;
        move_action.get_motion_coords (out motion_x, out motion_y);

        x = (int)motion_x - x_offset_press;
        y = (int)motion_y - y_offset_press;

        if (!dragging) {
            dragging = true;
        }
    }
}

public class MoveAction : Clutter.DragAction {
    public float delta_x;
    public float delta_y;

    public signal void move ();

    public override bool drag_progress (Clutter.Actor actor, float delta_x, float delta_y) {
        this.delta_x = delta_x;
        this.delta_y = delta_y;

        move ();
        return false;
    }
}
