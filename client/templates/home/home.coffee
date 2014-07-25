Session.setDefault 'soldier_is_sender', true
Session.setDefault 'genre_is_postcard', false


# Tallies the total number of times a name appears in an array of objects
# The objects are expected to be {name: "", value: 1}
tally = (name, arr)->
	if name is ""
		return

	exists = false
	for obj,i in arr
		if obj.name is name
			arr[i].value++
			exists = true
			break
	if not exists
		arr.push {name: name, value: 1}


# A complement to tally() which sorts the objects in descending order
# according to the `value` field
tally_sort = (arr)->
	arr.sort (a,b)->
		if a.value < b.value
			1
		else if a.value is b.value
			0
		else
			-1


Template.home.total_letters = ->
	Letters.find().count()


Template.home.top_10_people = ->
	results = []
	Letters.find({}, {
		fields: {
			soldier_surname:true
			soldier_given_name:true
			other_sender: true
			recipient: true
			}
		}
	).fetch().map (it)->
		tally it.soldier_given_name + ' ' + it.soldier_surname, results
		tally it.other_sender, results
		tally it.recipient, results
	
	_.first tally_sort(results), 10


Template.home.top_10_places_of_origin = ->
	results = []
	Letters.find({}, {fields: {origin_address: true}})
	.fetch().map (it)->
		tally it.origin_address, results
	_.first tally_sort(results), 10


Template.home.letters_per_year = ->
	results = []
	Letters.find({}, {fields: {correspondence_date:true, postmark_date: true}})
	.fetch().map (it)->
		if it.postmark_date? and it.correspondence_date?
			d = it.correspondence_date
		else if it.correspondence_date?
			d = it.correspondence_date
		else if it.postmark_date?
			d = it.postmark_date

		if d? and d.getFullYear? and d.getFullYear() isnt 1969
			tally d.getFullYear(), results

	tally_sort results




Template.home.events {
	"click #save_continue": (event)->
		event.stopPropagation()
		event.preventDefault()
		Template.new_correspondence.process_form()
}