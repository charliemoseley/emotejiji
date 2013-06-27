App.service "EmoticonsModel", (Restangular) ->
  # Tags
  this.activeTags = []
  this.availableTags = []

  # New Storage
  this.currentListType = null
  this.lookupTable = []
  this.currentList = []
  this.currentEmote = []
  this.lookups = {
    favorites: [],
    recent: []
  }

  # The loader takes the current list type and an optional emoticon id and loads up the model to the appropriate state
  this.loader = (kind = "all") ->
    switch kind
      when "all"
        if _.isEmpty this.lookupTable then fetchAll(this) else lookupList(this, "all")
      when "favorites"
        if _.isEmpty this.lookupTable then fetchFavorites(this) else lookupList(this, 'favorites')

  fetchAll = (klass, assignToCurrent = true) ->
    Restangular.all('emotes').getList().then (response) ->
      klass.lookupTable = _.reduce(
        response
        (lookupTable, emoticon) ->
          lookupTable[emoticon.id] = emoticon
          lookupTable
      {})
      if assignToCurrent
        klass.currentList = response

  fetchFavorites = (klass) ->
    Restangular.one('users', 'me').all('favorites').getList().then (response) ->
      klass.currentList = response
      fetchAll(klass, false)

  lookupList = (klass, list_type) ->
    switch list_type
      when "all"
        klass.currentList = _.map klass.lookupTable, (lookup) ->
          lookup
      when "favorites"
        klass.currentList = _.map klass.lookups.favorites, (id) ->
          klass.lookupTable[id]

  # Private Methods
#  lookupSingle = (klass, id) ->
#    klass.lookupTable[id]
#
#  fetchSingle = (klass, emoticon_id) ->
#    Restangular.one('emotes', emoticon_id).get().then (emote) ->
#      klass.currentEmote = emote
#
#  emoticonSingleLoader = (klass, emoticon_id) ->
#    if _.isEmpty klass.lookupTable
#      Restangular.one('emotes', emoticon_id).get().then (emote) ->
#        klass.currentEmote = emote
#    else
#      lookupSingle(klass, emoticon_id)


  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this