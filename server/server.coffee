# Publish the Meteor.roles collection from the meteor-roles package.
Meteor.publish null, ->
  Meteor.roles.find {}


Meteor.startup ->
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
