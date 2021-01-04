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

exports.createWorkers = (src) ->
  dir = "#{src}/workers"
  fs.mkdirSync dir

  fs.writeFileSync "#{dir}/sw.coffee", """
    self.oninstall = (event) ->
      console.log 'from oninstall'
      event.waitUntil Promise.resolve()

    self.onactivate = (event) ->
      console.log 'from onactivate'
      event.waitUntil Promise.resolve()

    self.onfetch = (event) ->
      console.log "Logging an HTTP request from a service worker:"
      console.log event.request
      event.respondWith fetch event.request
  """
