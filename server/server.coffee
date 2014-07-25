# Publish the Meteor.roles collection from the meteor-roles package.
Meteor.publish null, ->
  Meteor.roles.find {}


Meteor.startup ->

    # Make sure the default roles are present.
    for role in ['admin', 'author', 'editor']
        try
            Roles.createRole role
        catch e
            # No need to do anything there since the error likely means the role
            # already exsits.


    # Make sure the admin account is present.
    admin_account = {
        name: 'Administrator'
        email: 'admin@wwi.meteor.com'
    }

    admin = Meteor.users.findOne {'profile.name': admin_account.name}
    if not admin?
        admin_id = Accounts.createUser {
            email: admin_account.email
            password: 'admin'
            profile: {name: admin_account.name}
        }

        Roles.addUsersToRoles admin_id, ['admin']
