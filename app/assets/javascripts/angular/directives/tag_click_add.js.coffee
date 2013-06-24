App.directive "tagClickAdd", (EmoticonsModel) ->
  (scope, element, attrs) ->
    element.click ->
      scope.$apply ->
        scope.activeTags.push attrs.tagClickAdd
        EmoticonsModel.availableTags = _.without(EmoticonsModel.availableTags, scope.searchInput)
        $("#tag-search input").focus()