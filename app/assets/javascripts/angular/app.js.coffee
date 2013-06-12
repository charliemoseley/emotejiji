window.App = angular.module('Emotejiji', ['restangular'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")