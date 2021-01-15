YAML = require 'yaml'

{ ensureDirExists } = require '../util'

exports.buildManifest = ->
  ensureDirExists "#{DIST}/icons"

  await IO.copy "#{SRC}/icons/icon.192x192.png", "#{DIST}/icons/icon.192x192.png"

  source = await IO.read "#{SRC}/manifest.yml"
  manifest = YAML.parse source
  json = JSON.stringify manifest, null, 2

  await IO.write "#{DIST}/manifest.webmanifest", json
