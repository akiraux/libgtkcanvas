files_demo=([
        'Window.vala'
])

executable ('gtkcanvas-demo',
        files_demo,
        vala_args: [
                '--vapidir='+ldir
        ],
	dependencies : [ deps, inc_libh_dep ],
        link_with: lib,
        install: false)
