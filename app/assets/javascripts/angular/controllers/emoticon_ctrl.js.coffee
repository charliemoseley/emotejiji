App.controller 'EmoticonCtrl', ($scope, $stateParams, EmoticonsModel, FlashMessageService, Restangular) ->
  if _.isNull EmoticonsModel.currentListType
    EmoticonsModel.currentListType = 'all'
  EmoticonsModel.singleLoader $stateParams.id

  $scope.currentEmoticon = ->
    EmoticonsModel.currentEmote

  $scope.addToFavorites = (emoticon_id) ->
    Restangular.one('users', 'me').customPOST("favorites", {}, {}, {emoticon_id: emoticon_id}).then(
      ->
        EmoticonsModel.lookups.favorites.unshift emoticon_id
        FlashMessageService.set 'success', 'added to favorites'
        FlashMessageService.showNow()
      (response) ->
        FlashMessageService.set 'error', 'max number of favorites reached, please remove some'
        FlashMessageService.showNow()
    )

  $scope.removeFromFavorites = (emoticon_id) ->
    console.log "Remove from favorites"
    Restangular.one('users', 'me').customDELETE("favorites", {}, {}, {emoticon_id: emoticon_id}).then(
      ->
        EmoticonsModel.lookups.favorites = _.without EmoticonsModel.lookups.favorites, emoticon_id
        FlashMessageService.set 'success', 'removed from favorites'
        FlashMessageService.showNow()
    )

  $scope.showAddToFavorites = ->
    unless _.isNull $scope.currentEmoticon() # Prevent JS errors from promise not initalized yet
      unless _.indexOf(EmoticonsModel.lookups.favorites, $scope.currentEmoticon().id) == -1
        return false
    return true

  $scope.flash = FlashMessageService

  # TODO: See if you can finesse either the API or the restangular call to not use customPOSt and customDelete
  # https://github.com/mgonto/restangular/issues/135