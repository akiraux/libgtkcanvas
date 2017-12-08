public class GtkCanvas.CanvasItem : Clutter.Actor {
    private MoveAction move_action;

    public bool dragging = false;
    public bool clicked = false;

    construct {
        reactive = true;
        x = 200;
        y = 0;
        width = 200;
        height = 200;

        move_action = new MoveAction (this);
    }
}