App.controller 'TagSearchCtrl', ($scope, Data) ->
  $scope.activeTags = Data.activeTags
  $scope.availableTags = ->
    Data.availableTags

  $scope.searchKeyPress = (key) ->
    if key == 13 # Enter pressed
      searchEnter()
    else
      searchDelete()

  searchDelete = ->
    console.log "Current Search Input: " + $scope.searchInput
    if $scope.searchInput == "" || $scope.searchInput == undefined
      $scope.activeTags.pop()

  searchEnter = ->
    $scope.activeTags.push $scope.searchInput
    Data.availableTags = _.without(Data.availableTags, $scope.searchInput)
    $scope.searchInput = ""