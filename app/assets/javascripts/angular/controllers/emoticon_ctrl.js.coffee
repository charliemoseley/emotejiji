App.controller 'EmoticonCtrl', ($scope, Restangular, EmoticonsModel, $stateParams) ->
  $scope.emoticon = EmoticonsModel.loader 'single', $stateParams.id

  $scope.addToFavorites = (emoticon_id) ->
    console.log "running add to favorites"
    Restangular.one('users', 'me').customPOST("favorites", {}, {}, {emoticon_id: emoticon_id})
