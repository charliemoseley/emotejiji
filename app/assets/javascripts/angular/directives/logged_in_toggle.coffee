App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      unless scope.isLoggedIn()
        element.addClass(attrs.loggedInToggle)
        element.addClass('disabled')
      else
        element.removeClass(attrs.loggedInToggle)
        element.removeClass('disabled')
