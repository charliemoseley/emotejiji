App.controller 'AppCtrl', ($scope, Restangular) ->
  $scope.currentUser = Restangular.one('users', 'me').get().then \
    (user) ->
      $scope.loggedIn = true
      user
    ,
    (response) ->
      $scope.loggedIn = false
      $scope.currentUser = undefined