module.exports = function (grunt) {
	grunt.registerTask('buildProd', [
		'compileAssets',
		//'concat',
		//'uglify',
        'requirejs:build',
		'cssmin',
		'linkAssetsBuildProd',
		'clean:build',
		'copy:build'
	]);
};
