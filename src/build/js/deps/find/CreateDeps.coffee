exports.CreateDeps = (assignments) ->
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
