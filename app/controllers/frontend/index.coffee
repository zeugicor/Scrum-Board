module.exports = ( app ) ->
  class IndexController
    ###
      @name     index
      @author   Patrick Lehmann <lehmann@bl-informatik.ch>
      @desc     Diese Methode retourniert das einfache Template für die Startseite der Applikation
    ###
    @index = (req, res ) ->
      res.render 'frontend/index'