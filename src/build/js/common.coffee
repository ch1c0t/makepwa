{ buildSync } = require 'esbuild'

exports.bundle = ({ entry, output }) ->
  params =
    entryPoints: [entry]
    outfile: output
    bundle: yes

  switch COMMAND
    when 'build'
      params.minify = yes
    when 'watch'
      params.sourcemap = yes

  buildSync params
