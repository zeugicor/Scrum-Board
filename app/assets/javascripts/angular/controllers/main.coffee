###
  @desc       

  @author     Patrick Lehmann <lehmann@bl-informatik.ch>
  @date       2014-03-06
  @name       MainController
###

"use strict"
application.controller 'MainController', ['$scope', '$rootScope', ($scope, $rootScope) ->
  
  $rootScope.wsHost = location.origin.replace(/^http/, "ws")
  $rootScope.ws = new WebSocket($rootScope.wsHost)


  ###
    @desc   Registrieren der aktuellen Benutzer ID
    @author Patrick Lehmann <lehmann@bl-informatik.ch>
  ###
  $scope.registerUserId = ( userId ) ->
    if _.isString(userId)
      $rootScope.user = userId

  ### 
    @desc   Socket Connection Opened
  ###
  $rootScope.ws.onopen = () ->
    console.log 'WS connection opened'
    if not _.isUndefined($rootScope.user)
      $scope.$apply ->
        $rootScope.socketConnectionOpen = true
      tmp =
        route:    'register'
        data:     
          _id:    $rootScope.user
        error:    false

      $rootScope.wsSendJSON(tmp)



  ### 
    @desc   Socket Connection Closed
  ###
  $rootScope.ws.onclose = () ->
    $scope.$apply ->
      $rootScope.socketConnectionOpen = false
    console.log 'WS connection closed'


  ###
    @desc   Diese Methode verschickt an den WS Service
            Daten im JSON Format.

    @params {Object} json
    @author Patrick Lehmann <lehmann@bl-informatik.ch>
  ###
  $rootScope.wsSendJSON = ( json ) ->
    $rootScope.ws.send(JSON.stringify(json))

]