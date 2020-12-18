{ existsSync, readFileSync, writeFileSync } = require 'fs'
{ basename } = require 'path'

glob = require 'glob'
pug = require 'pug'

{ ensureDirExists } = require './util'

CWD = process.cwd()
DIST = "#{CWD}/dist"

exports.build = ->
  ensureDirExists DIST

  buildPages()

buildPages = ->
  dir = "#{CWD}/src/pages"
  unless existsSync dir
    console.log "#{dir} does not exist."
    process.exit 1

  sources = glob.sync "#{dir}/*.pug"
  names = sources.map (file) -> basename file, '.pug'

  for source, i in sources
    fn = pug.compile readFileSync source, 'utf-8'
    writeFileSync "#{DIST}/#{names[i]}.html", fn()
