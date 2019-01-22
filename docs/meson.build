pkgs = [
	'--pkg=gtk+-3.0',
	'--pkg=granite',
	'--pkg=clutter-1.0',
	'--pkg=clutter-gtk-1.0'
]
if svgdep.found ()
	pkgs += ['--pkg=gsvgtk-0.8']
endif

valadoc = find_program ('valadoc', required: false)
if valadoc.found()
	outdir = CAMEL_CASE_NAME+'-'+API_VERSION
	gtkdoc_outdir = CAMEL_CASE_NAME+'-'+API_VERSION
	valacapi = run_command ('valac', '--api-version')
	driver = '--driver='+valacapi.stdout().strip()
	pkgname = '--package-name='+CAMEL_CASE_NAME+'-'+API_VERSION
	pkgversion = '--package-version='+PROJECT_VERSION
	docsdir = join_paths (get_option ('datadir'), 'devhelp','books')

	custom_target ('valadocs',
			input : sources,
			output : outdir,
			command : [valadoc,
				driver,
				'--doclet=devhelp',
				'--force',
				pkgname,
				pkgversion,
				pkgs,
				'--directory=@OUTDIR@',
				valasources],
			install : true,
			install_dir : docsdir)
endif
