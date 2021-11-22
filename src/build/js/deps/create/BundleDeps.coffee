{ bundle } = require '../../common'

exports.BundleDeps = ({ entry }) ->
  targetDir = "#{DIST}/scripts"
  await IO.ensure targetDir
  bundle { entry, output: "#{targetDir}/deps.js" }
