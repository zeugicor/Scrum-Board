module.exports = ( app ) ->

  authenticatedOrNot = (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.redirect "/login"
    return
  userExist = (req, res, next) ->
    User.count
      username: req.body.username
    , (err, count) ->
      if count is 0
        next()
      else
        
        # req.session.error = "User Exist"
        res.redirect "/singup"
      return

    return