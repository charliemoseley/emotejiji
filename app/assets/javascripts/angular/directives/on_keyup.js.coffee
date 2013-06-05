App.directive "onKeyup", ->
  (scope, element, attrs) ->
    allowedKeys = scope.$eval(attrs.keys)
    callback = scope.$eval(attrs.onKeyup)

    hasAllowedKeys = ->
      return false unless allowedKeys
      return false if allowedKeys == true
      return true

    applyKeyup = (key) ->
      scope.$apply ->
        callback.call(scope, key)

    element.bind 'keyup', (event) ->
      if hasAllowedKeys()
        angular.forEach allowedKeys, (key) ->
          if key == event.which
            applyKeyup(key)
      else
        applyKeyup(event.which)