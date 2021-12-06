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
  await source = await IO.read file
  await IO.write "#{DIST}/sw.js", (compile source)
