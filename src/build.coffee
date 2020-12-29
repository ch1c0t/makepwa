{ readFileSync, writeFileSync, copyFile } = require 'fs'
{ basename } = require 'path'

glob = require 'glob'
pug = require 'pug'
sass = require 'sass'
YAML = require 'yaml'

{ failIfDirNotExists, ensureDirExists } = require './util'
{ buildDependencies, buildScripts, buildWorkers } = './build/js'

build = ->
  ensureDirExists DIST

  buildPages()
  buildStyles()

  buildDependencies()
  buildScripts()
  buildWorkers()

  buildManifest()

buildPages = ->
  dir = "#{SRC}/pages"
  failIfDirNotExists dir

  sources = glob.sync "#{dir}/*.pug"
  names = sources.map (file) -> basename file, '.pug'

  for source, i in sources
    fn = pug.compile readFileSync source, 'utf-8'
    writeFileSync "#{DIST}/#{names[i]}.html", fn()

buildStyles = ->
  sourceDir = "#{SRC}/styles"
  failIfDirNotExists sourceDir
  result = sass.renderSync file: "#{sourceDir}/main.sass"

  targetDir = "#{DIST}/styles"
  ensureDirExists targetDir
  writeFileSync "#{targetDir}/main.css", result.css.toString()

buildManifest = ->
  ensureDirExists "#{DIST}/icons"
  copyFile "#{SRC}/icons/icon.192x192.png", "#{DIST}/icons/icon.192x192.png", (error) ->
    throw error if error

  manifest = YAML.parse readFileSync "#{SRC}/manifest.yml", 'utf-8'
  json = JSON.stringify manifest, null, 2

  writeFileSync "#{DIST}/manifest.webmanifest", json

module.exports = {
  build
  buildPages
  buildStyles
  buildDependencies
  buildScripts
  buildWorkers
  buildManifest
}
