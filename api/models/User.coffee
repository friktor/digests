 # User.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs				:: http://sailsjs.org/#!documentation/models

randomString = require "random-string"
bcrypt = require "bcrypt-nodejs"

User =

	# identity: "user"	

	attributes: 
  	
		username: 
			valid_username: true
			type: "string"
			required: true
			unique: true
		
		password: 
			type: "string"
			required: true
			minLength: 7
		
		email: 
			type: "string"
			required: true
			unique: true
			email: true
		
		firstname: 
			type: "string"
			required: true
		
		lastname: 
			type: "string"
			required: true
		
		aboutMe: 
			type: "string"
			maxLength: 500
			defaultsTo: ""
		
		activitiesMe: 
			type: "string"
			maxLength: 500
			defaultsTo: ""
		
		socialNetwork: 
			type: "array"
			defaultsTo: [] # [{name: "vk", url: "https://vk.com/friktor"}]
		
		privileges: 
			type: "integer"
			defaultsTo: "111" # 111 - Пользователь, Обычный, Неактивированный
		
		admin: 
			type: "boolean"
			defaultsTo: false

		activation: 
			defaultsTo: false
			type: "boolean"
		
		online:
			defaultsTo: false
			type: "boolean"

		toJSON: ->
		  $User = @toObject()
		  delete $User.activationToken
		  delete $User.hashedPassword
		  delete $User.socialNetwork
		  delete $User.subscription
		  delete $User.activation
		  delete $User.privileges
		  delete $User.password
		  delete $User.online
		  delete $User.createdAt
		  delete $User.updatedAt
		  delete $User.admin
		  # delete $User.email
		  return $User

###
Ассоциации
###

#@ Изображение шапка профиля
User.attributes.headingImg = 
	via: "headingImg"
	collection: "file"

#@ Изображение аватар	
User.attributes.avatarImg = 
	via: "avatarImg"
	collection: "file"

#@ Комментарии
User.attributes.comments =
	collection: "comment"
	via: "author"

#@ Подписки
User.attributes.subscription =
	collection: "subscribe"
	via: "user"

###
Валидация имени пользователя - исключение запрещенных символов.
###
valid_username = (username) -> 
	return /^[a-zA-Z0-9_\-\?]+$/.test username

User.types = 
	valid_username: valid_username

# Шифрование пароля
User.beforeCreate = ($User, next) ->
	$User.hashedPassword = bcrypt.hashSync $User.password
	$User.activationToken = randomString length: 50
	next()


module.exports = User;
