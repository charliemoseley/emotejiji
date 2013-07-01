App.directive 'globalKeyPress',  ->
  (scope, element, attrs) ->
    $(document).on 'keyup', (event) ->
      # I don't want to the digest cycle to execute after each key press, so I'm setting up valid keys for global
      # shortcuts here.  I could put it on the element, but there will probably be a lot more of them.
      if event.keyCode == 27
        scope.$apply ->
          scope.keyboardShortcuts(event.keyCode)

#http://stackoverflow.com/questions/15044494/what-is-angularjs-way-to-create-global-keyboard-shortcuts