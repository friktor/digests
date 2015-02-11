(->
	$usingModules = window.usingModule
	$usingModules.push "settingsUploadAvatar", "settingsUploadHeader", "settingsUpdatePersonal"
	
	# Define application
	App = angular.module "main", $usingModules
	
	# Config tranlsate provider
	App.config ["$translateProvider", ($translateProvider) ->
		
		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"
	
		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale
		return
	]
	
	# Settings Controller = main controller
	App.controller "SettingsCtrl", ["$scope", "$http", "$log", ($scope, $http, $log) ->
		
	]
)()