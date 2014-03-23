"use strict"
application.factory "ScrumTask", ($resource) ->
  $resource "/api/scrum/tasks/:id",
    id: "@id"
  ,
    queryToDo:
      method: 'GET'
      params:
        inProgress: false
        done: false
      isArray: true
    queryInProgress:
      method: 'GET'
      params:
        inProgress: true
        done: false
      isArray: true
    queryDone:
      method: 'GET'
      params:
        inProgress: true
        done: true
      isArray: true