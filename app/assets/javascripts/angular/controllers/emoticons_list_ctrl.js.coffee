App.controller 'EmoticonListCtrl', ($scope, $state, EmoticonsModel) ->
  # Initialization Code
  EmoticonsModel.currentListType = $state.current.data.currentListType
  EmoticonsModel.loader($state.current.data.currentListType)

  # Setup the Scopes needed for this controller
  $scope.emoticons = () ->
    EmoticonsModel.currentList
  $scope.currentListType = () ->
    EmoticonsModel.currentListType

  # Controller Logic
  $scope.$watch 'currentListType()', (currentType, previousType) ->
    console.log "current list type: " +  currentType
    unless currentType == previousType
      EmoticonsModel.switchCurrentList(currentType)

  $scope.$watch 'emoticonList.length', (newval, oldval) ->
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


# The proper way map and use model is this.  First load the state into the model, then make a scope method that
# fetches that state.  When you need to update the state, you write to the model, never the scope, otherwise your
# unbinding the connection to the model you created.
#  DataService.currentListType = $state.current.data.currentListType
#  $scope.currentListType =  () ->
#    DataService.currentListType