{ failIfDirNotExists, ensureDirExists } = require '../../util'
{ runWebpack } = require './common'

exports.buildScripts = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  runWebpack entry: "#{sourceDir}/main.coffee", output: "#{targetDir}/main.js"
