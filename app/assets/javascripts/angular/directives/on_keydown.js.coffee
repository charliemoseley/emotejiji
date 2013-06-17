App.directive "onKeydown", ->
  (scope, element, attrs) ->
    allowedKeys = scope.$eval(attrs.downKeys)
    callback = scope.$eval(attrs.onKeydown)

    hasAllowedKeys = ->
      return false unless allowedKeys
      return false if allowedKeys == true
      return true

    applyKeydown = (key) ->
      scope.$apply ->
        callback.call(scope, key)

    element.on 'keydown', (event) ->
      if hasAllowedKeys()
        angular.forEach allowedKeys, (key) ->
          if key == event.which
            applyKeydown(key)
      else
        applyKeydown(event.which)