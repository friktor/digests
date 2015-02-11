process.chdir(__dirname);
var config;
var fse = require("fs-extra");
var fs = require("fs");

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

  require("async").each(["en", "ru", "pl"], function (i18n, next) {
    var translations = require("./translations/"+i18n+"/index.js");
    var _path = "./config/locales/"+i18n+".json";
    
    fse.removeSync(_path);
    fs.writeFileSync(_path, JSON.stringify(translations, null, "\t"), "utf-8");
    next();
  }, function (error) {
    if (error) console.error(error);

    fs.exists(__dirname+"/.sailsrc", function (exists) {
      if (!exists) return sails.lift();
  
      fs.readFile(__dirname+"/.sailsrc", "utf-8", function (error, config) {
        if (error) {console.error("Error while reading .sailsrc config");}
        
        try {
          var config = JSON.parse(config);
        } catch (_e) {
          console.warn("Error parse .sailsrc file. File isnt valid json.");
        }
  
        sails.lift(config);
      });
    });
  });

})();