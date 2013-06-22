App.directive "loggedInToggle", ->
  link: (scope, element, attrs) ->
    scope.$watch 'isLoggedIn()', ->
      unless scope.isLoggedIn()
        element.addClass(attrs.userToggle)
        element.addClass('disabled')
      else
        element.removeClass(attrs.userToggle)
        element.removeClass('disabled')
