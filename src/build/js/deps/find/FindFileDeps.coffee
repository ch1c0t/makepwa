{ CreateDeps } = require './CreateDeps'

exports.FindFileDeps = (source) ->
  CreateDeps FindFROMs FindAssignmentExpressions source

{ compile } = require 'coffeescript'
FindAssignmentExpressions = (source) ->
  { program } = compile source, ast: yes
  { body } = program
  body
    .map (object) ->
      if object.type is 'ExpressionStatement'
        { expression } = object
        if expression.type is 'AssignmentExpression'
          expression
    .filter Boolean

FindFROMs = (assignments) ->
  assignments
    .map (assignment) ->
      if assignment.right?.type is 'CallExpression'
        { right } = assignment
        { callee } = right
        if callee?.name is 'FROM'
          assignment
    .filter Boolean
