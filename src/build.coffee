{ ensureDirExists } = require './util'
{ buildDeps } = require './build/js/deps'
{ buildMainScript } = require './build/js/scripts/main'
{ buildSWRegistration } = require './build/js/scripts/register_sw'
{ buildWorkers } = require './build/js/workers'
{ buildIcons } = require './build/icons'
{ buildPages } = require './build/pages'
{ buildStyles } = require './build/styles'
{ buildManifest } = require './build/manifest'

build = ->
  ensureDirExists DIST
  ensureDirExists '/tmp/makepwa'

  await Promise.all [
    buildDeps()
    buildMainScript()
    buildSWRegistration()
    buildIcons()
    buildStyles()
    buildManifest()
  ]

  await buildPages()

  buildWorkers()

module.exports = {
  build
  buildPages
  buildStyles
  buildMainScript
  buildSWRegistration
  buildDeps
  buildWorkers
  buildIcons
  buildManifest
}
