App.service "Data", ($rootScope) ->
  this.activeTags = []
  this.availableTags = []
  this.emoticonCurrent = []
  this.emoticonLookup = []
  # GUIDE: Due to how coffeescript returns the last value, you need to specify to return the object when using Angular
  # services otherwise it'll return [] instead and thus you get [].foo() attempts in your code.  Example on how it should
  # work:
  # http://jsfiddle.net/manishchhabra/Ne5P8/
  this