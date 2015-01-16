 # Community.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models


xss = require "xss"

Community =

  attributes: {
  	
  	name: {
  		type: "string",
  		required: true,
  		maxLength: 120
  	},

  	description: {
  		type: "string",
  		required: true,
  		maxLength: 450,
  	},

  	website: {
  		required: false,
  		type: "string",
  		url: true
  	},

  	team: {
  		type: "array",
  		defaultsTo: [], # Example: [{id: "_uuid", label: "administrator"}, etc...]
  	},

  	# Posts - clientside association. Autoloading and serialize from AJAX request.
  }

Community.attributes.localHab = {
  type: "array",
  defaultsTo: [] # Example: [{name: "_habName", id: "hab_id"}, etc...]
};

Community.beforeValidation = ($Community, next) ->

  $Community.description = xss($Community.description, XSS_opt.plainText);
  $Community.name = xss($Community.name, XSS_opt.plainText);

  next()



module.exports = Community;