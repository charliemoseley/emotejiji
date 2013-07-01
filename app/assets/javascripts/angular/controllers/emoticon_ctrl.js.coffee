App.controller 'EmoticonCtrl', ($scope, $location, $stateParams, EmoticonsModel) ->
  if _.isNull EmoticonsModel.currentListType
    EmoticonsModel.currentListType = 'all'
  EmoticonsModel.singleLoader $stateParams.id

  $scope.currentEmoticon = ->
    EmoticonsModel.currentEmote

  $scope.closePopoverUrl = () ->
    if EmoticonsModel.currentListType == 'all' then '/' else '/' + EmoticonsModel.currentListType

  $scope.addToFavorites = (emoticon_id) ->
    console.log "running add to favorites"
    Restangular.one('users', 'me').customPOST("favorites", {}, {}, {emoticon_id: emoticon_id})