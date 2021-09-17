{ sh } = require '@ch1c0t/sh'

exports.buildFonts = ->
  sourceDir = "#{SRC}/fonts"
  if IO.exist sourceDir
    targetDir = "#{DIST}/fonts"
    await IO.ensure targetDir
    await sh "cp -r #{sourceDir}/* #{targetDir}"
