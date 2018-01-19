subdir('Utils')
subdir('Widgets')

# Keep this updated to generate docs
valasources=files_widgets+files_utils+files_shapes
sources = files([])

vapidir = join_paths (get_option('datadir'),'vala','vapi')
GIR_NAME= VERSIONED_CAMEL_CASE_NAME+'.gir'
TYPELIB_NAME= VERSIONED_CAMEL_CASE_NAME+'.typelib'
VAPI_NAME = VERSIONED_PROJECT_NAME+'.vapi'

conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('exec_prefix', get_option('prefix'))
conf.set('libdir', join_paths (get_option ('prefix'),get_option ('libdir')))
conf.set('includedir', join_paths (get_option ('includedir'), VERSIONED_PROJECT_NAME))
conf.set('PROJECT_NAME', PROJECT_NAME)
conf.set('PROJECT_VERSION', PROJECT_VERSION)
conf.set('CAMEL_CASE_NAME', CAMEL_CASE_NAME)
conf.set('API_VERSION', API_VERSION)

configure_file(input : 'gtkcanvas.deps.in',
	output : 'gtkcanvas-@0@.deps'.format(API_VERSION),
	configuration : conf,
	install : true,
	install_dir : vapidir)

nsinfo = configure_file(input : 'namespace-info.vala.in',
	output : 'namespace-info.vala',
	configuration : conf)
namespaceinfo_dep = declare_dependency (sources : nsinfo)

confh = configuration_data ()
confh.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
confh.set_quoted('GETTEXT_PACKAGE', PROJECT_NAME)
configure_file(output : 'config.h',
	configuration : confh)

inc_libh = include_directories ('.')
inc_libh_dep = declare_dependency (include_directories : inc_libh)
ldir = meson.current_source_dir()

svg_args = []
if svgdep.found()
	deps += svgdep

	svg_args+= ['--define=GSVGTK']
endif


# LT_VERSION for ABI related changes
# From: https://autotools.io/libtool/version.html
# This rules applies to Meson 0.43
# Increase the current value whenever an interface has been added, removed or changed.
# Always increase revision value whenever an interface has been added, removed or changed.
# Increase the age value only if the changes made to the ABI are backward compatible.
# Set version to the value of subtract age from current
# Reset current and version to 1 and, age and version to 0 if library's name is changed
LT_CURRENT='1'
LT_REVISION='0'
LT_AGE='0'
LT_VERSION='1'
lib = library(VERSIONED_PROJECT_NAME,
	files_utils+files_widgets+files_shapes,
	version : LT_VERSION,
	soversion : LT_VERSION+'.'+LT_AGE+'.'+LT_REVISION,
	vala_header : PROJECT_NAME+'.h',
	vala_vapi : VAPI_NAME,
	vala_gir : GIR_NAME,
	vala_args: svg_args,
	dependencies : [namespaceinfo_dep, deps],
	install : true,
	install_dir : [
		true,
		join_paths (get_option('includedir'),VERSIONED_PROJECT_NAME),
		vapidir,
		true
	])


g_ir_compiler = find_program('g-ir-compiler')
custom_target('typelib',
	command: [
		g_ir_compiler,
		'--shared-library', 'lib'+PROJECT_NAME+'-@0@.so'.format (API_VERSION),
		'--output', '@OUTPUT@',
		join_paths(meson.current_build_dir(), GIR_NAME)
	],
	output: TYPELIB_NAME,
	depends: lib,
	install: true,
	install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))

