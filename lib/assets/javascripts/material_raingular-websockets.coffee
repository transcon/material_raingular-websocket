# //= require websocket_rails/main
# //= require dateparser

angular.module('WebSocket', [])
  .directive 'webSocket', ($routeParams) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attributes, modelCtrl) ->
      unless angular.dispatcher
        wsurl = window.location.hostname
        wsurl += ":#{window.location.port}" if window.location.port
        wsurl += "/websocket"
        angular.dispatcher = new WebSocketRails(wsurl)
      parent = attributes.ngModel.split('.')
      modelName = parent.pop()
      parent_name = parent.join('.')
      contentLoaded = scope.$watch parent_name, (newVal) ->
        if newVal
          contentLoaded()
          parent = scope.$eval(parent_name)
          angular.dispatcher.bind parent_name + '_' + parent.id + '.change', (data) ->
            new DateParser(data).evaluate()
            for key,value of data
              parent[key] = value unless parent[key] == value
            modelCtrl.$setViewValue(data[modelName])
            modelCtrl.$render()
