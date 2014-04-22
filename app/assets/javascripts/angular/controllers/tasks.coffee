"use strict"
application.controller 'TasksController', ['$scope', '$rootScope', 'ScrumTask', ($scope, $rootScope, ScrumTask) ->
    
  $scope.currentTask = new ScrumTask
  $scope.init = () ->
    $scope.tasksToDo = ScrumTask.queryToDo()
    $scope.tasksInProgress = ScrumTask.queryInProgress()
    $scope.tasksDone = ScrumTask.queryDone()

  ###
    @desc BESCHREIBUNG
  ###
  $scope.moveTaskFromToDotoInProgess = (task) ->
    task.inProgress = true
    task.id = task._id

    task.$save ->
      $scope.init()
    , ( err ) ->
      alert err


  ###
    @desc BESCHREIBUNG
  ###
  $scope.moveTaskFromInProgessToDone = (task) ->
    task.inProgress = true
    task.done = true
    task.id = task._id

    task.$save ->
      $scope.init()
    , ( err ) ->
      alert err


  ###
    @desc BESCHREIBUNG
  ###
  $scope.moveTaskFromDoneToInProgress = (task) ->
    task.inProgress = true
    task.done = false
    task.id = task._id

    task.$save ->
      $scope.init()
    , ( err ) ->
      alert err

  $scope.destroy = (task) -> 
    deleteObject = confirm("Sind Sie sicher?")

    if deleteObject 
      console.log "delete"
      ScrumTask.remove
        id: task._id
      , -> 
        $scope.init()
      , ( err ) -> 
        console.log "could not remove"

  $scope.create = () ->
    $scope.currentTask.$save -> 
      $scope.init()
      $scope.currentTask = new ScrumTask
    , ->
      console.log "could not save"

  $scope.update = ( task ) ->
    $scope.currentTask = task

]