{ compile } = require 'coffeescript'

exports.CreateEntryFile = ({ imports, origins, entry }) ->
  origins = origins.toSet().map (origin) ->
    "_deps_['#{origin}'] = {}"

  source = """
    window._deps_ = {}
    #{origins.join "\n"}
    window.FROM = (string) ->
      _deps_[string]

    #{imports.join "\n"}
  """

  IO.write entry, (compile source)
