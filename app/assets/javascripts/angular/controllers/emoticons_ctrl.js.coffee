App.controller 'EmoticonCtrl', ($scope, Restangular) ->
  $scope.working = "its working"
  $scope.emoticons = Restangular.all('emotes').getList()