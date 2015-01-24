/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {

  /***************************************************************************
  *                                                                          *
  * Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, *
  * etc. depending on your default view engine) your home page.              *
  *                                                                          *
  * (Alternatively, remove this and add an `index.html` file in your         *
  * `assets` directory)                                                      *
  *                                                                          *
  ***************************************************************************/


  // Basic Site Pages

  "/": "SiteController.homepage",

  "/about": "SiteController.about",

  // Authentitications Pages.

  "/login": "AuthController.login",

  "/register": "AuthController.register",

  "/logout": "AuthController.logout",

  // i18n set locale
  "get /setlocale/:locale": {
    controller: "auth", action: "settingLocale"
  },

  // Posts
    "get /latest/:page": {
      controller: "post", action: "latest"
    },

    "get /popular/:page": {
      controller: "post", action: "popular"
    },
    
    "get /popular": {
      controller: "post", action: "popular"
    },

    "get /latest": {
      controller: "post", action: "latest"
    },

    "get /details/:id": {
      controller: "post", action: "details"
    },

    "get /byauthor/:username/:page": {
      controller: "post", action: "byauthor"
    },

    "get /byauthor/:username": {
      controller: "post", action: "byauthor"
    },

  // Hubs
  
    // List
    "get /habs": {
      controller: "hab", action: "list"
    },
  
    "get /habs/:page": {
      controller: "hab", action: "list"
    },

    // Details
    "get /hab/:name": {
      controller: "hab", action: "index"
    },

    "get /hab/:name/:page" : {
      controller: "hab", action: "index"
    },

  // RSS

    // By Hab
    "get /rss/hab/:name.xml": {
      controller: "rss", action: "hab"
    },

    "get /rss/hab/:name/:locale.xml": {
      controller: "rss", action: "hab"
    },

    // By author
    "get /rss/author/:username.xml": {
      controller: "rss", action: "byauthor"
    },

    // Main
    "get /rss/newest.xml": {
      controller: "rss", action: "newest"
    },

    "get /rss/newest.:locale.xml": {
      controller: "rss", action: "newest"
    },

  // Sitemap.xml

    // Posts
    "get /sitemaps/posts.xml": {
      controller: "sitemap", action: "posts"
    },

    // Profiles
    "get /sitemaps/profiles.xml": {
      controller: "sitemap", action: "profiles"
    },

    // Otherwise pages

    "get /sitemaps/otherwise.xml": {
      controller: "sitemap", action: "otherwise"
    },
  
  // Profile
    
    "/profile/:username": {
      controller: "profile", action: "index"
    },
    
    "/profile/:username/addpost": {
      controller: "profile", action: "addpost"
    },

    "/profile/:username/settings": {
      controller: "profile", action: "settings"
    },

    "/profile/:username/edit/:post": {
      controller: "profile", action: "edit"
    },

    "/profile/:username/subscription": {
      controller: "profile", action: "subscription"
    },

  // API

    // Upload
    "post /utils/upload": {
      controller: "upload", action: "index"
    },

    // Auth
    "post /utils/auth/login": {
      controller: "auth", action: "auth"
    },

    "get /utils/auth/isloggedin": "AuthController.isLoggedIn",
  
    // Habs
    "/utils/hab/create": {
      controller: "hab", action: "create"
    },
  
    // User
    "post /utils/user/register": {
      controller: "user", action: "create"
    },

    "get /utils/activate": {
      controller: "user", action: "activate"
    },

    "post /utils/user/update": {
      controller: "user", action: "update"
    },

    "post /utils/user/update_password": {
      controller: "user", action: "updatePassword"
    },

    // Post

    "post /utils/post/create": {
      controller: "post", action: "create"
    },

    "post /utils/post/update": {
      controller: "post", action: "update"
    },

    // Subscribe
    "get /utils/subscribe/activate": {
      controller: "subscribe", action: "activateSubscribe"
    },

    "post /utils/subscribe/destroy": {
      controller: "subscribe", action: "destroy"
    },

    "post /utils/subscribe/create": {
      controller: "subscribe", action: "create"
    },

    // Comment

    "post /utils/comment/create": {
      controller: "comment", action: "create"
    },
};
