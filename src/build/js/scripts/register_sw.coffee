{ ensureDirExists } = require '../../../util'
{ bundle } = require '../common'
{ compile } = require 'coffeescript'

REGISTER_FILE = "#{CWD}/esbuild/register_sw.js"

exports.buildSWRegistration = (config) ->
  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  file = "#{SRC}/scripts/register_sw.coffee"
  output = "#{targetDir}/register_sw.js"

  if IO.exist file
    await IO.write REGISTER_FILE, (compile file)
    bundle { entry: REGISTER_FILE, output }
  else
    if COMMAND is 'build'
      buildDefaultSWRegistration { output }

buildDefaultSWRegistration = (config) ->
  js = compile """
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
  await IO.write REGISTER_FILE, js

  config.entry = REGISTER_FILE
  bundle config
