{ ensureDirExists } = require './util'
{ buildDeps } = require './build/js/deps'
{ buildScripts } = require './build/js/scripts'
{ buildWorkers } = require './build/js/workers'
{ buildPages } = require './build/pages'
{ buildStyles } = require './build/styles'
{ buildManifest } = require './build/manifest'

build = ->
  ensureDirExists DIST

  await Promise.all [
    buildDeps()
    buildScripts()
    buildPages()
    buildStyles()
    buildManifest()
  ]

  buildWorkers()

module.exports = {
  build
  buildPages
  buildStyles
  buildDeps
  buildScripts
  buildWorkers
  buildManifest
}
