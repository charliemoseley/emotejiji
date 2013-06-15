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
    unless $scope.searchInput == "" || $scope.searchInput == undefined
      $scope.activeTags.push $scope.searchInput.toLowerCase()
      Data.availableTags = _.without(Data.availableTags, $scope.searchInput)
      $scope.searchInput = ""