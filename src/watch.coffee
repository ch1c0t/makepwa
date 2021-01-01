chokidar = require 'chokidar'
BS = require 'browser-sync'

{ build, buildPages, buildStyles, buildDeps, buildScripts, buildWorkers, buildManifest } = require './build'

exports.watch = ->
  build()

  watching ['src/pages/*.pug'], buildPages
  watching ['src/styles/*.sass'], buildStyles
  watching ['src/deps.yml'], buildDeps
  watching ['src/scripts/**/*.coffee', 'src/scripts/**/*.js'], buildScripts
  watching ['src/workers/**/*.coffee', 'src/scripts/**/*.js'], buildWorkers
  watching ['src/manifest.yml'], buildManifest

  bs = BS.create()
  bs.init
    server: './dist'
    files: './dist/**/*'
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
