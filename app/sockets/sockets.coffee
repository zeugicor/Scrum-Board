WebSocketServer   = require("ws").Server
uuid              = require 'node-uuid'
_                 = require 'underscore'

module.exports = (app, server) ->
  ###
    WS Server
  ###
  User            = app.models.user.User
  ChatMessage     = app.models.chat.message.ChatMessage
  SocketSignIn    = app.models.socket.signIn.SocketSignIn

  # Listen mit Benutzern
  @clients = new Object    # Enthält die eizelnen Socket Verbindungen

  wss = new WebSocketServer(server: server)
  console.log "websocket server created"

  wss.on 'connection', ( ws ) ->
    userId = undefined

    # Laden der Benutzer
    User
      .find({})
      .exec( ( err, users ) ->
        if not err
          tmp = {
            route:      'users.index'
            data:       users
            error:      false
          }
          ws.send(JSON.stringify(tmp))
      )

    # Laden der alten Chat Nachrichten
    ChatMessage
      .find({})
      .limit(100)
      .populate('user')
      .sort('-createdAt')
      .exec( (err, messages) ->
        if not err
          tmp = {
            route:        'chat.messages.index'
            data:         messages
            error:        false
          }
          ws.send(JSON.stringify(tmp))
      )





    ws.on 'message', ( message ) ->
      message = JSON.parse(message)

      console.log "#{message.route} called ..."

      switch message.route
        when 'chat.messages.index'          then chatMessagesIndex(message)
        when 'chat.messages.create'         then chatMessagesCreate(message)
        when 'chat.messages.destroy'        then chatMessagesDestroy(message)
        when 'register'                     then register(message, ws)
        when 'users.index'                  then usersIndex(message)






    ws.on 'close', ->
      #if not _.isUndefined(users[userId])
      #  console.log "client " + users[userId].email + " closed connection"
      SocketSignIn.remove
        _id: userId
      , (err) ->
        if not err
          delete clients[userId]
          console.log "Connection #{userId} closed ..."


    ###
      @desc     Registriert einen neuen Benutzer für den Webservice
      @name     register
      @author   Patrick Lehmann <lehmann@bl-informatik.ch>
      @params   {Object} message
      @params   {WebSocket} ws
    ###
    register = ( message, ws ) ->
      userId    = message.data._id
      uid       = uuid.v1()

      User.findOne( { _id: userId })
        .exec( ( err, user ) ->
          if not err
            clients[uid] = {
              ws:     ws
            }

            tmp = {
              route:      'online-users.show'
              data:       user
              error:      false
            }

            for client in clients
              console.log client.user
              client.ws.send JSON.stringify(tmp)

        )



    ###
      @desc     Nachdem eine neue Chatnachricht empfangen wurde und 
                erfolgreich in der Datenbank gespeichert wurde,
                wird eine Nachricht retourniert.

      @name     chat.messages.create
      @returns  chat.messages.show
      @author   Patrick Lehmann <lehmann@bl-informatik.ch>
      @params   {Object} message
    ###
    chatMessagesCreate = ( message ) ->
      newMessage =              new ChatMessage
      newMessage.user =         message.data.user
      newMessage.message =      message.data.message

      newMessage.save ( err ) ->
        if not err
          ChatMessage.findOne( _id: newMessage._id )
            .populate('user')
            .exec(
              ( err, message ) ->
                if not err
                  tmp = {
                    route:      'chat.messages.show'
                    data:       message
                    error:      false
                  }

                broadcastToClients(tmp)
                              
            )



    ###
      @desc     Löschen einer Chat Nachricht

      @name     chat.messages.destroy
      @returns  chat.messages.destroy
      @author   Patrick Lehmann <lehmann@bl-informatik.ch>
      @params   {Object} message
    ###
    chatMessagesDestroy = ( message ) ->
      console.log message
      ChatMessage.remove
        _id: message.data._id
        user: message.data.user._id
      , (err) ->
        if not err
          tmp = {
            route:    'chat.messages.destroy'
            data:     message.data._id
            error:    false    
          }

          broadcastToClients(tmp)


    broadcastToClients = ( json ) ->
      for id of clients
        try
          clients[id].ws.send JSON.stringify(json)