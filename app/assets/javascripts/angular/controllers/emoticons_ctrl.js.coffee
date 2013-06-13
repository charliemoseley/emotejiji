App.controller 'EmoticonCtrl', ($scope, Restangular, Data) ->
  $scope.emoticons = Restangular.all('emotes').getList()

  $scope.$watch 'fEmoticons.length', (newval, oldval) ->
    if angular.isDefined $scope.fEmoticons
      Data.availableTags = []
      angular.forEach $scope.fEmoticons, (emoticon) ->
        Data.availableTags = _.uniq(Data.availableTags.concat(_.keys(emoticon.tags)))
      Data.availableTags = _.difference(Data.availableTags, Data.activeTags)

  $scope.tagFilter = (emote) ->
    return emote if Data.activeTags.length == 0
    valid = true
    angular.forEach Data.activeTags, (tag) ->
      valid = false if _.indexOf(_.keys(emote.tags), tag) == -1
    if valid
      return emote
    else
      return false