{ build } = require './build'
{ watch } = require './watch'

exports.run = ->
  [_node, _agn, command] = process.argv

  switch command
    when 'build'
      build()
    when 'watch'
      watch()
    else
      printHelp()


printHelp = ->
  console.log 'printHelp'
