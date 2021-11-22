{ FindFileDeps } = require './find/FindFileDeps'
glob = require 'glob'

exports.FindDeps = ->
  deps = []
  files = glob.sync "#{SRC}/**/*.coffee", nodir: yes

  for file in files
    source = await IO.read file
    FileDeps = FindFileDeps source
    deps.push FileDeps...

  deps
