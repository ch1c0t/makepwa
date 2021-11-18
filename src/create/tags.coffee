{ exec } = require 'child_process'
{ createManifest, createGitignore, createPages, createStyles } = require './common'

exports.createProject = ({ name, dir }) ->
  spec =
    name: name
    version: '0.0.0'
    scripts:
      start: 'makepwa watch'
      build: 'makepwa build'
    devDependencies:
      makepwa: "file:~/sources/coffee/makepwa"
      #makepwa: VERSION
    dependencies:
      'web.tags': '^0.0.1'

  createPackageFile { spec, dir }
  createSrc { name, dir }
  createGitignore dir

  console.log "Running 'npm install'"
  exec 'npm install',
    cwd: dir

createPackageFile = ({ spec, dir }) ->
  source = JSON.stringify spec, null, 2
  IO.write "#{dir}/package.json", source

createSrc = ({ name, dir }) ->
  src = "#{dir}/src"
  await IO.mkdir src

  createPages src
  createStyles src
  createScripts src
  createManifest { name, src }

createScripts = (src) ->
  dir = "#{src}/scripts"
  await IO.mkdir dir

  IO.write "#{dir}/main.coffee", """
    import 'web.tags'

    { div } = TAGS

    document.body [
      div 'first'
      div 'second'
    ]
  """
