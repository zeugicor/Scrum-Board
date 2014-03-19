###
  @desc   Routemanagement für Passport Authentication
  @author Patrick Lehmann <lehmann@bl-informatik.ch>
  @date   2014-03-19
###
passport          = require 'passport'
LocalStrategy     = require('passport-local').Strategy
FacebookStrategy  = require('passport-facebook').Strategy
_                 = require 'underscore'

module.exports = ( app ) ->

  User = app.models.user.User

  ###
  # =========================================================================
  # passport session setup ==================================================
  # =========================================================================
  # required for persistent login sessions
  # passport needs ability to serialize and unserialize users out of session
  ###

  # used to serialize the user for the session
  passport.serializeUser (user, done) ->
    done null, user.id
    return

  
  # used to deserialize the user
  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user
      return

    return

  
  # =========================================================================
  # LOCAL SIGNUP ============================================================
  # =========================================================================
  # we are using named strategies since we have one for login and one for signup
  # by default, if there was no name, it would just be called 'local'
  passport.use "local-signup", new LocalStrategy(
    
    # by default, local strategy uses username and password, we will override with email
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true # allows us to pass back the entire request to the callback
  , (req, email, password, done) ->
    
    # asynchronous
    # User.findOne wont fire unless data is sent back
    process.nextTick ->
      
      # find a user whose email is the same as the forms email
      # we are checking to see if the user trying to login already exists
      User.findOne
        "local.email": email
      , (err, user) ->
        
        # if there are any errors, return the error
        return done(err)  if err
        
        # check to see if theres already a user with that email
        if user
          done null, false, req.flash("signupMessage", "That email is already taken.")
        else
          
          # if there is no user with that email
          # create the user
          newUser = new User()
          
          # set the user's local credentials
          newUser.email = email
          newUser.local.email = email
          newUser.local.password = newUser.generateHash(password)
          
          # save the user
          newUser.save (err) ->
            throw err  if err
            done null, newUser

        return

      return

    return
  )




  # =========================================================================
  # LOCAL LOGIN =============================================================
  # =========================================================================
  # we are using named strategies since we have one for login and one for signup
  # by default, if there was no name, it would just be called 'local'
  passport.use "local-login", new LocalStrategy(
    
    # by default, local strategy uses username and password, we will override with email
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true # allows us to pass back the entire request to the callback
  , (req, email, password, done) -> # callback with email and password from our form
    
    # find a user whose email is the same as the forms email
    # we are checking to see if the user trying to login already exists
    User.findOne
      "local.email": email
    , (err, user) ->
      
      # if there are any errors, return the error before anything else
      return done(err)  if err
      
      # if no user is found, return the message
      return done(null, false, req.flash("loginMessage", "No user found."))  unless user # req.flash is the way to set flashdata using connect-flash
      
      # if the user is found but the password is wrong
      return done(null, false, req.flash("loginMessage", "Oops! Wrong password."))  unless user.validPassword(password) # create the loginMessage and save it to session as flashdata
      
      # all is well, return successful user
      done null, user

    return
  )

  # =========================================================================
  # FACEBOOK ================================================================
  # =========================================================================
  passport.use new FacebookStrategy(
    clientID: "608067779274924" # your App ID
    clientSecret: "6915c907e06087fdbd489da7068f0225" # your App Secret
    callbackURL: "/auth/facebook/callback"
    passReqToCallback: true # allows us to pass in the req from our route (lets us check if a user is logged in or not)
  , (req, token, refreshToken, profile, done) ->
    
    # asynchronous
    process.nextTick ->
      
      # check if the user is already logged in
      unless req.user
        User.findOne
          "facebook.id": profile.id
        , (err, user) ->
          return done(err)  if err          
          if user

            console.log profile._json
            profileJson = profile._json
            # Abfüllen von Informationen aus Facebook, sofern diese
            # noch nicht gesetzt wurden
            if not _.isString(user.firstname) and profileJson.first_name
              user.firstname = profileJson.first_name

            if not _.isString(user.lastname) and profileJson.last_name
              user.lastname = profileJson.last_name

            if not _.isString(user.email) and profileJson.email
              user.email = profileJson.email

            if not _.isString(user.gender) and profileJson.gender
              user.gender = profileJson.gender

            if not _.isString(user.facebook.link) and profileJson.link
              user.facebook.link = profileJson.link

            # Speichern des Benutzers
            user.save ( err ) ->
              throw err if err


            # if there is a user id already but no token (user was linked at one point and then removed)
            unless user.facebook.token
              user.facebook.token = token
              user.facebook.name = profile.name.givenName + " " + profile.name.familyName
              user.facebook.email = profile.emails[0].value
              user.save (err) ->
                throw err  if err
                done null, user

            done null, user # user found, return that user
          else
            
            # if there is no user, create them
            newUser = new User()
            newUser.facebook.id = profile.id
            newUser.facebook.token = token
            newUser.facebook.name = profile.name.givenName + " " + profile.name.familyName
            newUser.facebook.email = profile.emails[0].value
            newUser.save (err) ->
              throw err  if err
              done null, newUser

          return

      else
        
        # user already exists and is logged in, we have to link accounts
        user = req.user # pull the user out of the session
        user.facebook.id = profile.id
        user.facebook.token = token
        user.facebook.name = profile.name.givenName + " " + profile.name.familyName
        user.facebook.email = profile.emails[0].value
        user.save (err) ->
          throw err  if err
          done null, user

      return

    return
  )


  ###
    @desc   Login mit dem lokalen Benutzer
  ###
  app.post '/sign-up', passport.authenticate('local-signup',
    successRedirect: '/profile'
    failureRedirect: '/sign-up'
    failureFlash: true
  )

  ###
    @desc   process the login form
  ###
  app.post('/login', passport.authenticate('local-login', {
    successRedirect : '/profile',
    failureRedirect : '/login',
    failureFlash : true
  }));



  app.get "/login", (req, res) ->
    res.render "frontend/passport/login"


  app.post "/login", passport.authenticate("local-login",
    successRedirect: "/profile" # redirect to the secure profile section
    failureRedirect: "/login" # redirect back to the signup page if there is an error
    failureFlash: true # allow flash messages
  )

  # SIGNUP =================================
  app.get "/sign-up", (req, res) ->
    res.render "frontend/passport/sign_up"

  app.post "/sign-up", passport.authenticate("local-signup",
    successRedirect: "/profile" # redirect to the secure profile section
    failureRedirect: "/signup" # redirect back to the signup page if there is an error
    failureFlash: true # allow flash messages
  )


  ###
    @desc   logout
  ###
  app.get('/logout', ( req, res ) ->
    req.logout()
    res.redirect('/')
  )

  ###
    @desc   Redirect the user to Facebook for authentication.  When complete,
            Facebook will redirect the user back to the application at
            /auth/facebook/callback
  ###
  app.get '/auth/facebook', passport.authenticate('facebook',
    scope: 'email'
  )

  ###
    @desc   Facebook will redirect the user to this URL after approval.  Finish the
            authentication process by attempting to obtain an access token.  If
            access was granted, the user will be logged in.  Otherwise,
            authentication has failed.
  ###
  app.get '/auth/facebook/callback', passport.authenticate('facebook',
    successRedirect: '/profile'
    failureRedirect: '/login'
  ), (req, res) ->
    res.render 'loggedin',
      user: req.user