App.config ($stateProvider, $routeProvider) ->
  $stateProvider
    .state('index', {
      url: '/',
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
        },
      },
      data: {
        currentListType: 'inherit'
      }
    })
    .state('favorites', {
      url: '/favorites',
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
    .state('availableTags', {
      url: '/available-tags',
      views: {
        'popOver': {
          templateUrl: '/angular/available_tags',
          controller: 'AvailableTagsCtrl'
        },
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        },
      },
      data: {
        currentListType: 'inherit'
      }
    })
    .state('addEmoticon', {
      url: '/add-emoticon',
      views: {
        'popOver': {
          templateUrl: '/angular/add_emoticon',
          controller: 'AddEmoticonCtrl'
        },
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        },
      },
      data: {
        currentListType: 'inherit'
      }
    })