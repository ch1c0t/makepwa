YAML = require 'yaml'

exports.createManifest = ({ name, src }) ->
  spec =
    name: name
    short_name: name
    description: 'Some description'
    start_url: '/'
    display: 'standalone'
    background_color: 'white'

  IO.write "#{src}/manifest.yml", (YAML.stringify spec)

exports.createGitignore = (dir) ->
  IO.write "#{dir}/.gitignore", """
    node_modules
    dist.dev
    dist
  """
