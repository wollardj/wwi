Meteor.startup ->


	UI.registerHelper 'isAdmin', ->
        # check if user is an admin
        Roles.userIsInRole Meteor.user(), ['admin']

	UI.registerHelper 'isLoggedIn', ->
		Meteor.user()?


	Handlebars.registerHelper 'meteorOnline', ->
		Meteor.status().status is 'connected'

	#/*
	#	Analyes Meteor.status() and returns en empty string if we're
	#	connected. Otherwise, this will return a message.
	#	Examples of strings:
	#
	#	- when status is "waiting"
	#		"Attempt 1. Will try again in 3 seconds"
	#	- when status is "connecting"
	#		"connecting..."
	#	- when status is "offline"
	#		"Offline"
	#	- when status is "failed"
	#		"Connection failed. [...]" where [...] is the failure message
	#*/
	Handlebars.registerHelper 'meteorStatus', ->
		status = Meteor.status()
		if status.status is 'connected'
			true
		else if status.status is 'connecting'
			'connecting...'
		else if status.status is 'offline'
			'offline'
		else if status.status is 'waiting'
			'Attempt ' + status.retryCount +
				'. Will try again in ' + status.retryTime
		else if status.status is 'failed'
			'Connection failed. ' + status.reason


	Handlebars.registerHelper 'currentRoute', ->
		Router.current().route.name


	Handlebars.registerHelper 'absoluteUrl', ->
		Meteor.absoluteUrl()
