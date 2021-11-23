{ PrepareImport } = require './create/PrepareImport'
{ CreateEntryFile } = require './create/CreateEntryFile'
{ BundleDeps } = require './create/BundleDeps'

exports.CreateDeps = (deps) ->
  entry = "#{CWD}/esbuild/deps.js"
  origins = deps.map (dep) -> dep.origin
  imports = deps.map PrepareImport
  await CreateEntryFile { imports, origins, entry }
  BundleDeps { entry }
