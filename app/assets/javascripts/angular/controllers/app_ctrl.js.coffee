App.controller 'AppCtrl', ($scope, $location, $state, Restangular, EmoticonsModel) ->
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

  $scope.closePopoverUrl = () ->
    if EmoticonsModel.currentListType == 'all' then '/' else '/' + EmoticonsModel.currentListType

  $scope.keyboardShortcuts = (keycode) ->
    unless _.isUndefined $state.current.views.popOver
      currentListType = EmoticonsModel.currentListType
      currentListType = if currentListType == 'all' then '/' else currentListType
      $location.path(currentListType)
