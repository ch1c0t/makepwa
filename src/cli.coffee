global.CWD = process.cwd()
global.SRC = "#{CWD}/src"
global.DIST = "#{CWD}/dist"

{ build } = require './build'
{ watch } = require './watch'
{ create } = require './create'

exports.run = ->
  [_node, _agn, command] = process.argv

  switch command
    when 'build'
      build()
    when 'watch'
      watch()
    when 'new'
      name = process.argv[3]
      create name
    else
      printHelp()


printHelp = ->
  console.log 'printHelp'
