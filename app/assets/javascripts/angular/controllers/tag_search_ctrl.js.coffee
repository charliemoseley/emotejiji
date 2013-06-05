App.controller 'TagSearchCtrl', ($scope, Data) ->
  $scope.activeTags = Data.activeTags
  $scope.searchKeyPress = (key) ->
    if key == 13 # Enter pressed
      searchEnter()
    else
      searchDelete()

  searchDelete = ->
    if $scope.searchInput == ""
      $scope.activeTags.pop()

  searchEnter = ->
    $scope.activeTags.push $scope.searchInput
    $scope.searchInput = ""