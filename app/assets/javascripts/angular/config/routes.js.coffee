App.config ($stateProvider, $routeProvider) ->
  $stateProvider
    .state('index', {
      url: '', # root route
      views: {
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        }
      },
      data: {
        currentListType: 'all'
      }
    })
    .state('singleEmoticon', {
      url: '/emoticons/{id}',
      views: {
        'popOver': {
          templateUrl: '/angular/emoticon',
          controller: 'EmoticonCtrl'
        },
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        }
      }
    })
    .state('favorites', {
      url: '/favorites', # root route
      views: {
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        }
      },
      data: {
        currentListType: 'favorites'
      }
    })