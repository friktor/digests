require.config({
    baseUrl: "/",
    paths: {
        angular: "libs/angular/angular",
        "angular-animate": "libs/angular-animate/angular-animate",
        "angular-capitalize-filter": "libs/angular-capitalize-filter/capitalize",
        "angular-material": "libs/angular-material/angular-material",
        "angular-translate": "libs/angular-translate/angular-translate",
        "angular-translate-loader-static-files": "libs/angular-translate-loader-static-files/angular-translate-loader-static-files",
        highlightjs: "libs/highlightjs/highlight.pack",
        jquery: "libs/jquery/dist/jquery",
        masonry: "libs/masonry/dist/masonry.pkgd",
        "ng-file-upload": "libs/ng-file-upload/angular-file-upload",
        "ng-lazyload": "libs/ng-lazyload/nglazyload",
        "ng-tags-input": "libs/ng-tags-input/ng-tags-input.min",
        remarkable: "libs/remarkable/dist/remarkable",
        requirejs: "libs/requirejs/require",
        textAngular: "libs/textAngular/src/textAngular",
        "textAngular-sanitize": "libs/textAngular/src/textAngular-sanitize",
        "textAngular-rangy": "libs/textAngular/dist/textAngular-rangy.min",
        textAngularSetup: "libs/textAngular/src/textAngularSetup",
        "vc-angular-recaptcha": "libs/vc-angular-recaptcha/release/angular-recaptcha",
        hammerjs: "libs/hammerjs/hammer",
        "angular-translate-loader-url": "libs/angular-translate-loader-url/angular-translate-loader-url",
        "angular-aria": "libs/angular-aria/angular-aria",
        "font-awesome": "libs/font-awesome/fonts/*",
        "semantic-ui": "libs/semantic-ui/dist/semantic",
        "semantic-modules": "libs/semantic-ui/dist/components",
        "jquery-bridget": "libs/jquery-bridget/jquery.bridget",
        async: "libs/async/lib/async",
        lodash: "libs/lodash/lodash",
        "angular-translate-storage-cookie": "libs/angular-translate-storage-cookie/angular-translate-storage-cookie",
        "sails.io": "libs/sails.io.js/dist/sails.io",
        "socket.io": "libs/socket.io/index",

        "googleRecaptchaApi": "//www.google.com/recaptcha/api.js?render=explicit&onload=vcRecapthaApiLoaded&hl=" + window.i18nLocale
    },
    shim: {
        angular: {
            exports: "angular"
        },
        "angular-animate": {
            deps: [
                "angular"
            ]
        },
        "angular-material": {
            deps: [
                "angular",
                "angular-aria",
                "angular-animate"
            ]
        },
        "angular-aria": {
            deps: [
                "angular"
            ]
        },
        "angular-capitalize-filter": {
            deps: [
                "angular"
            ]
        },
        "angular-translate": {
            deps: [
                "angular"
            ]
        },
        "angular-translate-loader-static-files": {
            deps: [
                "angular-translate"
            ]
        },
        "angular-translate-loader-url": {
            deps: [
                "angular-translate"
            ]
        },
        "vc-angular-recaptcha": {
            deps: [
                "angular",
                "googleRecaptchaApi"
            ]
        },
        "ng-file-upload": {
            deps: [
                "angular"
            ]
        },
        "ng-lazyload": {
            deps: [
                "angular"
            ]
        },
        textAngularSetup: {
            deps: [
                "angular"
            ]
        },
        textAngular: {
            deps: [
                "angular",
                "js/options/textAngularSetup",
                "textAngular-rangy",
                "textAngular-sanitize"
            ]
        },
        "textAngular-sanitize": {
            deps: [
                "angular"
            ]
        },
        "textAngular-rangy": {
            deps: [
                "angular"
            ]
        },
        "ng-tags-input": {
            deps: [
                "angular"
            ]
        },
        "semantic-ui": {
            deps: [
                "jquery"
            ]
        },
        "semantic-modules/dropdown": {
            deps: [
                "jquery",
                "semantic-modules/transition"
            ]
        },
        "semantic-modules/modal": {
            deps: [
                "jquery",
                "semantic-modules/dimmer"
            ]
        }
    },
    deps: [
        "js/main"
    ],
    packages: [

    ]
});
