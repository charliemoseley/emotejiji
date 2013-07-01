App.controller 'AvailableTagsCtrl', ($scope, TagsService) ->
  $scope.availableTags = ->
    TagsService.available

  $scope.addTag = (tag) ->
    TagsService.active.push (tag)