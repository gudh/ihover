"use strict"
LIVERELOAD_PORT = 35728
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)

# var conf = require('./conf.'+process.env.NODE_ENV);
mountFolder = (connect, dir) ->
    connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
    require("load-grunt-tasks") grunt
    require("time-grunt") grunt
    
    # configurable paths
    yeomanConfig =
        app: "client"
        dist: "dist"

    try
        yeomanConfig.app = require("./bower.json").appPath or yeomanConfig.app
    grunt.initConfig
        yeoman: yeomanConfig
        watch:
            coffee:
                files: ["<%= yeoman.app %>/scripts/**/*.coffee"]
                tasks: ["coffee:dist"]

            # less:
            #     files: ["<%= yeoman.app %>/styles/**/*.less"]
            #     tasks: ["less:server"]

            compass:
                files: ["<%= yeoman.app %>/styles/**/*.scss"]
                tasks: ["compass:server"]                

            jade:
                files: ["<%= yeoman.app %>/templates/*.jade"]
                tasks: ["jade:server"]

            livereload:
                options:
                    livereload: LIVERELOAD_PORT

                files: [
                    "<%= yeoman.app %>/templates/*.jade"
                    # "<%= yeoman.app %>/styles/**/*.less"
                    "<%= yeoman.app %>/styles/**/*.scss"
                    ".tmp/styles/**/*.css"
                    "{.tmp,<%= yeoman.app %>}/scripts/**/*.js"
                    "{.tmp,<%= yeoman.app %>}/scripts/**/*.coffee"
                    "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}"
                ]

        connect:
            options:
                port: 9000
                
                # Change this to '0.0.0.0' to access the server from outside.
                hostname: "localhost"

            livereload:
                options:
                    middleware: (connect) ->
                        [lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, yeomanConfig.app)]

            test:
                options:
                    middleware: (connect) ->
                        [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]

            dist:
                options:
                    middleware: (connect) ->
                        [mountFolder(connect, yeomanConfig.dist)]

        open:
            server:
                url: "http://localhost:<%= connect.options.port %>"

        clean:
            dist:
                files: [
                    dot: true
                    src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
                ]

            server: ".tmp"

        jshint:
            options:
                jshintrc: ".jshintrc"

            all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/**/*.js"]

        jade:
            server:
                options:
                    pretty: true
                files: [
                    expand: true
                    cwd: "<%= yeoman.app %>/templates"
                    src: [
                        "*.jade"
                        "!layout.jade"
                    ]
                    dest: "<%= yeoman.app %>/"
                    ext: ".html"
                ]
            dist:
                options:
                    pretty: true
                files: [
                    expand: true
                    cwd: "<%= yeoman.app %>/templates"
                    src: [
                        "*.jade"
                        "!layout.jade"
                    ]
                    dest: "<%= yeoman.app %>/"
                    ext: ".html"
                ]

        # less:
        #     server:
        #         options:
        #             strictMath: true
        #             dumpLineNumbers: true
        #             sourceMap: true
        #             sourceMapRootpath: ""
        #             outputSourceFiles: true
        #         files: [
        #             expand: true
        #             cwd: "<%= yeoman.app %>/styles"
        #             src: ["ihover.less", "docs-overrides.less"]
        #             dest: ".tmp/styles"
        #             ext: ".css"                    
        #         ]
        #     min:
        #         options:
        #             strictMath: true
        #             compress: true
        #             sourceMapRootpath: ""
        #             outputSourceFiles: true
        #         files: [
        #             expand: true
        #             cwd: "<%= yeoman.app %>/styles"
        #             src: "ihover.less"
        #             dest: ".tmp/styles"
        #             ext: ".css"                    
        #         ]                
        #     dist:
        #         options:
        #             cleancss: true,
        #             report: 'min'
        #         files:
        #             '.tmp/styles/ihover.css': '<%= yeoman.app %>/styles/ihover.less'
        #             '.tmp/styles/docs-overrides.css': '<%= yeoman.app %>/styles/docs-overrides.less'

        compass:
            options:
                sassDir: "<%= yeoman.app %>/styles"
                cssDir: ".tmp/styles"
                generatedImagesDir: ".tmp/assets/"
                imagesDir: "<%= yeoman.app %>/assets"
                javascriptsDir: "<%= yeoman.app %>/scripts"
                fontsDir: "<%= yeoman.app %>/fonts"
                importPath: "<%= yeoman.app %>/bower_components"
                httpImagesPath: "/assets"
                httpGeneratedImagesPath: "/assets"
                httpFontsPath: "/fonts"
                relativeAssets: true
            dist:
                options:
                    noLineComments: true
                    debugInfo: false
                    outputStyle: 'expanded'
            min:
                options:
                    noLineComments: true
                    debugInfo: false
                    outputStyle: 'compressed'
            server:
                options:
                    debugInfo: true
        # if you want to use the compass config.rb file for configuration:
        # compass:
        #   dist:
        #     options:
        #       config: 'config.rb'

        coffee:
            server:
                options:
                    sourceMap: true
                    # join: true,
                    sourceRoot: ""
                files: [
                    expand: true
                    cwd: "<%= yeoman.app %>/scripts"
                    src: "**/*.coffee"
                    dest: ".tmp/scripts"
                    ext: ".js"
                ]
            dist:
                options:
                    sourceMap: false
                    # join: true,
                    sourceRoot: ""
                files: [
                    expand: true
                    cwd: "<%= yeoman.app %>/scripts"
                    src: "**/*.coffee"
                    dest: ".tmp/scripts"
                    ext: ".js"
                ]

        useminPrepare:
            html: "<%= yeoman.app %>/index.html"
            options:
                dest: "<%= yeoman.dist %>"
                flow:
                    steps:
                        'css': ["concat"]
                        'js': ["concat"]
                    post: []
        
        usemin:
            html: ["<%= yeoman.dist %>/**/*.html", "!<%= yeoman.dist %>/bower_components/**"]
            css: ["<%= yeoman.dist %>/styles/**/*.css"]
            options:
                dirs: ["<%= yeoman.dist %>"]

        htmlmin:
            dist:
                options: {}
                files: [
                    expand: true
                    cwd: "<%= yeoman.app %>"
                    src: ["*.html", "views/*.html"]
                    dest: "<%= yeoman.dist %>"
                ]

        
        # Put files not handled in other tasks here
        copy:
            dist:
                files: [
                    expand: true
                    dot: true
                    cwd: "<%= yeoman.app %>"
                    dest: "<%= yeoman.dist %>"
                    src: [
                        "fonts/**/*"
                        "images/**/*"
                    ]
                ]
            styles:
                expand: true
                cwd: "<%= yeoman.app %>/styles"
                dest: ".tmp/styles/"
                src: "**/*.css"

        concurrent:
            server: ["coffee:server", "jade:server", "compass:server", "copy:styles"]
            dist: ["coffee:dist", "jade:dist", "compass:dist",  "copy:styles", "htmlmin"]

 

        concat:
            options:
                separator: grunt.util.linefeed + ';' + grunt.util.linefeed
            dist:
                src: ["<%= yeoman.dist %>/jquery/jquery.min.js"]
                dest: "<%= yeoman.dist %>/scripts/app.js"

        #
        # 'concat', 'uglify' not need, "usemin" with take care of them
        # uglify:
        #     dist:
        #         files:
        #             "<%= yeoman.dist %>/scripts/app.js": [".tmp/**/*.js"]

    
    grunt.registerTask "server", (target) ->
        return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"
        grunt.task.run ["clean:server", "concurrent:server", "connect:livereload", "open", "watch"]

    grunt.registerTask "build", ["clean:dist", "jade:server", "useminPrepare", "concurrent:dist", "copy:dist", "concat", "usemin"]
    grunt.registerTask "default", ["jshint", "build"]