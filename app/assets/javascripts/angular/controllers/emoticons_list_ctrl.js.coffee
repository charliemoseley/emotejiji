App.controller 'EmoticonListCtrl', ($scope, EmoticonsModel) ->
  EmoticonsModel.loader()

  $scope.$watch 'fEmoticons.length', (newval, oldval) ->
    if angular.isDefined $scope.fEmoticons
      # Bottle neck here is rebuilding the available tags in reverse for a big set (like the first tag)
      # TODO: Once we support multiple 'emoticon lists', move this into a watcher on the promise
      # TODO: Maybe use underscore's memoize here?
       unless angular.isDefined $scope.allTags
        $scope.allTags = []
        angular.forEach $scope.fEmoticons, (emoticon) ->
          $scope.allTags = $scope.allTags.concat(_.keys(emoticon.tags))
        $scope.allTags = _.uniq($scope.allTags)
        EmoticonsModel.availableTags = $scope.allTags

      if EmoticonsModel.activeTags.length > 0
        EmoticonsModel.availableTags = []
        angular.forEach $scope.fEmoticons, (emoticon) ->
          EmoticonsModel.availableTags = _.uniq(EmoticonsModel.availableTags.concat(_.keys(emoticon.tags)))
        EmoticonsModel.availableTags = _.difference(EmoticonsModel.availableTags, EmoticonsModel.activeTags)
      else
        # Handles the final delete key press
        EmoticonsModel.availableTags = $scope.allTags


  $scope.tagFilter = (emote) ->
    return emote if EmoticonsModel.activeTags.length == 0
    valid = true
    angular.forEach EmoticonsModel.activeTags, (tag) ->
      valid = false if _.indexOf(_.keys(emote.tags), tag) == -1
    if valid
      return emote
    else
      return false