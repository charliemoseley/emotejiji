App.service "TagsService", ($rootScope) ->
  this.all       = [] # Full list of tags
  this.allScope  = [] # Full list of tags in the given scope
  this.active    = [] # Currently searching tags
  this.available = [] # Tags still available to search for

  this