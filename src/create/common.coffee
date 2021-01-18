fs = require 'fs'
YAML = require 'yaml'

exports.createManifest = ({ name, src }) ->
  icon192 =
    src: '/icons/icon.192x192.png'
    sizes: '192x192'
    type: 'image/png'

  spec =
    name: name
    short_name: name
    description: 'Some description'
    start_url: '/'
    display: 'standalone'
    background_color: 'white'
    icons: [
      icon192
    ]

  fs.writeFileSync "#{src}/manifest.yml", (YAML.stringify spec)
