App.controller 'TagSearchCtrl', ($scope, EmoticonsModel) ->
  $scope.activeTags = EmoticonsModel.activeTags
  $scope.availableTags = ->
    EmoticonsModel.availableTags

  $scope.searchKeyDown = (key) ->
    searchDelete()

  $scope.searchKeyUp = (key) ->
    searchEnter()

  $scope.autoCompleteSelect = (val) ->
    $scope.searchInput = val
    searchEnter()

  searchDelete = ->
    if $scope.searchInput == "" || $scope.searchInput == undefined
      $scope.activeTags.pop()

  searchEnter = ->
    unless $scope.searchInput == "" || $scope.searchInput == undefined
      $scope.activeTags.push $scope.searchInput.toLowerCase()
      EmoticonsModel.availableTags = _.without(EmoticonsModel.availableTags, $scope.searchInput)
      $scope.searchInput = ""