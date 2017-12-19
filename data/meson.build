deconf = configuration_data()
deconf.set('PROJECT_NAME', meson.project_name ())
deconf.set('VERSION', meson.project_version ())
deconf.set('API_VERSION', API_VERSION)
deconf.set('prefix', get_option('prefix'))
deconf.set('libdir', '${exec_prefix}/'+get_option('libdir'))

configure_file(input : 'gtkcanvas.pc.in',
	output : 'gtkcanvas-@0@.pc'.format(API_VERSION),
	configuration : deconf,
	install : true,
	install_dir : join_paths(get_option('libdir'), 'pkgconfig')
)
