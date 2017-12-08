all:
	valac --pkg clutter-1.0 --pkg gtk+-3.0 --pkg clutter-gtk-1.0 Window.vala Canvas.vala -o canvas
run:
	./canvas
clean:
	rm canvas