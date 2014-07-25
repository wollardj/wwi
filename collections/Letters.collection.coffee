@Letters = new Meteor.Collection('Letters')
@Letters.allow {
	insert: (userId, doc)->
		Roles.userIsInRole userId, ['admin','editor','author']
	update: (userId, doc, fieldNames, modifier)->
		Roles.userIsInRole userId, ['admin','editor']
	remove: (userId, doc)->
		Roles.userIsInRole userId, ['admin', 'editor']
}
