sass = require 'sass'

{ failIfDirNotExists, ensureDirExists } = require '../util'

exports.buildStyles = ->
  sourceDir = "#{SRC}/styles"
  failIfDirNotExists sourceDir

  result = sass.renderSync file: "#{sourceDir}/main.sass"

  targetDir = "#{DIST}/styles"
  ensureDirExists targetDir

  await IO.write "#{targetDir}/main.css", result.css.toString()
