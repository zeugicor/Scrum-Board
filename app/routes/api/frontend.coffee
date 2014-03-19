module.exports = ( app ) ->

  # Alle anderen Routen abfangen
  app.all '/api/*', (req, res) ->
    res.status 404
    res.json { error: true, status: 404, message: 'not_found' }