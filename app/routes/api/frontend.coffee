module.exports = ( app ) ->

  # API für verschiedene Tasks
  app.get 		'/api/scrum/tasks', 		app.controllers.api.scrum.tasks.index
  app.post 		'/api/scrum/tasks', 		app.controllers.api.scrum.tasks.create
  app.get 		'/api/scrum/tasks/:id', 	app.controllers.api.scrum.tasks.show
  app.post 		'/api/scrum/tasks/:id', 	app.controllers.api.scrum.tasks.update
  app.delete 	'/api/scrum/tasks/:id', 	app.controllers.api.scrum.tasks.destroy

  # Alle anderen Routen abfangen
  app.all '/api/*', (req, res) ->
    res.status 404
    res.json { error: true, status: 404, message: 'not_found' }