{ FindDeps } = require './deps/find'
{ CreateDeps } = require './deps/create'

PriorDeps = []
exports.buildDeps = ->
  deps = await FindDeps()
  if (deps.length > 0) and (not deps.sameAs PriorDeps)
    CreateDeps deps
    PriorDeps = deps
