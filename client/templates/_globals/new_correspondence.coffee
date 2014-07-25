letter_search = (query, field)->
	if !query? or query.trim() is ''
		return {}

	doc = {}
	opts = {fields:{}}
	doc[field] = new RegExp('.*' + query + '.*', 'i')
	opts.fields[field] = true
	res = Letters.find(doc, opts).fetch().map (it)->
		it[field]
	.sort()

	res = _.unique(res).map (it)->
		{value: it}
	_.first(res, 10)


Template.new_correspondence.rendered = ->
	Meteor.typeahead.inject()

Template.new_correspondence.ac_soldier_surname = (query, cb)->
	cb letter_search(query, 'soldier_surname')

Template.new_correspondence.ac_soldier_given_name = (query, cb)->
	cb letter_search(query, 'soldier_given_name')

Template.new_correspondence.ac_other_sender = (query, cb)->
	cb letter_search(query, 'other_sender')

Template.new_correspondence.ac_origin_address = (query, cb)->
	cb letter_search(query, 'origin_address')

Template.new_correspondence.ac_destination_address = (query, cb)->
	cb letter_search(query, 'destination_address')

Template.new_correspondence.ac_recipient = (query, cb)->
	cb letter_search(query, 'recipient')

Template.new_correspondence.ac_postmark_site = (query, cb)->
	cb letter_search(query, 'postmark_site')



Template.new_correspondence.soldier_is_sender = ->
	Session.get 'soldier_is_sender'

Template.new_correspondence.genre_is_postcard = ->
	Session.get 'genre_is_postcard'

Template.new_correspondence.process_form = ->
	doc = {
		'cd_id': ''
		'archive_id': ''
		'sender_is_soldier': false
		'soldier_surname': ''
		'soldier_given_name': ''
		'other_sender': ''
		'origin_address': ''
		'relationship': ''
		'recipient': ''
		'destination_address': ''
		'correspondence_date': ''
		'genre': ''
		'postcard_cover_description': ''
		'postmark_date': ''
		'postmark_site': ''
		'notes': ''
	}

	for own key,val of doc
		if key.match(/date$/) isnt null and $('#' + key).val()
			doc[key] = new Date( $('#' + key).val() )
		else if key is 'sender_is_soldier'
			doc[key] = $('#' + key).is(':checked')
		else
			doc[key] = $('#' + key).val()

		$('#' + key).val('')

	Letters.insert(doc)



Template.new_correspondence.events {
	"change #sender_is_soldier": (event)->
		Session.set 'soldier_is_sender', $(event.target).is(':checked')


	"change #genre": (event)->
		if $(event.target).val() is 'postcard'
			Session.set 'genre_is_postcard', true
		else
			Session.set 'genre_is_postcard', false


	"submit form": (event)->
		event.stopPropagation()
		event.preventDefault()
}
