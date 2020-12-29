{ readFileSync, writeFileSync } = require 'fs'

webpack = require 'webpack'
YAML = require 'yaml'

{ ensureDirExists } = require '../util'

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

module.exports = {
  buildScripts
  buildWorkers
}
