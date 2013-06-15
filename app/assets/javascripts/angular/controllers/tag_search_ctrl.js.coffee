App.controller 'TagSearchCtrl', ($scope, Data) ->
  $scope.activeTags = Data.activeTags
  $scope.availableTags = ->
    Data.availableTags

  $scope.searchKeyDown = (key) ->
    searchDelete()

  $scope.searchKeyUp = (key) ->
    searchEnter()

  searchDelete = ->
    if $scope.searchInput == "" || $scope.searchInput == undefined
      $scope.activeTags.pop()

  searchEnter = ->
    $scope.activeTags.push $scope.searchInput
    Data.availableTags = _.without(Data.availableTags, $scope.searchInput)
    $scope.searchInput = ""