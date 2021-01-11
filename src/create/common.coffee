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
      event.waitUntil CACHE.then (cache) ->
        cache.addAll ASSETS

    deleteOldCaches = (event) ->
      event.waitUntil caches.keys().then (names) ->
        for name in names
          if (name.startsWith 'assets-') and (name isnt CACHE_NAME)
            caches.delete name
        Promise.resolve()

    self.oninstall = precacheAssets
    self.onactivate = deleteOldCaches


    revalidate = (request) ->
      new Promise (resolve, reject) ->
        fetch(request).then (response) ->
          if response.ok
            CACHE.then (cache) ->
              cache.put request, response.clone()
            resolve response
          else
            reject()

    getFromCache = (request) ->
      new Promise (resolve, reject) ->
        CACHE.then (cache) ->
          cache
            .match request
            .then (response) ->
              if response?.ok
                resolve response
              else
                reject()

    self.onfetch = (event) ->
      { request } = event

      return unless request.method is 'GET'
      return unless request.url.startsWith self.location.origin

      cacheResponse = getFromCache request
      networkResponse = revalidate request
      event.respondWith Promise.any [cacheResponse, networkResponse]
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
