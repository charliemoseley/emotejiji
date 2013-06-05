App.controller 'EmoticonCtrl', ($scope, Restangular, Data) ->
  $scope.activeTags = Data.activeTags
  $scope.emoticons = Restangular.all('emotes').getList()
  $scope.tagFilter = (emote) ->
    return emote if $scope.activeTags.length == 0
    valid = true
    angular.forEach $scope.activeTags, (tag) ->
      valid = false if _.indexOf(emote.tags, tag) == -1
    if valid
      return emote
    else
      return false