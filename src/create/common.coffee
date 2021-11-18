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

exports.createPages = (src) ->
  dir = "#{src}/pages"
  await IO.mkdir dir

  source = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">

      <title>Title</title>
      <link rel="stylesheet" href="/styles/main.css">
      <link rel="manifest" href="/manifest.webmanifest">
      <link rel="icon" type="image/svg+xml" href="/icons/icon.svg">
      <link rel="alternate icon" href="/favicon.ico">
      <link rel="apple-touch-icon" href="/icons/180.png">
    </head>
    <body>
    </body>
    </html>
  """

  IO.write "#{dir}/index.html", source

exports.createStyles = (src) ->
  dir = "#{src}/styles"
  await IO.mkdir dir

  source = """
    body
      background-color: white
  """

  IO.write "#{dir}/main.sass", source
