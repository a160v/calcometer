// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import DistanceCalculatorController from "./distance_calculator_controller"
application.register("distance-calculator", DistanceCalculatorController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import TimeCalculatorController from "./time_calculator_controller"
application.register("time-calculator", TimeCalculatorController)

import TreatmentFormController from "./treatment_form_controller"
application.register("treatment-form", TreatmentFormController)

import TreatmentsController from "./treatments_controller"
application.register("treatments", TreatmentsController)
