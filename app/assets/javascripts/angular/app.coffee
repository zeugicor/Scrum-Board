'use strict'
###
  @desc     Initialisieren der Applikation ScrubBoardApp
  @date     2014-03-14
  @params   ngCookies:        Support von Cookies
  @params   ngResource:       Standartisierte RESTful Abfragen
  @params   ngRoute:          Route Handling durch AngularJS
  @params   ui-highlight:     Highlighting Feature
  @params   angularMoment:    MomentJS
  @params   angularytics:     Google Analyticsanbindung
  @params   emoji:            Angular Emoji Filter
###
window.application = angular.module('scrumBoardApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute', 'angularytics', 'ui.highlight', 'angularMoment', 'emoji'])