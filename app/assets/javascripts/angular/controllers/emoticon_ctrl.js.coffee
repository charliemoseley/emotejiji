App.controller 'EmoticonCtrl', ($scope, $stateParams, EmoticonsModel, FlashMessageService, Restangular) ->
  if _.isNull EmoticonsModel.currentListType
    EmoticonsModel.currentListType = 'all'
  EmoticonsModel.singleLoader $stateParams.id

  $scope.currentEmoticon = ->
    EmoticonsModel.currentEmote

  # Override of the existing EmoticonsModel.currentEmote.tags to strip out the count numbers as angular with complain if
  # there are repeat values in an ng-repeat
  # http://stackoverflow.com/questions/16296670/error-duplicates-in-a-repeater-are-not-allowed-when-using-cutom-filter-in-ang
  # TODO: Make a real model file that we can pass the restangular response for emotes to that actually exposes a nice .tag
  # and .tagCounts method so we don't have to do this hack.
  $scope.currentEmoticon['tags'] = ->
    if _.isUndefined EmoticonsModel.currentEmote
      _.keys EmoticonsModel.currentEmote.tags

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

  $scope.addTag = ->
    unless _.isEmpty $scope.addTagText
      tagToAdd = $scope.addTagText
      $scope.addTagText = ''
      currentEmoticonId = $scope.currentEmoticon().id

      Restangular.one('emotes', currentEmoticonId).customPUT("", {}, {}, { tags: [tagToAdd] })
      EmoticonsModel.currentEmote.tags[tagToAdd] = 1
      EmoticonsModel.lookupTable[currentEmoticonId].tags[tagToAdd] = 1

      FlashMessageService.set 'success', 'added ' + tagToAdd + ' to tags'
      FlashMessageService.showNow()

  # TODO: See if you can finesse either the API or the restangular call to not use customPOSt and customDelete
  # https://github.com/mgonto/restangular/issues/135