# TODO: This doesn't prevent the user from navigating to the url while not being logged in.  Fix that sometime too.
# TODO: Way too complex if chains.  Refactor this when you have time.

App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      # Generic disable stuff
      unless scope.isLoggedIn()
        element.addClass(attrs.loggedInToggle)
        element.addClass('disabled')
      else
        element.removeClass(attrs.loggedInToggle)
        element.removeClass('disabled')

      if element.get(0).tagName == "INPUT"
        if scope.isLoggedIn() and !_.isUndefined(attrs.loggedInPlaceholder)
          element.attr('placeholder', attrs.loggedInPlaceholder)
        if !scope.isLoggedIn() and !_.isUndefined(attrs.loggedOutPlaceholder)
          element.attr('placeholder', attrs.loggedOutPlaceholder)

    # Deal with disabling links
    $(element).click (event) ->
      unless scope.isLoggedIn()
        event.preventDefault()
        return false