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

prepareAssetsString = (assets) ->
  lines = assets
    .map (asset) ->
      "  '#{asset}'"
    .join '\n'
  "[\n#{lines}\n]"
exports.createWorkers = ({ src, assets }) ->
  dir = "#{src}/workers"
  fs.mkdirSync dir

  fs.writeFileSync "#{dir}/sw.coffee", """
    VERSION = '0'
    CACHE_NAME = "assets-" + VERSION
    CACHE = caches.open CACHE_NAME
    ASSETS = #{prepareAssetsString assets}

    precacheAssets = (event) ->
      console.log 'sw.js: from precacheAssets(): not implemented yet'
      event.waitUntil Promise.resolve()

    deleteOldCaches = (event) ->
      console.log 'sw.js: from deleteOldCaches(): not implemented yet'
      event.waitUntil Promise.resolve()

    self.oninstall = precacheAssets
    self.onactivate = deleteOldCaches


    logRequest = (request) ->
      console.log 'sw.js: logging a request'
      console.dir request
      console.log request.url
      console.log '\n'

    self.onfetch = (event) ->
      request = event.request
      logRequest request

      event.respondWith fetch request
  """

exports.createSWRegistration = (dir) ->
  fs.writeFileSync "#{dir}/register_service_worker.coffee", """
    if navigator.serviceWorker?.register
      window.addEventListener 'load', ->
        navigator.serviceWorker.register('/sw.js')
          .then (registration) ->
            console.log 'Service worker registration succeeded:', registration
          .catch (error) ->
            console.log 'Service worker registration failed:', error
    else
      console.log "No 'serviceWorker' in the navigator."
      console.dir navigator
  """
