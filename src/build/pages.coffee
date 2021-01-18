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
    await IO.write "#{DIST}/#{name}.html", (pug.render injectScriptTags source)

injectScriptTags = (source) ->
  tags = glob
    .sync "#{DIST}/scripts/*.js"
    .map (script) ->
      name = basename script
      path = '"' + "/scripts/#{name}" + '"'
      "    script(src=#{path})"
    .join '\n'

  source + '\n' + tags + '\n'
