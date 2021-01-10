fs = require 'fs'
{ exec } = require 'child_process'

{ createManifest, createWorkers, createSWRegistration } = require './common'

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
    dependencies:
      "@material-ui/core": "^4.11.2"
      react: "^17.0.1"
      "react-dom": "^17.0.1"
      wrapjsx: "^0.0.3"

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
  createIcons src
  createManifest { name, src }
  createDeps src

  assets = [
    '/'
    '/index.html'
    '/manifest.webmanifest'
    '/styles/main.css'
    '/scripts/deps.js'
    '/scripts/deps.js.LICENSE.txt'
    '/scripts/main.js'
    '/icons/icon.192x192.png'
  ]
  createWorkers { src, assets }

createPages = (src) ->
  dir = "#{src}/pages"
  fs.mkdirSync dir

  source = """
    doctype html
    html
      head
        title ReactMaterial

        meta(charset="utf-8")
        meta(http-equiv="x-ua-compatible" content="ie=edge")
        meta(name="viewport" content="width=device-width, initial-scale=1.0")

        link(rel="manifest" href="/manifest.webmanifest")

        link(rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap")
        link(rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons")
        link(rel="stylesheet" href="/styles/main.css")
      body
        #app

        script(src="/scripts/deps.js")
        script(src="/scripts/main.js")
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

    { useState } = FROM 'react'
    { render } = FROM 'react-dom'

    { fragment } = FROM 'wrapjsx'

    { Button } = FROM '@material-ui/core'

    App = fragment [
      Button color: 'primary', 'First button'
      Button color: 'primary', 'Second button'
    ]

    render App, (document.getElementById 'app')
  """

  createSWRegistration dir

createIcons = (src) ->
  dir = "#{src}/icons"
  fs.mkdirSync dir
  
  fs.copyFile "#{__dirname}/icon.192x192.png", "#{src}/icons/icon.192x192.png", (error) ->
    throw error if error

createDeps = (src) ->
  spec = """
    import:
      react:
      react-dom:
      wrapjsx:

    react:
      '@material-ui/core':
        Button:
  """

  fs.writeFileSync "#{src}/deps.yml", spec
