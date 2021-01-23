YAML = require 'yaml'

{ ensureDirExists } = require '../util'

exports.buildManifest = ->
  source = await IO.read "#{SRC}/manifest.yml"
  manifest = YAML.parse source
  manifest.icons ?= icons()
  json = JSON.stringify manifest, null, 2

  await IO.write "#{DIST}/manifest.webmanifest", json

icon = (size) ->
  src: "/icons/#{size}.png"
  sizes: "#{size}x#{size}"
  type: 'image/png'

icons = ->
  [
    icon 192
    icon 512
  ]
