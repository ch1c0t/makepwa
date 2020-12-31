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

      makeVariable = (string) ->
        string
          .replace '-', ''
          .replace '@', ''
          .replace '/', ''

      imports = Object
        .keys spec['import']
        .map (dep) ->
          variable = makeVariable dep
          """
          import #{variable} from '#{CWD}/node_modules/#{dep}'
          _deps_['#{dep}'] = #{variable}
          """
        .join '\n'

      reacts = Object
        .keys spec['react']
        .map (dep) ->
          variable = makeVariable dep
          components = Object
            .keys spec['react'][dep]
            .map (string) ->
              original: string, raw: "Raw_#{string}_from_#{variable}"

          rawImport = components
            .map ({ original, raw }) ->
              "#{original} as #{raw}"
            .join ', '

          toFROM = components
            .map ({ original, raw }) ->
              "_deps_['#{dep}']['#{original}'] = wrap #{raw}"
            .join '\n'

          """
          _deps_['#{dep}'] = {}
          import { #{rawImport} } from '#{CWD}/node_modules/#{dep}'

          #{toFROM}
          """
        .join '\n'

      source = """
        _deps_ = {}
        window.FROM = (string) ->
          _deps_[string]

        #{imports}

        import { wrap } from '#{CWD}/node_modules/wrapjsx'
        #{reacts}
      """

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
