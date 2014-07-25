###
Global client-side bootstrapping.
###


Meteor.startup ()->

	Router.configure {
		layoutTemplate: 'layout'
		notFoundTemplate: 'notFound'
		loadingTemplate: 'loading'
	}

	Router.onBeforeAction (pause)->
		if Meteor.loggingIn()
			this.render 'loading'
			pause()
		else if not Meteor.user()
			this.render 'login'
			pause()


	Router.map ()->

		# The home route should just be a list of top-level categories;
		# people, places, years, etc.
		this.route 'home', {
			path: '/'
			waitOn: ()-> Meteor.subscribe('Letters')
		}


		# A list of all records
		this.route 'records', {
			path: '/records'
			data: ()-> Letters.find({}, {sort:{cd_id: 1}})
			waitOn: ()-> Meteor.subscribe('Letters')
		}


		# /people A list of types of people
		this.route 'people', {
			path: '/people'
			waitOn: ()-> Meteor.subscribe('Letters')
		}


		this.route 'admin', {
			path: '/admin'
		}
