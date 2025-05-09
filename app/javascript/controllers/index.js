// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AnimeSearchController from "./anime_search_controller"
application.register("anime-search", AnimeSearchController)

import AutoCompleteController from "./auto_complete_controller"
application.register("auto-complete", AutoCompleteController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SeichiSearchController from "./seichi_search_controller"
application.register("seichi-search", SeichiSearchController)

import StepFormController from "./step_form_controller"
application.register("step-form", StepFormController)
