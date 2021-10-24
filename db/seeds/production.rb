u_syncbl = User.create fullname: "Syncbl Repository",
                       name: "syncbl",
                       email: "admin@syncbl.com",
                       password: SecureRandom.urlsafe_base64,
                       disclaimer: "Syncbl Repository (c) 2021 by Eldar Avatov",
                       plan: :unlimited

# TODO: Add items
