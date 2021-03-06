gulp = require("gulp-help")(require("gulp"))

coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"

jade = require "gulp-jade"
templateCache = require "gulp-angular-templatecache"

stylus = require "gulp-stylus"
stylint = require "gulp-stylint"

browserSync = require('browser-sync').create()
reload = browserSync.reload
debug = require "gulp-debug"

concat = require "gulp-concat"
gif = require "gulp-if"
del = require "del"
rename = require "gulp-rename"
sourcemaps = require "gulp-sourcemaps"
util = require "gulp-util"
cached = require "gulp-cached"
shell = require "gulp-shell"
modRewrite = require "connect-modrewrite"
uglify = require "gulp-uglify"

COPY_FILES =
    img: [
        "./app/statics/assets/images/**/*.*"
    ]
    fonts: [
        "./app/statics/assets/fonts/*.*"
        "./bower_components/bootstrap/dist/fonts/*.*"
        "./bower_components/flat-ui/dist/fonts/**/*.*"
    ]

BASEURL = "http://localhost:3123"

APP_FILES = "./app/**/*.coffee"
STYL_FILES = "./app/**/*.styl"

BUILD =
    source:
        coffee: [
            "./app/init-deps.coffee"
            "./app/app.coffee"
            "./app/app-controller.coffee"
            "./app/**/*.coffee"
        ]
        stylus: [
            "./app/statics/master.styl"
        ]
        jade: [
            "./app/**/*.jade"
        ]
        html: [
            "./build/html/**/*.html"
        ]
        config: [
            "./app/statics/constants/config.json"
        ]
    plugins:
        js: [
            "./bower_components/jquery/dist/jquery.js"
            "./bower_components/jquery-ui/jquery-ui.min.js"
            "./bower_components/angular/angular.js"
            "./bower_components/angular-ui-router/release/angular-ui-router.js"
            "./bower_components/flat-ui/dist/js/flat-ui.js"
            "./bower_components/d3/d3.js"
            "./bower_components/c3/c3.js"
            "./bower_components/chroma-js/chroma.js"
            "./bower_components/leaflet/dist/leaflet-src.js"
            "./bower_components/Leaflet.heat/dist/leaflet-heat.js"
            "./bower_components/angular-leaflet-directive/dist/angular-leaflet-directive.js"
        ]
        css: [
            "./bower_components/bootstrap/dist/css/bootstrap.css"
            "./bower_components/bootstrap-tagsinput/dist/bootstrap-tagsinput.css"
            "./bower_components/flat-ui/dist/css/flat-ui.css"
            "./bower_components/leaflet/dist/leaflet.css"
            "./bower_components/c3/c3.css"
        ]
    dirs:
        out: "./build"
        js: "./build/js"
        css: "./build/css"
        html: "./build/html"
        fonts: "./build/fonts"
        images: "./build/images"
        docs: "./docs"
    module: "app"
    app: "app.js"
    plugin:
        js: "plugins.js"
        css: "plugins.css"

###
    MAIN TASKS
###

gulp.task "config:develop",
    "Setting up config for development environment", ->
        gulp.src BUILD.source.config
        .pipe gulp.dest BUILD.dirs.js

gulp.task "default",
    "Runs 'develop' and 'test'.",
    [
        "develop"
    ]

gulp.task "develop",
    "Watches/Build and Test the source files on change.",
    [
        "config:develop"
        "build"
        "run"
    ]

gulp.task "dev",
    "Shorthand for develop.",
    [
        "develop"
    ]

gulp.task "build",
    "Lints and builds the project to '#{BUILD.dirs.out}'.",
    [
        "copy"
        "build:plugins:js"
        "build:plugins:css"
        "build:source:coffee:watch"
        "build:source:stylus:watch"
        "build:source:jade:watch"
    ]
    ->
        reload()

###
    LINTING
###
gulp.task "lint:coffee",
    "Lints all CoffeeScript source files.",
    ->
        gulp.src APP_FILES
        #.pipe cached "lint:coffee"
        .pipe coffeelint()
        .pipe coffeelint.reporter()

gulp.task "lint:stylus",
    "Lints all Stylus source files.",
    ->
        gulp.src STYL_FILES
        .pipe cached "lint:stylus"
        .pipe stylint
            config: './.stylintrc'

###
    BUILDING PLUGINS
###
gulp.task "build:plugins:js",
    "Concatenates and saves '#{BUILD.plugin.js}' to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.plugins.js
        #.pipe cached "plugins.js"
        .pipe gif "*.js", concat(BUILD.plugin.js)
        .pipe gif "*.js", gulp.dest(BUILD.dirs.js)

gulp.task "build:production:plugins:js",
    "Uglifies, concatenates and saves '#{BUILD.plugin.js}' for production to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.plugins.js
        #.pipe uglify()
        .pipe gif "*.js", concat(BUILD.plugin.js)
        .pipe gif "*.js", gulp.dest(BUILD.dirs.js)

