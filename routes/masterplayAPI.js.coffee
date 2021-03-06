mongoose  = require('mongoose')
mongo     = require('mongodb')
fs        = require('fs')

mongoose.connect("mongodb://localhost:27017/masterplay")
db = mongoose.connection;
db.on 'error', console.error.bind(console, "connection error")
db.on 'open', ->
    console.log("connection success")


#schemas definitions

# 1: userSchema
userSchema = mongoose.Schema({
  nom     :  {type  : String, default : '', trim: true},
  prenom  :  {type  : String, default : '', trim: true},
  pays    :  {type  : String, default : '', trim: true},
  region  :  {type  : String, default : '', trim: true},
  passion :  {type  : String, default : '', trim: true}
})

#user model
User = mongoose.model('User',userSchema);


#productSchema
productSchema = mongoose.Schema({
    _id      : {type  : Number, default : '', trim: true},
    quantity : {type  : Number, default : '', trim: true}
})

#billSchema
billSchema = mongoose.Schema({
  _id      : {type  : Number, default : '', trim: true},
  user_id  : {type  : Number, default : '', trim: true},
  products : [productSchema]
})

#bill model
Bill    = mongoose.model('Bill',billSchema)
#product model
Product = mongoose.model('Product',productSchema)

#create examples of product

product1 = new Product({
  _id      : 1,
  quantity : 3
})

product2 = new Product({
  _id      : 2,
  quantity : 2
})

myProducts = [product1, product2]

#create a new bill
myBill = new Bill({
  _id       : 1,
  user_id   : 1,
  products  : myProducts
})
###
myBill.save (error, result) ->
  if(error)
    console.error(error)
  else
    console.log(result[0])



###

persons = {firstname: 'Jarode', lastname: 'Zago', age: 30 }
person = Object.create(persons)
person.firstname= 'Gbatey';
person.lastname= 'Tayoro Lucien';
person.age= 56;
exports.person =  (request, response) ->
  response.json(person);


# do all requests with the User model

#GET: /users
exports.allUsers = (request, response) ->
  User.find(null, (error, users) ->
    if(error)
      response.json({error: true})
    else
      fs.writeFile('users.txt',users,(error) ->
          if error
            console.error(error)
            console.log(error.message)
          else
            console.log("file created success fully")
      )
      response.json(users)
  )

#GET: /users/:id
exports.userByIdInArray = (request,response) ->
  User.find(null, (error,users) ->
    if(error)
      response.json({erro: true})
    else
      response.json(users[request.params.id])


  )

# POST: /users
exports.addUser = (request, response) ->
  response.header("Access-Control-Allow-Origin","*")
  response.header("Access-Control-Allow-Headers","X-Requested-With")

  user = new User({
    nom     :  request.body.nom,
    prenom  :  request.body.prenom,
    pays    :  request.body.pays,
    region  :  request.body.region,
    passion :  request.body.passion
  })
  user.save (error,result) ->
    if error
      console.error(error)
    else
      console.log(result[0])
      response.render('users/index', {title: "User saved successfully", user: result[0]})
    ##mongoose.connection.close()



#GET  /users/:id
exports.user = (request, response) ->
  User.findById(request.params.id,(error,user) ->
    if error
      console.error(error)
    else
      response.json(user)

  )


# PUT : /users/:id
exports.updateUser = (request, response) ->
  User.find(null, (error, users) ->
    if error
      console.error(error.message);
    else
      userToUpdate         = users[request.params.id]
      userToUpdate.nom     = request.body.nom
      userToUpdate.prenom  = request.body.prenom
      userToUpdate.pays    = request.body.pays
      userToUpdate.region  = request.body.region
      userToUpdate.passion = request.body.passion

      User.update(userToUpdate,(error,user) ->
        if error
          console.error(error)
        else
          response.json(user);
      )
      #response.send({title: "User found successfully", user: users[0]})
  )


#Delete : /users/:1
exports.removeUser = (request, response) ->
  User.find(null, (error, users) ->
    if(error)
      console.error(error)
    else
      User.remove(users[request.params.id], (error, result) ->
        if error
          console.error(error)
        else
          response.json({success: true})
      )

  )



exports.membersPage = (request, response) ->
  response.render('members',{members: [{name: 'Jarode Zago', role:'Designer and Developer' },
                                       {name: 'Alexandre LeFourn', role:'Senior Assistant'},
                                       {name:  'Alaric Daré', role: 'Assistant'}]})


exports.aboutPage = (request, response) ->
  response.render('about',{members: {}})


exports.rulesPage = (request, response) ->
  response.render('rules',{members: {}})




