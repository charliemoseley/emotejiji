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
    if $scope.searchInput == ""
      $scope.activeTags.pop()

  searchEnter = ->
    $scope.activeTags.push $scope.searchInput
    Data.availableTags = _.without(Data.availableTags, $scope.searchInput)
    $scope.searchInput = ""