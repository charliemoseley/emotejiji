App.directive "tagSpacer", ($timeout) ->
  link: (scope, element, attrs) ->
    scope.$watch 'activeTags.length', (new_value, old_value) ->
      # The timeout is used to wait after the {{tag}} replacement has been made before calculating the width
      # http://stackoverflow.com/questions/12240639/angularjs-how-can-i-run-a-directive-after-the-dom-has-finished-rendering
      $timeout \
      ->
        return if new_value == old_value
        tagContainer = $('#' + element.attr('id'))
        inputField   = $('#tag-search input')
        baseInputFieldWidth = 209

        inputFieldWidth = baseInputFieldWidth - tagContainer.width()
        inputField.css('width', inputFieldWidth)
        inputField.css('padding-left', tagContainer.width())
      ,
      0