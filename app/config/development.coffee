express = require 'express'

module.exports = (app) ->
  app.configure 'development' ->
    app.set 'name', 'Creative Tool'
    app.set 'port', process.env.PORT || 3000
    app.use express.errorHandler()

    app.locals.pretty = true