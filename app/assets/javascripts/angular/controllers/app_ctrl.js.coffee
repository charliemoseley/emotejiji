App.controller 'AppCtrl', ($scope, Restangular) ->
  $scope.loggedIn = false

  $scope.isLoggedIn = ->
    $scope.loggedIn

  $scope.currentUser = Restangular.one('users', 'me?include_favorites=list').get().then \
    (user) ->
      $scope.loggedIn = true
      user
    ,
    (response) ->
      $scope.loggedIn = false
      $scope.currentUser = undefined