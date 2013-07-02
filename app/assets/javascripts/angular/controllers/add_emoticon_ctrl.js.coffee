App.controller 'AddEmoticonCtrl', ($scope, TagsService) ->
  $scope.allTags = ->
    TagsService.full

  $scope.tagsToAdd = []

  $scope.addTagAutoComplete = (tag) ->
    $scope.tagInput = tag
    $scope.addTagKeyDown

  $scope.addTagKeyDown = (key) ->
    addTag $scope.tagInput
    $scope.tagInput = ''

  $scope.removeTag = (tag) ->
    $scope.tagsToAdd = _.without $scope.tagsToAdd, tag

  $scope.saveEmoticon = ->
    console.log "save emoticon"
    console.log "value of new emoticon text: " + $scope.newEmoticonText
    console.log "value of new emoticon description: " + $scope.newEmoticonDescription
    console.log "value of new emoticon tags: " + $scope.tagsToAdd

  addTag = (tag) ->
    $scope.tagsToAdd.push tag.toLowerCase() unless tag == ''

