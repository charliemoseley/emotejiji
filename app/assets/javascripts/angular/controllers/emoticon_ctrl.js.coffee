App.controller 'EmoticonCtrl', ($scope, Restangular, Data, $stateParams) ->
  if _.isEmpty Data.emoticonLookup
    Restangular.one('emotes', $stateParams.id).get().then (emote) ->
      $scope.emoticon = emote
  else
    $scope.emoticon = Data.emoticonLookup[$stateParams.id]

  $scope.addToFavorites = (emoticon_id) ->
    console.log "running add to favorites"
    Restangular.one('user', 'me').customPOST("favorites", {}, {emoticon_id: emoticon_id})
