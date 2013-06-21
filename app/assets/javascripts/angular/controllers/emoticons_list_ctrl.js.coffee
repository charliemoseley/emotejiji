App.controller 'EmoticonListCtrl', ($scope, Restangular, Data) ->
  if _.isEmpty Data.emoticonCurrent
    Restangular.all('emotes').getList().then (response) ->
      # TODO: THeres got to be a more elegant way to format this
      # Store all the emoticons in an
      allEmoticons = {}
      angular.forEach response, (emoticon) ->
        allEmoticons[emoticon.id] = emoticon
      Data.emoticonLookup = allEmoticons
      Data.emoticonCurrent = response
      $scope.emoticons = response
  else
    $scope.emoticons = Data.emoticonCurrent

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
        Data.availableTags = $scope.allTags

      if Data.activeTags.length > 0
        Data.availableTags = []
        angular.forEach $scope.fEmoticons, (emoticon) ->
          Data.availableTags = _.uniq(Data.availableTags.concat(_.keys(emoticon.tags)))
        Data.availableTags = _.difference(Data.availableTags, Data.activeTags)
      else
        # Handles the final delete key press
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