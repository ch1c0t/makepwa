fs = require 'fs'
{ exec } = require 'child_process'

CWD = process.cwd()
DIR = "/tmp/makepwa/path"

exports.create = (name) ->
  DIR = "#{CWD}/#{name}"

  if fs.existsSync DIR
    console.error "#{DIR} already exists."
    process.exit 1
  else
    fs.mkdirSync DIR

  spec =
    name: name
    version: '0.0.0'
    devDependencies:
      coffeescript: "^2.5.1"
      'coffee-loader': "^1.0.1"

  createPackageFile spec
  createSrc()

  exec 'npm install',
    cwd: DIR

createPackageFile = (spec) ->
  source = JSON.stringify spec, null, 2
  fs.writeFileSync "#{DIR}/package.json", source

createSrc = ->
  src = "#{DIR}/src"
  fs.mkdirSync src

  createPages src
  createStyles src
  createScripts src
  createWorkers src

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

        link(rel="stylesheet" href="/styles/main.sass")
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
      background-color: black
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
      console.log 'Service workers are not supported.'
  """

createWorkers = (src) ->
  dir = "#{src}/workers"
  fs.mkdirSync dir

  fs.writeFileSync "#{dir}/sw.coffee", """
    self.onfetch = (event) ->
      console.log "Logging an HTTP request from a service worker:"
      console.log event.request
      event.respondWith fetch event.request
  """
