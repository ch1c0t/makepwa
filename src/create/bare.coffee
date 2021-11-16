{ exec } = require 'child_process'
{ createManifest, createGitignore } = require './common'

exports.createProject = ({ name, dir }) ->
  spec =
    name: name
    version: '0.0.0'
    scripts:
      start: 'makepwa watch'
      build: 'makepwa build'
    devDependencies:
      makepwa: "file:~/sources/coffee/makepwa"
      #makepwa: VERSION

  createPackageFile { spec, dir }
  createSrc { name, dir }
  createGitignore dir

  console.log "Running 'npm install'"
  exec 'npm install',
    cwd: dir

createPackageFile = ({ spec, dir }) ->
  source = JSON.stringify spec, null, 2
  IO.write "#{dir}/package.json", source

createSrc = ({ name, dir }) ->
  src = "#{dir}/src"
  await IO.mkdir src

  createPages src
  createStyles src
  createScripts src
  createManifest { name, src }

createPages = (src) ->
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

createStyles = (src) ->
  dir = "#{src}/styles"
  await IO.mkdir dir

  source = """
    body
      background-color: white
  """

  IO.write "#{dir}/main.sass", source

createScripts = (src) ->
  dir = "#{src}/scripts"
  await IO.mkdir dir

  IO.write "#{dir}/main.coffee", """
    console.log 'from main'
  """
