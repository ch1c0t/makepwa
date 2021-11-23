{ CreateDeps } = require './CreateDeps'

exports.FindFileDeps = (source) ->
  CreateDeps FindFROMs source

{ compile } = require 'coffeescript'
FindFROMs = (source) ->
  { program } = compile source, ast: yes
  { body } = program
  body
    .map (object) ->
      if object.type is 'ExpressionStatement'
        { expression } = object
        switch expression.type
          when 'AssignmentExpression'
            if expression.right?.type is 'CallExpression'
              { right } = expression
              { callee } = right
              if callee?.name is 'FROM'
                expression
          when 'CallExpression'
            { callee } = expression
            if callee?.name is 'FROM'
              expression
    .filter Boolean
