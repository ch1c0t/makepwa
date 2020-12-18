fs = require 'fs'

exports.ensureDirExists = (dir) ->
  fs.mkdirSync dir unless fs.existsSync dir

exports.failIfDirNotExists = (dir) ->
  unless fs.existsSync dir
    console.log "#{dir} does not exist."
    process.exit 1
