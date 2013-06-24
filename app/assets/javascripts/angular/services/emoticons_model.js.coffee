App.service "EmoticonsModel", (Restangular) ->
  # Tags
  this.activeTags = []
  this.availableTags = []

  # New Storage
  this.currentListType = undefined
  this.full = []
  this.currentList = []
  this.currentEmote = []
  this.lookups = {
    foo: "bar",
    favorites: [],
    recent: []
  }

  this.loader = (kind = "full", emoticon_id) ->
    switch kind
      when "full"   then emoticonFullLoader(this)
      when "single" then emoticonSingleLoader(emoticon_id, this)

  this.switchCurrentList = (list) ->
    switch list
      when "all"      then this.currentList = lookupFull(this)
      when "favorites" then this.currentList = lookupList(this, "favorites")

  # Private Methods
  emoticonSingleLoader = (klass, emoticon_id) ->
    if _.isEmpty klass.full
      Restangular.one('emotes', emoticon_id).get().then (emote) ->
        klass.currentEmote = emote
    else
      lookupSingle(klass, emoticon_id)

  emoticonFullLoader =  (klass) ->
    if _.isEmpty klass.full
      Restangular.all('emotes').getList().then (response) ->
        klass.full = _.reduce(
          response
          (lookupTable, emoticon) ->
            lookupTable[emoticon.id] = emoticon
            lookupTable
          {})
        klass.currentList = response
    else
      lookupFull(klass)

  lookupFull = (klass) ->
    _.map klass.full, (lookup) ->
      lookup

  lookupSingle = (klass, id) ->
    klass.full[id]

  lookupList = (klass, list_type) ->
    if list_type == "favorites"
      _.map klass.lookups.favorites, (id) ->
        klass.full[id]


  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this