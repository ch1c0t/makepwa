fs = require 'fs'

{ runWebpack } = require './common'
{ buildDefaultSW } = require './sw/default'

exports.buildWorkers = ->
  file = "#{SRC}/workers/sw.coffee"

  if fs.existsSync file
    buildCustomSW file
  else
    if COMMAND is 'build'
      buildDefaultSW()

buildCustomSW = (file) ->
  runWebpack entry: file, output: "#{DIST}/sw.js"
