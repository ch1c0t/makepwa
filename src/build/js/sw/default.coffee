glob = require 'glob'

{ bundle } = require '../common'
{ compile } = require 'coffeescript'

DEFAULT_SW = '/tmp/makepwa/sw.js'

exports.buildDefaultSW = ->
  paths = glob.sync "#{DIST}/**/*", nodir: yes
  assets = paths
    .map (asset) -> asset.replace DIST, ''
    .filter (asset) -> asset isnt '/sw.js'

  CreateEntryFile [ '/', ...assets ]
  bundle entry: DEFAULT_SW, output: "#{DIST}/sw.js"

prepareAssetsString = (assets) ->
  lines = assets
    .map (asset) ->
      "  '#{asset}'"
    .join '\n'
  "[\n#{lines}\n]"

CreateEntryFile = (assets) ->
  js = compile """
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

  await IO.write DEFAULT_SW, js
