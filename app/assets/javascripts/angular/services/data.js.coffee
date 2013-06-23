App.service "Data", (Restangular, $rootScope) ->
  this.activeTags = []
  this.availableTags = []
  this.emoticonCurrent = []
  this.emoticonLookup = []

  this.loader = ->
    emoticonListLoader()

  emoticonListLoader = ->
    if _.isEmpty this.emoticonCurrent
      Restangular.all('emotes').getList().then (response) ->
        # TODO: THeres got to be a more elegant way to format this
        # Store all the emoticons in an
        allEmoticons = {}
        angular.forEach response, (emoticon) ->
          allEmoticons[emoticon.id] = emoticon
        this.emoticonLookup = allEmoticons
        this.emoticonCurrent = response
        $rootScope.emoticons = response
    else
      $rootScope.emoticons = this.emoticonCurrent

  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this



