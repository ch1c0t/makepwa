fs = require 'fs'

pug = require 'pug'
sharp = require 'sharp'

{ ensureDirExists } = require '../util'

DEFAULT_ICON = '/tmp/makepwa/icon.svg'

exports.buildIcons = ->
  ensureDirExists "#{DIST}/icons"

  file = "#{SRC}/icons/icon.svg"

  if fs.existsSync file
    buildIconsFrom file
  else
    await createDefaultIcon()
    buildIconsFrom DEFAULT_ICON

createDefaultIcon = ->
  source = """
    svg(xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512")
      rect(width="100%" height="100%" fill="#f0f0f0")
      circle(cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red")
  """

  IO.write DEFAULT_ICON, (pug.render source)

buildIconsFrom = (file) ->
  sizes = [
    32
    180
    192
    512
  ]

  for size in sizes
    await sharp file
      .resize size
      .png()
      .toFile "#{DIST}/icons/#{size}.png"

  await IO.move "#{DIST}/icons/32.png", "#{DIST}/favicon.ico"
