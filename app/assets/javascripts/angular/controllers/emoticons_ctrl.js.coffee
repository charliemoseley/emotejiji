window.App = angular.module('Emotejiji', ['restangular'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")
  RestangularProvider.setListTypeIsArray(false)
  RestangularProvider.setResponseExtractor (response, operation, what, url) ->
    console.log "response: " + response.emotes[0].text
    console.log "operation: " + operation
    console.log "what: " + what
    console.log "url: " + url
    if operation == "getList"
      response = response.emotes
    response

App.controller 'EmoticonCtrl', ($scope, Restangular) ->
  $scope.activeTags = []
  $scope.emoticons = Restangular.all('emotes').getList()

  $scope.searchKeyPress = (key) ->
    if key == 13 # Enter pressed
      searchEnter()
    else
      searchDelete()

  searchDelete = ->
    if $scope.searchInput == ""
      $scope.activeTags.pop()

  searchEnter = ->
    $scope.activeTags.push $scope.searchInput
    $scope.searchInput = ""

  $scope.tagFilter = (emote) ->
    return emote if $scope.activeTags.length == 0
    valid = true
    angular.forEach $scope.activeTags, (tag) ->
      valid = false if _.indexOf(emote.tags, tag) == -1
    if valid
      return emote
    else
      return false

App.directive "onKeyup", ->
  (scope, element, attrs) ->
    allowedKeys = scope.$eval(attrs.keys)
    callback = scope.$eval(attrs.onKeyup)

    hasAllowedKeys = ->
      return false unless allowedKeys
      return false if allowedKeys == true
      return true

    applyKeyup = (key) ->
      scope.$apply ->
        callback.call(scope, key)

    element.bind 'keyup', (event) ->
      if hasAllowedKeys()
        angular.forEach allowedKeys, (key) ->
          if key == event.which
            applyKeyup(key)
      else
        applyKeyup(event.which)