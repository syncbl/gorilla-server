u_syncbl = User.find_by(name: "syncbl") ||
           User.create(
             name: "syncbl",
             fullname: "Syncbl Repository",
             email: "admin@syncbl.com",
             password: SecureRandom.urlsafe_base64,
             disclaimer: "Syncbl Repository (c) 2021 by Eldar Avatov",
             plan: :unlimited,
           )
