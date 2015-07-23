# //= require websocket_rails/main
angular.module('WebSocket', [])
  .directive 'webSocket', ($routeParams) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attributes, modelCtrl) ->
      wsurl = window.location.hostname
      wsurl += ":#{window.location.port}" if window.location.port
      wsurl += "/websocket"
      angular.dispatcher = new WebSocketRails(wsurl)
      parent = attributes.ngModel.split('.')
      modelName = parent.pop()
      contentLoaded = scope.$watch parent.join('.'), (newVal) ->
        if newVal
          contentLoaded()
          parent = scope.$eval(parent.join('.'))
          angular.dispatcher.bind 'process_group_' + parent.id + '.change', (data) ->
            if data[modelName] && modelCtrl.$modelValue != data[modelName]
              modelCtrl.$setViewValue(data[modelName])
