fs = require 'fs'
{ exec } = require 'child_process'

{ createManifest, createWorkers } = require './common'

exports.createProject = ({ name, dir }) ->
  spec =
    name: name
    version: '0.0.0'
    scripts:
      start: 'makepwa watch'
      build: 'makepwa build'
    devDependencies:
      makepwa: VERSION

  createPackageFile { spec, dir }
  createSrc { name, dir }

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
  createWorkers src
  createIcons src
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

        link(rel="manifest" href="/manifest.webmanifest")
        link(rel="stylesheet" href="/styles/main.css")
        script(src="/scripts/main.js")
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
    require './register_service_worker.coffee'

    console.log 'from main'
  """

  fs.writeFileSync "#{dir}/register_service_worker.coffee", """
    if 'serviceWorker' in navigator
      navigator.serviceWorker.register('/sw.js')
        .then (registration) ->
          console.log 'Service worker registration succeeded:', registration
        .catch (error) ->
          console.log 'Service worker registration failed:', error
    else
      console.log "No 'serviceWorker' in the navigator."
  """

createIcons = (src) ->
  dir = "#{src}/icons"
  fs.mkdirSync dir
  
  fs.copyFile "#{__dirname}/icon.192x192.png", "#{src}/icons/icon.192x192.png", (error) ->
    throw error if error
