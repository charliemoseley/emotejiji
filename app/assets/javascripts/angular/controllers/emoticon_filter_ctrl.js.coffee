App.controller 'EmoticonFilterCtrl', ($scope) ->
#  $scope.changeEmoticonList = (list) ->
#    if list == "all"
#      console.log "all clicked"
#      $scope.emoticons = Data.emoticonCurrent
#
#    if list == "favorites"
#      console.log "All Emoticons: " + Data.emoticonLookup
#      favorites = []
#      angular.forEach Data.favoritesLookup, (emoticon_id) ->
#        favorites.push Data.emoticonLookup[emoticon_id]
#      console.log "Favorites: " + favorites
#      console.log "Pre $scope.emoticons: " + $scope.emoticons
#      $scope.emoticons = favorites
#      console.log "Post $scope.emoticons: " + $scope.emoticons
  $scope.changeEmoticonList = (list) ->
    console.log "btn click: " + list