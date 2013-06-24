App.service "EmoticonsModel", (Restangular, $rootScope) ->
  this.activeTags = []
  this.availableTags = []
  this.emoticonCurrent = []
  this.emoticonLookup = []

  # New Storage
  this.full = []
  this.currentScope = []
  this.lookups = {
    favorites: [],
    recent: []
  }

  this.loader = ->
    emoticonListLoader()

  emoticonListLoader = ->
    if _.isEmpty this.full
      Restangular.all('emotes').getList().then (response) ->
        this.full = _.reduce(
          response
          (lookupTable, emoticon) ->
            lookupTable[emoticon.id] = emoticon
            lookupTable
          {})
        this.currentScope = response
        $rootScope.emoticons = this.currentScope
    else
      $rootScope.emoticons = this.currentScope

  lookupFull = ->
    _.map this.full, (lookup) ->
      lookup

  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this

# Angular forEach vs underscoe .each
# http://jsperf.com/angular-foreach-vs-underscore-foreach/2
# Almost exactly the same so I'm going to with the underscore syntax since I find it prettier.