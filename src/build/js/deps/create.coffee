exports.CreateDeps = (deps) ->
  p deps
  origins = deps.map (dep) -> dep.origin
  imports = deps.map PrepareImport
  await CreateEntryFile { imports, origins }
  BundleDeps()

PrepareImport = (dep) ->
  if dep.origin.includes '/'
    if dep.origin.endsWith '.js'
      PrepareImportString dep
    else
      PrepareDirectoryImport dep
  else
    PrepareImportString dep

glob = require 'glob'
{ basename } = require 'path'
FindFileFor = ({ name, directory }) ->
  full_path = "#{CWD}/node_modules/#{directory}"
  files = glob.sync "#{full_path}/**/*.js", nodir: yes
  file = files.find (file) ->
    (basename file) is "#{name}.js"

  if file?
    file
  else
    console.error "Cannot find #{name} in #{full_path}"

PrepareDirectoryImport = ({ origin, name, all }) ->
  file = FindFileFor { name, directory: origin }
  PrepareImportString
    origin: file
    access: origin
    name: name
    all: all

PrepareImportString = ({ origin, access, name, all }) ->
  random = Math.random().toString(36).substr(2, 5)
  variable = "t#{random}#{Date.now()}"
  access ?= origin

  if all
    """
    import * as #{variable} from '#{origin}'
    _deps_['#{access}'] = #{variable}
    """
  else
    """
    import { #{name} as #{variable} } from '#{origin}'
    _deps_['#{access}'].#{name} = #{variable}
    """

{ compile } = require 'coffeescript'
ENTRY = "#{CWD}/esbuild/deps.js"
CreateEntryFile = ({ imports, origins }) ->
  origins = origins.map (origin) ->
    "_deps_['#{origin}'] = {}"

  source = """
    window._deps_ = {}
    #{origins.join "\n"}
    window.FROM = (string) ->
      _deps_[string]

    #{imports.join "\n"}
  """

  IO.write ENTRY, (compile source)

{ bundle } = require '../common'
BundleDeps = ->
  targetDir = "#{DIST}/scripts"
  await IO.ensure targetDir
  bundle { entry: ENTRY, output: "#{targetDir}/deps.js" }
