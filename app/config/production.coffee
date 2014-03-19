express = require 'express'

module.exports = (app) ->
  app.configure 'production' ->
    app.set 'name', 'Creative Tool'
    app.set 'port', process.env.PORT || 3030

    app.use express.compress()