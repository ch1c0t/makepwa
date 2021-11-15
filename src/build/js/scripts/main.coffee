{ failIfDirNotExists, ensureDirExists } = require '../../../util'
{ Pathflow } = require 'pathflow'
{ bundle } = require '../common'

exports.buildMainScript = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  tmpDir = '/tmp/makepwa/scripts'
  Pathflow
    source: sourceDir
    target: tmpDir
    oneoff: yes
    log: yes

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  bundle
    entry: "#{tmpDir}/main.js"
    output: "#{targetDir}/main.js"
