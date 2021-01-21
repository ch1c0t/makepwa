YAML = require 'yaml'

{ ensureDirExists } = require '../util'

exports.buildManifest = ->
  source = await IO.read "#{SRC}/manifest.yml"
  manifest = YAML.parse source
  json = JSON.stringify manifest, null, 2

  await IO.write "#{DIST}/manifest.webmanifest", json
