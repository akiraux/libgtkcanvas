files_demo=([
        'Window.vala'
])

args = ['--vapidir='+ldir]

if svgdep.found()
	args+= ['--define=GSVGTK']
endif

executable ('gtkcanvas-demo',
        files_demo,
        vala_args: args,
	dependencies : [ deps, inc_libh_dep ],
        link_with: lib,
        install: true)
