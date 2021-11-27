{ sh } = require '@ch1c0t/sh'

exports.copyAssets = ->
  sourceDir = "#{SRC}/assets"
  if IO.exist sourceDir
    targetDir = "#{DIST}/assets"
    await IO.ensure targetDir
    await sh "cp -ru #{sourceDir}/* #{targetDir}"
