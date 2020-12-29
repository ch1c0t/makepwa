{ readFileSync, writeFileSync, existsSync } = require 'fs'
path = require 'path'

webpack = require 'webpack'
YAML = require 'yaml'
coffee = require 'coffeescript'

{ failIfDirNotExists, ensureDirExists } = require '../util'

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

buildDeps = ->
  file = "#{SRC}/deps.yml"
  if existsSync file
    spec = YAML.parse readFileSync file, 'utf-8'
    
    generateWebpackEntry = (spec) ->
      ensureDirExists '/tmp/makepwa'
      entry = '/tmp/makepwa/deps.js'

      console.log spec
      source = "console.log 'dependencies will be here'"

      writeFileSync entry, (coffee.compile source)
      entry

    targetDir = "#{DIST}/scripts"
    ensureDirExists targetDir

    entry = generateWebpackEntry spec
    runWebpack { entry, output: "#{targetDir}/deps.js" }

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
  buildDeps
  buildScripts
  buildWorkers
}
