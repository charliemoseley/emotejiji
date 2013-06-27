App.service "EmoticonsModel", (Restangular) ->
  # Tags
  this.activeTags = []
  this.availableTags = []

  # New Storage
  this.currentListType = null
  this.full = []
  this.currentList = []
  this.currentEmote = []
  this.lookups = {
    foo: "bar",
    favorites: [],
    recent: []
  }

  # The loader takes the current list type and an optional emoticon id and loads up the model to the appropriate state
  this.loader = (kind = "all", emoticon_id) ->
    switch kind
      when "all"       then emoticonAllLoader(this, emoticon_id)
      when "favorites" then emoticonFavoritesLoader(this, emoticon_id)

  this.switchCurrentList = (list) ->
    switch list
      when "all"       then this.currentList = lookupList(this, "all")
      when "favorites" then this.currentList = lookupList(this, "favorites")

  # Private Methods
  emoticonSingleLoader = (klass, emoticon_id) ->
    if _.isEmpty klass.full
      Restangular.one('emotes', emoticon_id).get().then (emote) ->
        klass.currentEmote = emote
    else
      lookupSingle(klass, emoticon_id)

  emoticonAllLoader =  (klass, emoticon_id) ->
    console.log "emoticonAllLoader"
    if _.isEmpty klass.full
      # If an emoticon id is passed, kick of an AJAX call to get it and assign it ASAP so we can redner the view
      unless _.isUndefined emoticon_id
        fetchSingle(klass, emoticon_id)
      # Load up the rest of the emoticons in the background
      fetchAll(klass)
    else
      klass.currentList = lookupList(klass, "all")

  emoticonFavoritesLoader = (klass, emoticon_id) ->
    console.log "emoticonFavoritesLoader"
    if _.isEmpty klass.full
      # If an emoticon id is passed, kick of an AJAX call to get it and assign it ASAP so we can redner the view
      unless _.isUndefined emoticon_id
        fetchSingle(klass, emoticon_id)
      # An api call that fetches teh favorites emoticons which we assign to the scope
      Restangular.one('users', 'me').all('favorites').getList().then (response) ->
        klass.currentList = response
        fetchAll(klass, false)
    else
      klass.currentList = lookupList(klass, 'favorites')

  fetchSingle = (klass, emoticon_id) ->
    Restangular.one('emotes', emoticon_id).get().then (emote) ->
      klass.currentEmote = emote

  fetchAll = (klass, assignToCurrent = true) ->
    Restangular.all('emotes').getList().then (response) ->
      klass.full = _.reduce(
        response
        (lookupTable, emoticon) ->
          lookupTable[emoticon.id] = emoticon
          lookupTable
      {})
      if assignToCurrent
        klass.currentList = response

  lookupSingle = (klass, id) ->
    klass.full[id]

  lookupList = (klass, list_type) ->
    if list_type == "all"
      return _.map klass.full, (lookup) ->
        lookup
    if list_type == "favorites"
      return _.map klass.lookups.favorites, (id) ->
        klass.full[id]


  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this