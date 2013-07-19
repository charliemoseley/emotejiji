App.controller 'AppCtrl', ($scope, $location, $state, $analytics, Restangular, EmoticonsModel) ->
  $scope.loggedIn = false

  $scope.isLoggedIn = ->
    $scope.loggedIn

  $scope.currentListType = ->
    EmoticonsModel.currentListType

  $scope.currentUser = Restangular.one('users', 'me?include_favorites=list').get().then(
    (user) ->
      $scope.loggedIn = true
      EmoticonsModel.lookups.favorites = user.favorite_emoticons
      user
    (response) ->
      $scope.loggedIn = false
      $scope.currentUser = undefined)

  $scope.closePopoverUrl = () ->
    if EmoticonsModel.currentListType == 'all' then '/' else '/' + EmoticonsModel.currentListType

  $scope.keyboardShortcuts = (keycode) ->
    unless _.isUndefined $state.current.views.popOver
      currentListType = EmoticonsModel.currentListType
      currentListType = if currentListType == 'all' then '/' else currentListType
      $location.path(currentListType)

  # All of this is for handling SEO/page global stuff
  # TODO: Double chaining of if statements is pretty ugly, clean up sometime
  $scope.metaTitle = ->
    unless $location.path().indexOf('emoticons') == -1
      unless _.isUndefined EmoticonsModel.currentEmote
        current = EmoticonsModel.currentEmote
        return current.text + " :: " + current.description + " emoticon / text face :: Emotejiji"
    else
      return "Emotejiji, the emoticon / text face tagging and search engine."

  $scope.metaDescription = ->
    unless $location.path().indexOf('emoticons') == -1
      unless _.isUndefined EmoticonsModel.currentEmote
        current = EmoticonsModel.currentEmote
        flattened_tags = _.keys(current.tags).join(", ")
        description = current.description + " :: emoticon / text face for " + flattened_tags
        return description
    else
      return "Emotejiji is a tagging and search engine for emoticons/emoji and text faces.  Find, discover, and copy your way to awesome emoticons wherever you need them! :D"

  $scope.metaOgUrl = ->
    $location.$$absUrl

  # Google Analytics Pagetrack
  # Tutorial Note / Pull request: Angulartics can't auto track when your using something like Angular-UI router.  See
  # if you can make it do so.
  $analytics.pageTrack($location.$$url)