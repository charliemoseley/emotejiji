App.controller 'EmoticonCtrl', ($scope, Restangular, Data) ->
  $scope.emoticons = Restangular.all('emotes').getList()

  $scope.$watch 'fEmoticons.length', (newval, oldval) ->
    if angular.isDefined $scope.fEmoticons
      # Bottle neck here is rebuilding the available tags in reverse for a big set (like the first tag)
      # TODO: Once we support multiple 'emoticon lists', move this into a watcher on the promise
      # TODO: Maybe use underscore's memoize here?
      unless angular.isDefined $scope.allTags
        angular.forEach $scope.fEmoticons, (emoticon) ->
          $scope.allTags = _.uniq(_.keys(emoticon.tags))
      if Data.activeTags.length > 0
        Data.availableTags = []
        angular.forEach $scope.fEmoticons, (emoticon) ->
          Data.availableTags = _.uniq(Data.availableTags.concat(_.keys(emoticon.tags)))
        Data.availableTags = _.difference(Data.availableTags, Data.activeTags)
      else
        Data.availableTags = $scope.allTags

  $scope.tagFilter = (emote) ->
    return emote if Data.activeTags.length == 0
    valid = true
    angular.forEach Data.activeTags, (tag) ->
      valid = false if _.indexOf(_.keys(emote.tags), tag) == -1
    if valid
      return emote
    else
      return false