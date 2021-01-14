path = require 'path'

webpack = require 'webpack'

exports.runWebpack = ({ entry, output }) ->
  dir = path.dirname output
  name = path.basename output

  load_coffee =
    test: /\.coffee$/
    use: 'coffee-loader'
  conf =
    mode: 'production'
    entry: entry
    output:
      path: dir
      filename: name
    module:
      rules: [
        load_coffee
      ]
  
  webpack conf, handleWebpackErrors

handleWebpackErrors = (error, stats) ->
  if error
    console.error (error.stack or error)
    if error.details
      console.error error.details
    return

  info = stats.toJson()

  if stats.hasErrors()
    console.error info.errors

  if stats.hasWarnings()
    console.warn info.warnings
