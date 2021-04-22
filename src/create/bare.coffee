fs = require 'fs'
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
      makepwa: VERSION
      coffeescript: "^2.5.1"
      "coffee-loader": "^2.0.0"

  createPackageFile { spec, dir }
  createSrc { name, dir }
  createGitignore dir

  console.log "Running 'npm install'"
  exec 'npm install',
    cwd: dir

createPackageFile = ({ spec, dir }) ->
  source = JSON.stringify spec, null, 2
  fs.writeFileSync "#{dir}/package.json", source

createSrc = ({ name, dir }) ->
  src = "#{dir}/src"
  fs.mkdirSync src

  createPages src
  createStyles src
  createScripts src
  createManifest { name, src }

createPages = (src) ->
  dir = "#{src}/pages"
  fs.mkdirSync dir

  source = """
    doctype html
    html
      head
        title Title

        meta(charset="utf-8")
        meta(http-equiv="x-ua-compatible" content="ie=edge")
        meta(name="viewport" content="width=device-width, initial-scale=1.0")

        link(rel="icon" type="image/svg+xml" href="/icons/icon.svg")
        link(rel="alternate icon" href="/favicon.ico")
        link(rel="apple-touch-icon" href="/icons/180.png")

        link(rel="manifest" href="/manifest.webmanifest")

        link(rel="stylesheet" href="/styles/main.css")
      body
        #app
  """

  fs.writeFileSync "#{dir}/index.pug", source

createStyles = (src) ->
  dir = "#{src}/styles"
  fs.mkdirSync dir

  source = """
    body
      background-color: white
  """

  fs.writeFileSync "#{dir}/main.sass", source

createScripts = (src) ->
  dir = "#{src}/scripts"
  fs.mkdirSync dir

  fs.writeFileSync "#{dir}/main.coffee", """
    console.log 'from main'
  """
