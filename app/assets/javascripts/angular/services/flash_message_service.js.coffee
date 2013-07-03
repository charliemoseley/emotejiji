App.factory "FlashMessageService", ($rootScope) ->
  #queue = [{ kind: "success", message: "test message"}, { kind: "success", message: "dues ex"}, { kind: "success", message: "moobar"}]
  queue = []
  currentMessage = null

  # When using ui-router, you need to use their $stateChangeSuccess instead of angulars $routeChangeSuccess
  # $rootScope.$on '$routeChangeSuccess', ->
  $rootScope.$on '$stateChangeSuccess', ->
    if queue.length > 0
      currentMessage = queue.shift()
    else
      currentMessage = null

  return {
    set: (kind, message) ->
      queue.push({ kind: kind, message: message})
    kind: ->
      currentMessage.kind unless _.isNull currentMessage
    message: ->
      currentMessage.message unless _.isNull currentMessage
    shouldShowFlash: ->
      if _.isNull currentMessage then false else true
  }

# Inspired by:
# http://stackoverflow.com/questions/12655689/passing-object-between-views-flash-message