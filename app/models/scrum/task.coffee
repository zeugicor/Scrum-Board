mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'

ScrumTask = new mongoose.Schema

  label:
    type: String
    required: true
  text:
    type: String
  inProgress:
    type: Boolean
    default: false
  done:
    type: Boolean
    default: false
  effort:
    type: Number
    default: 0
  employee:
    type: String

  project_id:
    type: mongoose.Schema.Types.ObjectId
    ref: 'ScrumProject'


,
  collection: 'scrum.tasks'

# Index
ScrumTask.index
  project_id: 1

# Registrieren von Timestamps
ScrumTask.plugin timestamps

module.exports = ->
  ScrumTask: mongoose.model 'ScrumTask', ScrumTask