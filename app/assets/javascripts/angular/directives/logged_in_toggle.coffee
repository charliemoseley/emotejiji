# TODO: This doesn't prevent the user from navigating to the url while not being logged in.  Fix that sometime too.
# TODO: Way too complex if chains.  Refactor this when you have time.

App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      console.log "element val " + element.get(0).tagName
      # Generic disable stuff
      unless scope.isLoggedIn()
        element.addClass(attrs.loggedInToggle)
        element.addClass('disabled')
      else
        element.removeClass(attrs.loggedInToggle)
        element.removeClass('disabled')

      if element.get(0).tagName == "INPUT"
        console.log "we're working with an input"
        # We only do an enabled/disabled value if the form doesn't already have a value set
        if _.isEmpty element.val()
          console.log "were doing a check on enabled/disabled val"
          console.log "element.val: " + element.val() + " | isEmpty?: " +  _.isEmpty(element.val())
          enabled_val  = attrs.enabledInputValue  unless _.isUndefined attrs.enabledInputValue
          disabled_val = attrs.disabledInputValue unless _.isUndefined attrs.disabledInputValue
          if scope.isLoggedIn()
            element.val(enabled_val)
          else
            element.val(disabled_val)

        if scope.isLoggedIn()
          element.removeAttr('disabled')
          element.val(enabled_val) unless _.isUndefined enabled_val
        else
          element.attr("disabled", "disabled")
          element.val(disabled_val) unless _.isUndefined disabled_val

    # Deal with disabling links
    $(element).click (event) ->
      unless scope.isLoggedIn()
        event.preventDefault()
        return false