fs = require 'fs'

exports.buildIcons = ->
  file = "#{SRC}/icons/icon.svg"

  if fs.fileExists file
    console.log 'Build icons from the provided SVG file.'
  else
    console.log 'Build icons from the default icon.'
