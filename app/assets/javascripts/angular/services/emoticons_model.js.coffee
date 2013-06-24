App.service "EmoticonsModel", (Restangular) ->
  this.activeTags = []
  this.availableTags = []

  # New Storage
  this.full = []
  this.currentList = []
  this.currentEmote = []
  this.lookups = {
    favorites: [],
    recent: []
  }

  this.loader = (kind = "full", emoticon_id) ->
    switch kind
      when "full"   then emoticonFullLoader()
      when "single" then emoticonSingleLoader(emoticon_id)

  emoticonSingleLoader = (emoticon_id) ->
    if _.isEmpty this.full
      Restangular.one('emotes', emoticon_id).get().then (emote) ->
        this.currentEmote = emote
    else
      lookupSingle emoticon_id

  emoticonFullLoader = ->
    if _.isEmpty this.full
      Restangular.all('emotes').getList().then (response) ->
        this.full = _.reduce(
          response
          (lookupTable, emoticon) ->
            lookupTable[emoticon.id] = emoticon
            lookupTable
          {})
        this.currentList = response
    else
      lookupFull()

  lookupFull = ->
    _.map this.full, (lookup) ->
      lookup

  lookupSingle = (id) ->
    this.full[id]

  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this