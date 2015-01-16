process.chdir(__dirname);

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
  rc = void 0;
  try {
    rc = require("rc");
  } catch (_error) {
    e0 = _error;
    try {
      rc = require("sails/node_modules/rc");
    } catch (_error) {
      e1 = _error;
      console.error("Could not find dependency: `rc`.");
      console.error("Your `.sailsrc` file(s) will be ignored.");
      console.error("To resolve this, run:");
      console.error("npm install rc --save");
      rc = function() {
        return {};
      };
    }
  }
  sails.lift(rc("sails"));
})();
