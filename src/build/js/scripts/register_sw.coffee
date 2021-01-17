fs = require 'fs'

{ ensureDirExists } = require '../../../util'
{ runWebpack } = require '../common'

exports.buildSWRegistration = (config) ->
  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  file = "#{SRC}/scripts/register_sw.coffee"
  output = "#{targetDir}/register_sw.js"

  if fs.existsSync file
    runWebpack { entry: file, output }
  else
    if COMMAND is 'build'
      buildDefaultSWRegistration { output }

buildDefaultSWRegistration = (config) ->
  defaultFile = '/tmp/makepwa/register_sw.coffee'
  await IO.write defaultFile, """
    if navigator.serviceWorker?.register
      window.addEventListener 'load', ->
        navigator.serviceWorker.register('/sw.js')
          .then (registration) ->
            console.log 'Service worker registration succeeded:', registration
          .catch (error) ->
            console.log 'Service worker registration failed:', error
    else
      console.log "No 'serviceWorker' in the navigator."
      console.dir navigator
  """

  config.entry = defaultFile
  runWebpack config
