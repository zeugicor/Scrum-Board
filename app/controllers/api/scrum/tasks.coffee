_ = require 'underscore'

module.exports = ( app ) ->
  ScrumTask = app.models.scrum.task.ScrumTask
  class TasksController
    ###
@name index
@desc Retournieren sämtlicher ScrumTasks.
@params {Boolean} Query Parameter inProgress, default: false
@params {Boolean} Query Parameter done, default: false
###
    @index = ( req, res) ->
      # Definieren der Abfrageparameter:
      # Anhand der query Parameter inProgress und done wird die Abfrage entsprechend zusammengesetzt.
      # Ansonsten werden Standardwerte hinterlegt.
      #req.query.inProgress = false if !_.isBoolean(req.query.inProgress)
      #req.query.done = false if !_.isBoolean(req.query.done)

      ScrumTask
        .find(
          inProgress: req.query.inProgress
          done: req.query.done
        )
        .sort('-createdAt')
        .exec( (err, tasks) ->
          if not err
            res.json tasks
          else
            res.status 500
            res.send false
        )

    ###
@name show
@desc Retourniert einen Task als JSON Objekt anhand einer übergebenen ID
Kann kein Task gefunden werden, so wird ein 404 retourniert.
@returns{ScrumTask} task
@params {String} req.params.id: ID des zu suchenden Tasks
###
    @show = ( req, res ) ->
      ScrumTask.findOne( _id: req.params.id )
      .exec(
        ( err, task ) ->
          if not err
            res.json task
          else
            res.status 404
            res.send false
      )


    ###
@name create
@desc Erstellen eines neuen Task Objektes anhand der übergebenen Parameter
###
    @create = ( req, res ) ->
      task = new ScrumTask

      task.label = req.body.label if req.body.label
      task.text = req.body.text if req.body.text
      task.effort = req.body.effort if req.body.effort
      task.employee = req.body.employee if req.body.employee

      task.save ( err ) ->
        if not err
          res.json task
        else
          res.status 402
          res.send false


    ###
@name update
@desc Aktualisieren eines Task Objekts anhand der übergebenen ID
###
    @update = ( req, res ) ->
      # Entfernen der Attribute, welche durch Module / Datenbank gesetzt werden
      req.body = _.omit(req.body, '_id')
      req.body = _.omit(req.body, 'id')
      req.body = _.omit(req.body, 'createdAt')
      req.body = _.omit(req.body, 'updatedAt')

      ScrumTask.findOne( _id: req.params.id )
      .exec(
        ( err, task ) ->
          if not err
            task = _.extend(task, req.body)
            task.save ( err ) ->
              if not err
                res.redirect "/api/scrum/tasks/#{req.params.id}"
              else
                console.log err
                res.status 500
                res.json err
          else
            res.status 404
                
      )

    ###
@name move
@desc Bewegen des Tasks nach rechts
###
    @translate = ( req, res ) ->
      # Entfernen der Attribute, welche durch Module / Datenbank gesetzt werden
      req.body = _.omit(req.body, '_id')
      req.body = _.omit(req.body, 'id')
      req.body = _.omit(req.body, 'createdAt')
      req.body = _.omit(req.body, 'updatedAt')

      ScrumTask.findOne( _id: req.params.id )
      .exec(
        ( err, task ) ->
          if not err
            task = _.extend(task, req.body)
            task.save ( err ) ->
              if not err
                res.redirect "/api/scrum/tasks/#{req.params.id}"
              else
                console.log err
                res.status 500
                res.json err
          else
            res.status 404
                
      )



    ###
@name destroy
@desc Löschen eines Task Objektes anhand der übergebenen ID
###
    @destroy = ( req, res ) ->
      ScrumTask.remove
        _id: req.params.id
      , (err) ->
        if not err
          res.json true
        else
          res.status 500
          res.json {
            error: true
            message: err
          }