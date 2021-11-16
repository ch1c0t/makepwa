glob = require 'glob'
{ injectHTML } = require 'node-inject-html'
{ basename } = require 'path'
{ failIfDirNotExists } = require '../util'

exports.buildPages = ->
  dir = "#{SRC}/pages"
  failIfDirNotExists dir

  files = glob.sync "#{dir}/*.html"

  for file in files
    name = basename file
    source = await IO.read file
    await IO.write "#{DIST}/#{name}", (injectScriptTags source)

injectScriptTags = (html) ->
  scripts = glob
    .sync "#{DIST}/scripts/*.js"
    .map (script) ->
      name = basename script
      path = '"' + "/scripts/#{name}" + '"'
      "<script src=#{path}></script>"
    .join '\n'

  injectHTML html, bodyEnd: scripts
