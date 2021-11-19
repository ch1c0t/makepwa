{ failIfDirNotExists, ensureDirExists } = require '../../../util'
{ Pathflow } = require 'pathflow'
{ bundle } = require '../common'

exports.buildMainScript = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  tmpDir = "#{CWD}/esbuild"
  pathflow = Pathflow
    source: sourceDir
    target: tmpDir
    oneoff: yes
    log: yes
  await pathflow 'once'

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  bundle
    entry: "#{tmpDir}/main.js"
    output: "#{targetDir}/main.js"
