{ readFileSync, writeFileSync, existsSync } = require 'fs'
path = require 'path'

YAML = require 'yaml'
coffee = require 'coffeescript'

{ ensureDirExists } = require '../../util'
{ bundle } = require './common'

exports.buildDeps = ->
  file = "#{SRC}/deps.yml"
  if existsSync file
    spec = YAML.parse readFileSync file, 'utf-8'
    
    generateWebpackEntry = (spec) ->
      ensureDirExists '/tmp/makepwa'
      entry = "#{CWD}/esbuild/deps.js"

      makeVariable = (string) ->
        string
          .replace '-', ''
          .replace '@', ''
          .replace '/', ''

      imports = Object
        .keys spec['import']
        .map (dep) ->
          variable = makeVariable dep
          """
          import * as #{variable} from '#{CWD}/node_modules/#{dep}'
          _deps_['#{dep}'] = #{variable}
          """
        .join '\n'

      reacts = Object
        .keys spec['react']
        .map (dep) ->
          variable = makeVariable dep
          components = Object
            .keys spec['react'][dep]
            .map (string) ->
              original: string, raw: "Raw_#{string}_from_#{variable}"

          rawImport = components
            .map ({ original, raw }) ->
              "#{original} as #{raw}"
            .join ', '

          toFROM = components
            .map ({ original, raw }) ->
              "_deps_['#{dep}']['#{original}'] = wrap #{raw}"
            .join '\n'

          """
          _deps_['#{dep}'] = {}
          import { #{rawImport} } from '#{CWD}/node_modules/#{dep}'

          #{toFROM}
          """
        .join '\n'

      source = """
        _deps_ = {}
        window.FROM = (string) ->
          _deps_[string]

        #{imports}

        import { wrap } from '#{CWD}/node_modules/wrapjsx'
        #{reacts}
      """

      writeFileSync entry, (coffee.compile source)
      entry

    targetDir = "#{DIST}/scripts"
    ensureDirExists targetDir

    entry = generateWebpackEntry spec
    bundle { entry, output: "#{targetDir}/deps.js" }
