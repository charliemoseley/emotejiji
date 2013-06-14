App.directive 'tagAutoComplete', ($timeout) ->
  (scope, element, attrs) ->
    scope.$watch 'availableTags().length', ->
      element.autocomplete {
        source: scope.availableTags(),
        select: ->
          $timeout -> \
            element.trigger('input')
            ,
            0
      }