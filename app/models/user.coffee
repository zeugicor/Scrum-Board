mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
bcrypt = require 'bcrypt-nodejs'

LocalUserSchema = new mongoose.Schema

  firstname:      String
  lastname:       String
  email:          String
  gender:         String

  local:
    email: String
    password: String

  facebook:
    id: String
    username: String
    link: String
    token: String
    email: String
    name: String

  twitter:
    id: String
    token: String
    displayName: String
    username: String

  google:
    id: String
    token: String
    email: String
    name: String

,
  collection: 'acl.users'

###
  @desc   generating a hash
  @name   generateHash
  @author Patrick Lehmann <lehmann@bl-informatik.ch>
  @params {String} password
###
LocalUserSchema.methods.generateHash = (password) ->
  bcrypt.hashSync password, bcrypt.genSaltSync(8), null

###
  @desc   checking if password is valid
  @name   validPassword
  @author Patrick Lehmann <lehmann@bl-informatik.ch>
  @params {String} password
###
LocalUserSchema.methods.validPassword = (password) ->
  bcrypt.compareSync password, @local.password


# Registrieren von Timestamps
LocalUserSchema.plugin timestamps

module.exports = ->
  User: mongoose.model 'User', LocalUserSchema