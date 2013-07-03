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

  $scope.showAddToFavorites = ->
    unless _.isNull $scope.currentEmoticon() # Prevent JS errors from promise not initalized yet
      unless _.indexOf(EmoticonsModel.lookups.favorites, $scope.currentEmoticon().id) == -1
        return false
    return true

  $scope.flash = FlashMessageService