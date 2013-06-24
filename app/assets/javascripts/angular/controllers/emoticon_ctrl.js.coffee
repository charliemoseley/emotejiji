App.controller 'EmoticonCtrl', ($scope, Restangular, EmoticonsModel, $stateParams) ->
  if _.isEmpty EmoticonsModel.emoticonLookup
    Restangular.one('emotes', $stateParams.id).get().then (emote) ->
      $scope.emoticon = emote
  else
    $scope.emoticon = EmoticonsModel.emoticonLookup[$stateParams.id]

  $scope.addToFavorites = (emoticon_id) ->
    console.log "running add to favorites"
    Restangular.one('users', 'me').customPOST("favorites", {}, {}, {emoticon_id: emoticon_id})
