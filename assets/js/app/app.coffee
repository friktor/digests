(->
	App = angular.module "main", window.usingModule

	App.config ["$translateProvider", ($translateProvider) ->
		
		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale
		return
	]

	return
)()