project('gtkcanvas', [ 'vala', 'c'], version : '0.1.0')

PROJECT_NAME = 'gcav'
API_VERSION = '0.4'
PROJECT_VERSION = meson.project_version()
VERSIONED_PROJECT_NAME = PROJECT_NAME+'-'+API_VERSION
CAMEL_CASE_NAME = 'Gcav'
VERSIONED_CAMEL_CASE_NAME = CAMEL_CASE_NAME +'-'+ API_VERSION

cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required: true)

deps = ([dependency('gtk+-3.0', version:'>=3.18'),
        dependency('clutter-gtk-1.0', version:'>=1.6'),
        dependency('granite', version:'>=0.3'),
        dependency('cairo', version:'>=1.14'),
        dependency('gee-0.8'),
        m_dep
])

svgdep = dependency('gsvgtk-0.8', version:'>=0.6.3', required: false)


inc_rooth = include_directories ('.')
inc_rooth_dep = declare_dependency (include_directories : inc_rooth)


#subdir('po')
subdir('src')
subdir('data')
subdir('docs')
subdir('demo')
#subdir('tests')
