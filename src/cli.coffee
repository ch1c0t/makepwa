global.VERSION = '0.0.7'
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
      template = process.argv[4]
      create { name, template }
    when 'help'
      printHelp()
    else
      printHelp()


printHelp = ->
  console.log """
    A tool for making PWAs.

      new NAME [TEMPLATE]    Create the directory named NAME and a new project inside of it.
      build                  Build the project inside of the dist directory.
      watch                  Watch for changes and rebuild the project continuously.
      help                   Show this message.
  """
