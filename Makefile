DEPS = --pkg clutter-1.0 --pkg gtk+-3.0 --pkg clutter-gtk-1.0
FILES = Window.vala Canvas.vala CanvasItem.vala MoveAction.vala

all: clean build docs run

build:
	valac $(DEPS) $(FILES) -o canvas
run:
	./canvas
docs:
	rm -rf gtkcanvas || true
	valadoc $(DEPS) $(FILES) -o gtkcanvas
view-docs:
	xdg-open ./gtkcanvas/index.html
clean:
	rm canvas || true
	rm -rf gtkcanvas || true
