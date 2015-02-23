module.exports = function(grunt) {
    "use strict";

    grunt.config.set("requirejs", {
        dev: {
            options: {
                baseUrl: ".tmp/public",
                out: ".tmp/public/resources/js.js",
                
                name: "resources/js",
                include: ["js/require.config", "libs/requirejs/require"],
                insertRequire: ["js/main"],
                
                optimize: "none",
                generateSourceMaps: false,
            }
        },
        build: {
            options: {
                baseUrl: ".tmp/public",
                mainConfigFile: ".tmp/public/js/require.config.js",
                out: ".tmp/public/resources/js.js",
                
                name: "js/main",
                include: ["libs/requirejs/require"],
                insertRequire: ["js/main"],
                
                optimize: "uglify2",
                generateSourceMaps: true,
                preserveLicenseComments: false,
                findNestedDependencies: true
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-requirejs");
};
