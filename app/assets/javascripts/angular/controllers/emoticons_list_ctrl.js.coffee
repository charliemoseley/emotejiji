App.controller 'EmoticonListCtrl', ($scope, $state, EmoticonsModel, TagsService) ->
  # Initialization Code
  EmoticonsModel.loader $state.current.data.currentListType

  # Setup the Scopes needed for this controller
  $scope.emoticons = () ->
    EmoticonsModel.currentList
  $scope.currentListType = () ->
    EmoticonsModel.currentListType

  # Controller Logic
  $scope.$watch 'emoticonList.length', ->
    if angular.isDefined $scope.emoticonList
      TagsService.updateAvailableTags $scope.emoticonList

  $scope.tagFilter = (emoticon) ->
    TagsService.filterEmoticonByTag emoticon

#  $scope.boxsizes = () ->
#    _.each $scope.emoticonList, (emoticon) ->
#      element_width = $('#' + emoticon.id).width()
#      display_columns = 4 if element_width > 380
#      display_columns = 3 if element_width <= 380
#      display_columns = 2 if element_width <= 250
#      display_columns = 1 if element_width <= 120
#      Restangular.one('emotes', emoticon.id).put( { display_columns: display_columns})

# The proper way map and use model is this.  First load the state into the model, then make a scope method that
# fetches that state.  When you need to update the state, you write to the model, never the scope, otherwise your
# unbinding the connection to the model you created.
#  DataService.currentListType = $state.current.data.currentListType
#  $scope.currentListType =  () ->
#    DataService.currentListType