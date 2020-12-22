chokidar = require 'chokidar'

{ build, buildPages, buildStyles, buildScripts, buildWorkers, buildManifest } = require './build'

exports.watch = ->
  build()

  watching ['src/pages/*.pug'], buildPages
  watching ['src/styles/*.sass'], buildStyles
  watching ['src/scripts/**/*.coffee', 'src/scripts/**/*.js'], buildScripts
  watching ['src/workers/**/*.coffee', 'src/scripts/**/*.js'], buildWorkers
  watching ['src/manifest.yml'], buildManifest

watching = (array, fn) ->
  watcher = chokidar.watch array,
    persistent: true
    ignoreInitial: true

  watcher.on 'all', (event, path) ->
    console.log event, path
    fn()
