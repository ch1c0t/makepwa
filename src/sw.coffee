exports.sw = (action) ->
  switch action
    when 'extract'
      console.log 'Extracting the default SW'
    else
      console.error "Unknown action: #{action}"
      printHelp()

printHelp = ->
  console.log """
    makepwa sw ACTION
    The actions related to service workers.

    ACTIONS:
      extract             Extract the default servide worker for modification.
  """
