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