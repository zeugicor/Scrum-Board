module.exports = ( app ) ->
  app.get '/',                                app.controllers.frontend.index.index


  # Alle anderen Routen abfangen
  app.all '*', (req, res) ->
    res.status 404
    res.render 'errors/404'