# TODO: This doesn't prevent the user from navigating to the url while not being logged in.  Fix that sometime too.
# TODO: Way too complex if chains.  Refactor this when you have time.

App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      # Generic disable stuff
      unless scope.isLoggedIn()
        element.addClass(attrs.loggedInToggle)
        element.addClass('disabled')
        element.attr('disabled', 'disabled')
      else
        element.removeClass(attrs.loggedInToggle)
        element.removeClass('disabled')
        element.removeAttr('disabled')

    # Deal with disabling links
    $(element).click (event) ->
      unless scope.isLoggedIn()
        event.preventDefault()
        return false