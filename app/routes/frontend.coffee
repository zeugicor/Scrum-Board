module.exports = ( app ) ->
  app.get '/',                                app.controllers.frontend.index.index

  app.get '/chat', isLoggedIn,                app.controllers.frontend.chat.index
  app.get '/profile', isLoggedIn,             app.controllers.frontend.profile.index



  # Alle anderen Routen abfangen
  # app.all '*', (req, res) ->
  #   res.status 404
  #   res.render 'errors/404'

isLoggedIn = (req, res, next) ->
  return next()  if req.isAuthenticated()
  res.redirect "/"
  return