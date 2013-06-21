App.controller 'EmoticonCtrl', ($scope, Restangular, Data, $route) ->
  if _.isEmpty Data.emoticonLookup
    Restangular.one('emotes', $route.current.params.id).get().then (emote) ->
      $scope.emoticon = emote
  else
    $scope.emoticon = Data.emoticonLookup[$route.current.params.id]