YAML = require 'yaml'

icon = (size) ->
  src: "/icons/#{size}.png"
  sizes: "#{size}x#{size}"
  type: 'image/png'

exports.createManifest = ({ name, src }) ->
  spec =
    name: name
    short_name: name
    description: 'Some description'
    start_url: '/'
    display: 'standalone'
    background_color: 'white'
    icons: [
      icon 192
      icon 512
    ]

  IO.write "#{src}/manifest.yml", (YAML.stringify spec)

exports.createGitignore = (dir) ->
  IO.write "#{dir}/.gitignore", """
    node_modules
    dist.dev
    dist
  """
