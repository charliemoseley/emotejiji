App.service "TagsService", ->
  this.full      = [] # Full list of all tags
  this.current   = [] # Full list of tags in the given scope
  this.active    = [] # Currently searching tags
  this.available = [] # Tags still available to search for

  this.populateTagArray = (emoticons, target = 'full', klass = this) ->
    if target == 'copy_full'
      klass.current = klass.full
      return klass.available = klass.full

    tags = []
    _.each emoticons, (emoticon) ->
      tags = tags.concat(_.keys(emoticon.tags))
    klass[target] = _.uniq(tags)
    klass.available = klass[target]

  this.updateAvailableTags = (emoticons, klass = this) ->
    # Bottle neck here is rebuilding the available tags in reverse for a big set (like the first tag)
    # TODO: Once we support multiple 'emoticon lists', move this into a watcher on the promise
    # TODO: Maybe use underscore's memoize here?
    if klass.active.length > 0
      klass.available = []
      _.each emoticons, (emoticon) ->
        klass.available = _.uniq(klass.available.concat(_.keys(emoticon.tags)))
      klass.available = _.difference(klass.available, klass.active)
    else
      klass.available = klass.current

  this.filterEmoticonByTag = (emoticon, klass = this) ->
    return emoticon if klass.active.length == 0
    valid = true
    _.each klass.active, (tag) ->
      valid = false if _.indexOf(_.keys(emoticon.tags), tag) == -1
    if valid then emoticon else false

  this