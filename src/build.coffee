{ readFileSync, writeFileSync } = require 'fs'
{ basename } = require 'path'

glob = require 'glob'
pug = require 'pug'
sass = require 'sass'
webpack = require 'webpack'

{ failIfDirNotExists, ensureDirExists } = require './util'

CWD = process.cwd()
SRC = "#{CWD}/src"
DIST = "#{CWD}/dist"

exports.build = ->
  ensureDirExists DIST

  buildPages()
  buildStyles()
  buildScripts()

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

buildScripts = ->
  sourceDir = "#{SRC}/scripts"
  failIfDirNotExists sourceDir

  targetDir = "#{DIST}/scripts"
  ensureDirExists targetDir

  load_coffee =
    test: /\.coffee$/
    use: (require 'coffee-loader')
  conf =
    entry: "#{sourceDir}/main.coffee"
    output:
      path: targetDir
      filename: 'main.js'
    module:
      rules: [
        load_coffee
      ]
  
  webpack conf, (error, stats) ->
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
