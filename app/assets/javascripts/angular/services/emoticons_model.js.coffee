App.service "EmoticonsModel", (Restangular, TagsService) ->
  # New Storage
  this.currentListType = null
  this.lookupTable = []
  this.currentList = []
  this.currentEmote = null
  this.lookups = {
    favorites: [],
    recent: []
  }

  # MULTIPLE EMOTICONS
  this.loader = (kind) ->
    # We've switched between states so we want to clear out any tags that are being actively search for
    unless _.isNull(this.currentListType)
      unless kind == 'inherit'
        if kind != this.currentListType
          TagsService.active = []
    if kind == 'inherit'
      if _.isNull(this.currentListType)
        kind = 'all'
      else
        kind = this.currentListType
    this.currentListType = kind
    # HACK: This is ugly, should probably be put into a directive during a refactor, but for now this is the easiest option
    $('.spinner').hide()

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

      # Build the full tag library
      TagsService.populateTagArray response
      if klass.currentListType == 'all'
        TagsService.populateTagArray response, 'copy_full'

      if assignToCurrent
        klass.currentList = response

  fetchFavorites = (klass) ->
    Restangular.one('users', 'me').all('favorites').getList().then (response) ->
      klass.currentList = response
      TagsService.populateTagArray response, 'current'
      fetchAll(klass, false)

  lookupList = (klass, list_type) ->
    switch list_type
      when "all"
        klass.currentList = _.map klass.lookupTable, (lookup) ->
          lookup
        klass.currentList = _.sortBy klass.currentList, (emoticon) ->
          -Date.parse(emoticon.created_at)
        TagsService.populateTagArray klass.currentList, 'copy_full'
      when "favorites"
        klass.currentList = _.map klass.lookups.favorites, (id) ->
          klass.lookupTable[id]
        klass.currentList = _.sortBy klass.currentList, (emoticon) ->
          -Date.parse(emoticon.created_at)
        TagsService.populateTagArray klass.currentList, 'current'

  # SINGLE EMOTICONS
  this.singleLoader = (emoticon_id) ->
    if _.isEmpty this.lookupTable
      # Tutorial; Javascript scopes yoh, this isn't refering to the class anymore in restangular block
      # Restangular.one('emotes', emoticon_id).get().then (emote) ->
      #  this.currentEmote = emote
      fetchSingle this, emoticon_id
    else
      this.currentEmote = this.lookupTable[emoticon_id]

  fetchSingle = (klass, emoticon_id) ->
    Restangular.one('emotes', emoticon_id).get().then (emote) ->
      klass.currentEmote = emote

  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this