chokidar = require 'chokidar'
BS = require 'browser-sync'

{
  build
  buildPages
  buildFonts
  buildStyles
  buildDeps
  buildMainScript
  buildSWRegistration
  buildWorkers
  buildIcons
  buildManifest
} = require './build'

exports.watch = ->
  build()

  watching ['src/pages/*.html'], buildPages
  watching ['src/fonts/*'], buildFonts
  watching ['src/styles/**/*.sass'], buildStyles
  watching ['src/scripts/register_sw.coffee'], buildSWRegistration
  watching ['src/workers/**/*.coffee', 'src/scripts/**/*.js'], buildWorkers
  watching ['src/icons/icon.svg'], buildIcons
  watching ['src/manifest.yml'], buildManifest
  watching ['src/scripts/**/*.coffee', 'src/scripts/**/*.js'], ->
    buildDeps()
    buildMainScript()

  bs = BS.create()
  bs.init
    server: DIST
    files: "#{DIST}/**/*"
    open: no
    ui: no
    notify: no

watching = (array, fn) ->
  watcher = chokidar.watch array,
    persistent: true
    ignoreInitial: true

  watcher.on 'all', (event, path) ->
    console.log event, path
    fn()
