process.chdir(__dirname);
var config;

(function() {
  var e, e0, e1, rc, sails;
  require("coffee-script/register");
  sails = void 0;
  try {
    sails = require("sails");
  } catch (_error) {
    e = _error;
    console.error("To run an app using `node app.js`, you usually need to have a version of `sails` installed in the same directory as your app.");
    console.error("To do that, run `npm install sails`");
    console.error("");
    console.error("Alternatively, if you have sails installed globally (i.e. you did `npm install -g sails`), you can use `sails lift`.");
    console.error("When you run `sails lift`, your app will still use a local `./node_modules/sails` dependency if it exists,");
    console.error("but if it doesn't, the app will run with the global sails instead!");
    return;
  }


  require("fs").exists(__dirname+"/.sailsrc", function (exists) {
    if (!exists) return sails.lift();

    require("fs").readFile(__dirname+"/.sailsrc", "utf-8", function (error, config) {
      if (error) {console.error("Error while reading .sailsrc config");}
      
      try {
        var config = JSON.parse(config);
      } catch (_e) {
        console.warn("Error parse .sailsrc file. File isnt valid json.");
      }

      sails.lift(config);
    });
  })
})();