{ FindDeps } = require './deps/find'
{ CreateDeps } = require './deps/create'

exports.buildDeps = ->
  deps = await FindDeps()
  if deps.length > 0
    CreateDeps deps
