window.App = angular.module('Emotejiji', ['restangular'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")

App.config ($routeProvider) ->
  $routeProvider
    .when '/',
      { templateUrl: "/angular/emoticon_list", controller: "EmoticonListCtrl" }
    .when '/emoticons/:id',
      { templateUrl: "/angular/emoticon", controller: "EmoticonCtrl" }