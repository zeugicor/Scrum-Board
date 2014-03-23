module.exports = ( app ) ->
  app.get '/', app.controllers.frontend.index.index



  # Alle anderen Routen abfangen
  # app.all '*', (req, res) ->
  # res.status 404
  # res.render 'errors/404'

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect "/"
  return