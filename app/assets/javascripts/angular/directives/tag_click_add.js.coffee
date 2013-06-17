App.directive "tagClickAdd", (Data) ->
  (scope, element, attrs) ->
    element.click ->
      scope.$apply ->
        scope.activeTags.push attrs.tagClickAdd
        Data.availableTags = _.without(Data.availableTags, scope.searchInput)
        $("#tag-search input").focus()