App.controller 'TagSearchCtrl', ($scope, TagsService) ->
  $scope.activeTags = ->
    TagsService.active
  $scope.availableTags = ->
    TagsService.available

  $scope.searchKeyDown = (key) ->
    searchDelete()

  $scope.searchKeyUp = (key) ->
    searchEnter()

  $scope.autoCompleteSelect = (val) ->
    $scope.searchInput = val
    searchEnter()

  $scope.addTag = (input) ->
    TagsService.active.push input
    $("#tag-search input").focus()

  searchDelete = ->
    if $scope.searchInput == "" || $scope.searchInput == undefined
      TagsService.active.pop()

  searchEnter = ->
    unless $scope.searchInput == "" || $scope.searchInput == undefined
      TagsService.active.push $scope.searchInput.toLowerCase()
      $scope.searchInput = ""