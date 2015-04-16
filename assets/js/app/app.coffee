define [
		"angular",
		"angular-translate",
		"angular-translate-loader-url",
		"angular-translate-loader-static-files",
		"angular-capitalize-filter",
		"angular-aria",
		"angular-material",
		"angular-animate",
		# "vc-angular-recaptcha",
		"ng-file-upload",
		"ng-lazyload",
		"textAngular",
		"ng-tags-input",
	], (angular) ->

	"use strict";
	depsModules = [
		"pascalprecht.translate",
		"angular-capitalize-filter",
		"ngMaterial",
		"ngAnimate",
		"ngLazyload",
		# "vcRecaptcha",
		"angularFileUpload",
		"textAngular",
		"ngTagsInput",
	]

	App = angular.module "app", depsModules

	App.config ["$translateProvider", ($translateProvider) ->

		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		$translateProvider.preferredLanguage window.i18nLocale
		return
	]

	return App