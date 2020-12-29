{ readFileSync, writeFileSync, existsSync } = require 'fs'
require 'path'

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

runWebpack = ({ entry, output }) ->
  dir = path.dirname output
  name = path.basename output

  load_coffee =
    test: /\.coffee$/
    use: 'coffee-loader'
  conf =
    mode: 'production'
    entry: entry
    output:
      path: dir
      filename: name
    module:
      rules: [
        load_coffee
      ]
  
  webpack conf, handleWebpackErrors

buildDependencies = ->
  file = "#{SRC}/dependencies.yml"
  if existsSync file
    spec = YAML.parse readFileSync file, 'utf-8'
    
    generateWebpackEntry = (spec) ->

buildScripts = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  runWebpack entry: "#{sourceDir}/main.coffee", output: "#{targetDir}/main.js"

buildWorkers = ->
  sourceDir = "#{SRC}/workers"
  failIfDirNotExists sourceDir

  runWebpack entry: "#{sourceDir}/sw.coffee", output: "#{DIST}/sw.js"

module.exports = {
  buildDependencies
  buildScripts
  buildWorkers
}
