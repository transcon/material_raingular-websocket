# //= require websocket_rails/main
# //= require dateparser

angular.module('WebSocket', [])
  .directive 'webSocket', ($routeParams, $filter) ->
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
      equiv = (left,right) ->
        return true if left == right
        return !left && !right
      singleton_process = (data) ->
        for key,value of data
          parent[key] = value unless equiv(parent[key],value) || key == modelName
        modelCtrl.$setViewValue(data[modelName])
        modelCtrl.$render()
      array_process = (data) ->
        ids = $filter('pluck')(parent[modelName], 'id')
        for item in (data[modelName] || [])
          parent[modelName].push(item) unless ids.includes(item.id)
        ids = $filter('pluck')(data[modelName], 'id')
        for item in (parent[modelName] || [])
          parent[modelName].drop(instance) unless ids.includes(item.id)
        window.dispatchEvent(new Event('resize'))
        parent.adjustHeight() if parent.adjustHeight
        scope.$parent.creating = false
      contentLoaded = scope.$watch parent_name, (newVal) ->
        if newVal
          contentLoaded()
          parent = scope.$eval(parent_name)
          channel = angular.dispatcher.subscribe parent_name + '_' + parent.id
          channel.bind 'change', (data) ->
            scope.$apply ->
              new DateParser(data).to_s()
              array_process(data)         if attributes.webSocket == 'array'
              singleton_process(data) unless attributes.webSocket == 'array'
