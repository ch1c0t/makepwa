{ ensureDirExists } = require './util'
{ buildDeps } = require './build/js/deps'
{ buildMainScript } = require './build/js/scripts/main'
{ buildSWRegistration } = require './build/js/scripts/register_sw'
{ buildWorkers } = require './build/js/workers'
{ buildPages } = require './build/pages'
{ buildStyles } = require './build/styles'
{ buildManifest } = require './build/manifest'

build = ->
  ensureDirExists DIST

  await Promise.all [
    buildDeps()
    buildMainScript()
    buildSWRegistration()
    buildPages()
    buildStyles()
    buildManifest()
  ]

  buildWorkers()

module.exports = {
  build
  buildPages
  buildStyles
  buildMainScript
  buildSWRegistration
  buildDeps
  buildWorkers
  buildManifest
}
