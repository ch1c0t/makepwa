{ ensureDirExists } = require './util'

exports.sw = (action) ->
  switch action
    when 'extract'
      ensureDirExists "#{SRC}/scripts"
      ensureDirExists "#{SRC}/workers"

      registrationScript = "#{SRC}/scripts/register_sw.coffee"
      serviceWorker = "#{SRC}/workers/sw.coffee"

      IO.copy '/tmp/makepwa/register_sw.coffee', registrationScript
      IO.copy '/tmp/makepwa/sw.coffee', serviceWorker

      console.log """
        Extracted the default service worker and its registration script. You can modify them now at:
        #{registrationScript}
        #{serviceWorker}
      """
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
