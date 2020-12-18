{ readFileSync, writeFileSync } = require 'fs'
{ basename } = require 'path'

glob = require 'glob'
pug = require 'pug'
sass = require 'sass'

{ failIfDirNotExists, ensureDirExists } = require './util'

CWD = process.cwd()
SRC = "#{CWD}/src"
DIST = "#{CWD}/dist"

exports.build = ->
  ensureDirExists DIST

  buildPages()
  buildStyles()

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
