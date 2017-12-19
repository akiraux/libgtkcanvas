DEPS = --pkg clutter-1.0 --pkg gtk+-3.0 --pkg clutter-gtk-1.0
FILES = \
	src/Window.vala\
	src/Widgets/Canvas.vala\
	src/Widgets/CanvasItem.vala\
	src/Utils/MoveAction.vala\
	src/Utils/HoverAction.vala\

all: clean build docs

build:
	valac -X -lm $(DEPS) $(FILES) -o canvasdemo
docs:
	rm -rf gtkcanvas
	valadoc $(DEPS) $(FILES) -o gtkcanvas
view-docs:
	xdg-open ./gtkcanvas/index.html
clean:
	rm -rf gtkcanvas
