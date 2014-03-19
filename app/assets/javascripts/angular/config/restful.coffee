###
  @desc     Konfiguration sämtlicher RESTful Ressourcen, damit entsprechende
            Methoden create und update mit den jeweiligen HTTP Verben
            ausgeführt werden.

  @author   Patrick Lehmann <lehmann@bl-informatik.ch>
  @date     2014-03-14
###
application.factory 'my.resource', ['$resource', ($resource) ->
  (url, params, methods) ->
    defaults =
      create:
        method: 'post'
      update:
        method: 'put'

    methods = angular.extend defaults, methods
    resource = $resource url, params, methods
]