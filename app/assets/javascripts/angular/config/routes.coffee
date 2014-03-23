###
  @desc     Konfiguration der Routen für die Applikation

  @author   Patrick Lehmann <lehmann@bl-informatik.ch>
  @date     2014-03-14
###
application.config ($routeProvider) ->


  $routeProvider.when('/',
    templateUrl: 'angular/frontend/index.html'
    controller: 'IndexController'
  )

  $routeProvider.when('/tasks',
    templateUrl: 'angular/frontend/tasks.html'
    controller: 'TasksController'
  )
  
  $routeProvider.otherwise redirectTo: '/'