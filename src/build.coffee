{ readFileSync, writeFileSync, copyFile } = require 'fs'
{ basename } = require 'path'

glob = require 'glob'
pug = require 'pug'
sass = require 'sass'
webpack = require 'webpack'
YAML = require 'yaml'

{ failIfDirNotExists, ensureDirExists } = require './util'

build = ->
  ensureDirExists DIST

  buildPages()
  buildStyles()
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

handleWebpackErrors = (error, stats) ->
  if error
    console.error (error.stack or error)
    if error.details
      console.error error.details
    return

  info = stats.toJson()

  if stats.hasErrors()
    console.error info.errors

  if stats.hasWarnings()
    console.warn info.warnings

buildScripts = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  load_coffee =
    test: /\.coffee$/
    use: 'coffee-loader'
  conf =
    mode: 'production'
    entry: "#{sourceDir}/main.coffee"
    output:
      path: targetDir
      filename: 'main.js'
    module:
      rules: [
        load_coffee
      ]
  
  webpack conf, handleWebpackErrors

buildWorkers = ->
  sourceDir = "#{SRC}/workers"
  failIfDirNotExists sourceDir

  load_coffee =
    test: /\.coffee$/
    use: 'coffee-loader'
  conf =
    mode: 'production'
    entry: "#{sourceDir}/sw.coffee"
    output:
      path: DIST
      filename: 'sw.js'
    module:
      rules: [
        load_coffee
      ]
  
  webpack conf, handleWebpackErrors

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
  buildScripts
  buildWorkers
  buildManifest
}
