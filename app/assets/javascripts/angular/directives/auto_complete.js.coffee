App.directive 'autoComplete', ($timeout, $log) ->
  (scope, element, attrs) ->
    $log.warn "Autocomplete must have a source." unless angular.isDefined(attrs.autoCompleteSource)

    scope.$watch attrs.autoCompleteSource, ->
      element.autocomplete {
        source: scope.$eval(attrs.autoCompleteSource),
        select: (event, ui) ->
          $timeout -> \
            if angular.isDefined(attrs.autoComplete)
              callback = scope.$eval(attrs.autoComplete)
              callback.call(scope, element.val())
            else
              element.trigger()
            ,
            0
      }