exports.PrepareImport = (dep) ->
  if dep.origin.includes '/'
    if dep.origin.endsWith '.js'
      PrepareImportString dep
    else
      PrepareDirectoryImport dep
  else
    PrepareImportString dep

PrepareDirectoryImport = ({ origin, name, all }) ->
  file = FindFileFor { name, directory: origin }
  PrepareImportString
    origin: file
    access: origin
    name: name
    all: all

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
