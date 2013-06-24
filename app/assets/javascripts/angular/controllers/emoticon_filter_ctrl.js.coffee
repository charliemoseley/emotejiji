App.controller 'EmoticonFilterCtrl', ($scope, EmoticonsModel) ->
  $scope.changeEmoticonList = (list) ->
    EmoticonsModel.currentListType = list