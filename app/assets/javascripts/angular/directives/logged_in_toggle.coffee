# TODO: This doesn't prevent the user from navigating to the url while not being logged in.  Fix that sometime too.

App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      unless scope.isLoggedIn()
        element.addClass(attrs.loggedInToggle)
        element.addClass('disabled')
      else
        element.removeClass(attrs.loggedInToggle)
        element.removeClass('disabled')

    $(element).click (event) ->
      unless scope.isLoggedIn()
        event.preventDefault()
        return false