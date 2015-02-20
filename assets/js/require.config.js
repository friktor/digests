require.config({
    baseUrl: "/",
    paths: {
        angular: "libs/angular/angular",
        "angular-animate": "libs/angular-animate/angular-animate",
        "angular-capitalize-filter": "libs/angular-capitalize-filter/capitalize",
        "angular-material": "libs/angular-material/angular-material",
        "angular-password": "libs/angular-password/angular-password",
        "angular-resource": "libs/angular-resource/angular-resource",
        "angular-route": "libs/angular-route/angular-route",
        "angular-translate": "libs/angular-translate/angular-translate",
        "angular-translate-loader-static-files": "libs/angular-translate-loader-static-files/angular-translate-loader-static-files",
        "angularjs-placeholder": "libs/angularjs-placeholder/src/angularjs-placeholder",
        async: "libs/async/lib/async",
        highlightjs: "libs/highlightjs/highlight.pack",
        imagesloaded: "libs/imagesloaded/imagesloaded",
        jquery: "libs/jquery/dist/jquery",
        "jquery-bridget": "libs/jquery-bridget/jquery.bridget",
        "jquery.lazyload": "libs/jquery.lazyload/jquery.lazyload",
        "jquery.scrollstop": "libs/jquery.lazyload/jquery.scrollstop",
        lodash: "libs/lodash/lodash",
        masonry: "libs/masonry/dist/masonry.pkgd",
        "ng-file-upload": "libs/ng-file-upload/angular-file-upload",
        "ng-lazyload": "libs/ng-lazyload/nglazyload",
        "ng-tags-input": "libs/ng-tags-input/ng-tags-input.min",
        remarkable: "libs/remarkable/dist/remarkable",
        requirejs: "libs/requirejs/require",
        "sails.io": "libs/sails.io.js/dist/sails.io",
        "socket.io": "libs/socket.io/index",
        stalker: "libs/stalker/jquery.stalker",
        textAngular: "libs/textAngular/src/textAngular",
        "textAngular-sanitize": "libs/textAngular/src/textAngular-sanitize",
        "textAngular-rangy": "libs/textAngular/dist/textAngular-rangy.min",
        textAngularSetup: "libs/textAngular/src/textAngularSetup",
        "vc-angular-recaptcha": "libs/vc-angular-recaptcha/release/angular-recaptcha",
        hammerjs: "libs/hammerjs/hammer",
        "semantic-ui": "libs/semantic-ui/dist/semantic",
        "angular-translate-loader-url": "libs/angular-translate-loader-url/angular-translate-loader-url",
        "angular-aria": "libs/angular-aria/angular-aria",
        "font-awesome": "libs/font-awesome/fonts/*",
        "rangy-core": "libs/rangy/rangy-core.min",
        "rangy-cssclassapplier": "libs/rangy/rangy-cssclassapplier.min",
        "rangy-selectionsaverestore": "libs/rangy/rangy-selectionsaverestore.min",
        "rangy-serializer": "libs/rangy/rangy-serializer.min"
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
                "angular"
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
        "angular-password": {
            deps: [
                "angular"
            ]
        },
        "angular-resource": {
            deps: [
                "angular"
            ]
        },
        "angular-route": {
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
                "angular",
                "angular-translate"
            ]
        },
        "angular-translate-loader-url": {
            deps: [
                "angular",
                "angular-translate"
            ]
        },
        "vc-angular-recaptcha": {
            deps: [
                "angular"
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
                "textAngularSetup"
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
        }
    },
    deps: [
        "js/main"
    ],
    packages: [

    ]
});
