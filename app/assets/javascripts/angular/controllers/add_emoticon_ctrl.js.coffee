App.controller 'AddEmoticonCtrl', ($scope, $location, EmoticonsModel, TagsService, Restangular, FlashMessageService) ->
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
    # Validations
    if _.isUndefined $scope.newEmoticonText
      $scope.errors = "You need to put in something for the emoticon itself."
      return false
    if _.isUndefined $scope.newEmoticonDescription
      $scope.errors = "You need to put in a description for the emoticon."
    $scope.errors = null

    # Save the Emoticon
    Restangular.all('emotes').post(emoticonJson()).then(
      # Success
      (emoticon) ->
        EmoticonsModel.lookupTable[emoticon.id] = emoticon
        TagsService.full = _.uniq TagsService.full.concat(emoticon.tags)

        FlashMessageService.set 'success', 'emoticon successfully created'
        $location.path('/emoticons/' + emoticon.id)
      # Error
      (response) ->
        $scope.errors = "An emoticon already exists for: " + $scope.newEmoticonText
    )

  # TODO: Make a nice directive for displaying closable errors anywhere in the app.
  $scope.isThereErrors = ->
    if _.isNull $scope.errors
      return false
    return true

  $scope.errors = null

  addTag = (tag) ->
    $scope.tagsToAdd.push tag.toLowerCase() unless tag == ''

  # TODO: IMPORTANT - Create a method that background injects the emoticon into the DOM and reads the width and height
  # of the injected element to figure out the display_rows and display_columns it takes up
  emoticonJson = ->
    {
      text: $scope.newEmoticonText,
      description: $scope.newEmoticonDescription,
      tags: $scope.tagsToAdd
    }

  emoticonLookupFormatter = (emoticon) ->
    lookup = {}
    lookup[emoticon.id] = emoticon