module.exports = ( app ) ->
  class IndexController
    @index = (req, res ) ->
      res.render 'frontend/index'