glob = require 'glob'
exports.FindDeps = ->
  deps = []
  files = glob.sync "#{SRC}/**/*.coffee", nodir: yes

  for file in files
    source = await IO.read file
    FileDeps = FindFileDeps source
    deps.push FileDeps...

  deps

FindFileDeps = (source) ->
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

CreateDeps = (assignments) ->
  deps = []

  for assignment in assignments
    { left, right } = assignment

    argument = right.arguments[0]
    if argument?.type is 'StringLiteral'
      origin = argument.value
    else
      break

    switch left.type
      when 'Identifier'
        deps.push {
          origin
          all: yes
          name: left.name
        }
      when 'ObjectPattern'
        for property in left.properties
          if property.type is 'ObjectProperty'
            if property.key.type is 'Identifier'
              deps.push {
                origin
                name: property.key.name
              }

  deps 
