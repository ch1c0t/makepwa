{ bundle } = require './common'
{ compile } = require 'coffeescript'
{ buildDefaultSW } = require './sw/default'

exports.buildWorkers = ->
  file = "#{SRC}/workers/sw.coffee"

  if IO.exist file
    buildCustomSW file
  else
    if COMMAND is 'build'
      buildDefaultSW()

buildCustomSW = (file) ->
  await IO.write DEFAULT_SW, (compile file)
  bundle entry: DEFAULT_SW, output: "#{DIST}/sw.js"
