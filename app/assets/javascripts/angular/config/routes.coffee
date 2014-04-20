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