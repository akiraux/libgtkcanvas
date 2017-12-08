
/**
 * Manages and controls a CanvasItem's movement
 */
internal class GtkCanvas.MoveAction : Clutter.DragAction {
    private int x_offset_press = 0;
    private int y_offset_press = 0;

    private unowned CanvasItem item;

    public MoveAction (CanvasItem item) {
        this.item = item;

        drag_begin.connect (() => on_move_begin ());
        drag_end.connect (() => on_move_end ());

        item.add_action (this);
    }

    private void on_move_begin () {
        float px, py;
        get_press_coords (out px, out py);

        x_offset_press = (int)(px - item.x);
        y_offset_press = (int)(py - item.y);

        item.clicked = true;
        item.dragging = false;
    }

    protected override bool drag_progress (Clutter.Actor actor, float delta_x, float delta_y) {
        if (!item.clicked) {
            return false;
        }

        float motion_x, motion_y;
        get_motion_coords (out motion_x, out motion_y);

        item.x = (int)motion_x - x_offset_press;
        item.y = (int)motion_y - y_offset_press;

        if (!item.dragging) {
            item.dragging = true;
        }

        return false;
    }


    private void on_move_end () {
        item.clicked = false;

        if (item.dragging) {
            item.dragging = false;
        }
    }
}