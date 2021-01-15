pug = require 'pug'
glob = require 'glob'

{ basename } = require 'path'
{ failIfDirNotExists } = require '../util'

exports.buildPages = ->
  dir = "#{SRC}/pages"
  failIfDirNotExists dir

  files = glob.sync "#{dir}/*.pug"

  for file in files
    name = basename file, '.pug'
    source = await IO.read file
    await IO.write "#{DIST}/#{name}.html", (pug.render source)
