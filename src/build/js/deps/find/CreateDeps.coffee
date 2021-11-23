exports.CreateDeps = (expressions) ->
  deps = []

  for expression in expressions
    switch expression.type
      when 'CallExpression'
        argument = expression.arguments[0]
        if argument?.type is 'StringLiteral'
          origin = argument.value
        else
          break

        deps.push { origin }
      when 'AssignmentExpression'
        { left, right } = expression

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
