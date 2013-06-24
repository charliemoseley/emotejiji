App.controller 'AppCtrl', ($scope, Restangular, EmoticonsModel) ->
  $scope.loggedIn = false

  $scope.isLoggedIn = ->
    $scope.loggedIn

  $scope.currentUser = Restangular.one('users', 'me?include_favorites=list').get().then(
    (user) ->
      $scope.loggedIn = true
      EmoticonsModel.lookups.favorites = user.favorite_emoticons
      user
    (response) ->
      $scope.loggedIn = false
      $scope.currentUser = undefined)