gulp.task "build:plugins:css",
    "Concatenates and saves '#{BUILD.dirs.css}' to '#{BUILD.dirs.css}'.",
    ->
        gulp.src BUILD.plugins.css
        #.pipe cached "plugins.css"
        .pipe gif "*.css", concat(BUILD.plugin.css)
        .pipe gif "*.css", gulp.dest(BUILD.dirs.css)

###
    BUILDING SOURCE
###
gulp.task "build:source:coffee",
    "Compiles and concatenates all coffeescript files to '#{BUILD.dirs.js}'.",
    [
        "lint:coffee"
    ]
    ->
        gulp.src BUILD.source.coffee
        .pipe sourcemaps.init()
        .pipe coffee().on "error", util.log
        .pipe concat(BUILD.app)
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.js)

gulp.task "build:source:stylus",
    "Compiles and concatenates all stylus files to '#{BUILD.dirs.css}'.",
    [
        "lint:stylus"
    ]
    ->
        gulp.src BUILD.source.stylus
        .pipe sourcemaps.init()
        .pipe stylus
            compress: true
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.css)


gulp.task "build:source:jade",
    "Compiles and concatenates all jade files to '#{BUILD.dirs.html}'.",
    ->
        gulp.src BUILD.source.jade
        .pipe jade
            pretty: true
        .pipe gulp.dest(BUILD.dirs.html)

gulp.task "build:copy",
    "Copies master.html to '#{BUILD.dirs.out}/static'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe gif "**/master.html", gulp.dest ( BUILD.dirs.out )

gulp.task "build:cache",
    "Caches all angular.js templates in '#{BUILD.dirs.js}'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe templateCache(module: BUILD.module)
        .pipe gulp.dest ( BUILD.dirs.js )

###
    COPY STATICS
###
gulp.task "copy",
    "Copy all assets to '#{BUILD.dirs.out}' dir.",
    [
        "copy:img"
        "copy:fonts"
    ]

gulp.task "copy:img",
    false,
    ->
        gulp.src COPY_FILES.img
        #.pipe cached "copy:img"
        .pipe gulp.dest BUILD.dirs.images

gulp.task "copy:fonts",
    false,
    ->
        gulp.src COPY_FILES.fonts
        #.pipe cached "copy:fonts"
        .pipe gif "**/flat-ui-icons-regular.*", rename (path) ->
            path.dirname = "/glyphicons"
        .pipe gif "**/lato*", rename (path) ->
            path.dirname = "/lato"
        .pipe gulp.dest BUILD.dirs.fonts

###
    CLEANING
###

gulp.task "clean",
    "Clear '#{BUILD.dirs.out}' and '#{BUILD.dirs.docs}' folder.",
    (cb) ->
        del [BUILD.dirs.out, BUILD.dirs.docs], -> cb null, []

gulp.task "clean:build",
    false,
    (cb) ->
        del BUILD.dirs.out, -> cb null, []

gulp.task "clean:docs",
    false,
    (cb) ->
        del BUILD.dirs.docs, -> cb null, []

gulp.task "clean:html",
    false,
    [
        "build:copy"
    ]
    (cb) ->
        del BUILD.dirs.html, -> cb null, []

###
    BROWSERSYNC SERVER
###
gulp.task "run", "Serves the App.",
    [
        "build"
    ],
    ->
        browserSync.init
            server:
                baseDir: BUILD.dirs.out
                index: "/statics/master.html"
                middleware: [modRewrite(['!\\.\\w+$ /statics/master.html [L]'])]
            open: false
            port: 3123
            ui:
                port: 3124
                weinre: 3125
            logLevel: "info"
            notify: false
            logPrefix: "VIDATIO"

###
    LIVE-RELOAD
###

gulp.task "build:source:coffee:reload",
    false,
    [
        "build:source:coffee"
    ]
    ->
        reload()


gulp.task "build:source:stylus:reload",
    false,
    [
        "build:source:stylus"
    ]
    ->
        reload()


gulp.task "build:source:jade:reload",
    false,
    [
        "clean:html"
        "build:cache"
    ]
    ->
        reload()


###
    WATCHER
###

gulp.task "build:source:jade:watch",
    "Builds jade files from '#{BUILD.source.jade}' to '#{BUILD.dirs.out}/statics/master.html'.",
    [
        "clean:html"
        "build:cache"
    ]
    ->
        gulp.watch BUILD.source.jade, ["build:source:jade:reload"]

gulp.task "build:source:stylus:watch",
    "Builds stylus files from '#{BUILD.source.stylus}' to '#{BUILD.dirs.css}'.",
    [
        "build:source:stylus"
    ]
    ->
        gulp.watch STYL_FILES, ["build:source:stylus:reload"]

gulp.task "build:source:coffee:watch",
    "Builds coffeescript files from '#{BUILD.source.coffee}' to '#{BUILD.dirs.js}'.",
    [
        "build:source:coffee"
    ]
    ->
        gulp.watch BUILD.source.coffee, ["build:source:coffee:reload"]
