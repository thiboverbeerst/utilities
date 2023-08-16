
// 1
/*mport, in NoSQLBooster, the data from restaurants.json into the MongoDB database
restaurants, collection restaurants.*/

//First, create the database and the collection.
use restaurants
db.createCollection("C:\\Users\\ThiboVerbeerst\\Code\\utilities\\databases\\resources\\mongo\\scripts\\restaurants.json");
//Secondly, import the data from restaurants.json in the collection.
//File, Import, restaurants.json


// 2
/*Give all documents (restaurants) in the collection restaurants.*/

db.restaurants.find();
db.restaurants.find({});

// 3
/*Give all restaurants in the collection restaurants. Return restaurant_id, name, borough
and zipcode, but not _id.*/
db.restaurants.find({}, {"restaurant_id":1, "name":1, "borough":1, "address.zipcode":1, "_id":0});

// 4
/*Give the alphabetically (by name) first 5 restaurants in the city (borough) Bronx.
In a subsequent statement, give the following 5*/
db.restaurants.find({"borough": "Bronx"})
              .sort({"name":1})
              .limit(5);

db.restaurants.find({"borough": "Bronx"})
              .sort({"name":1})
              .skip(5)
              .limit(5);

// 5
/*Give the restaurants that have achieved a score greater than 80.*/
db.restaurants.find({"grades.score" : {$gt : 80 }});

// 6
/*Give the restaurants which do not have a cuisine "American" and with a score > 70.*/
db.restaurants.find({ "cuisine" : {$ne : "American"}, "grades.score" : {$gt : 70}} );


// 7
/*Give the restaurants in Bronx that have cuisine "American" or "Chinese".
Sort the list ascending by name.*/

db.restaurants.find({ "borough": "Bronx" , $or : [{ "cuisine" : "American" },{ "cuisine" : "Chinese" }]} )
                            . sort({"name":1});

// 8
/*Give the restaurants for which the street is not filled in.*/
db.restaurants.find({ "address.street" : {$exists : false}});

// 9
/*Give the name and type of cuisine for each restaurant in Manhattan.
Sort the list by name.*/
db.restaurants.find({"borough": "Manhattan"}, {"_id":0, "name":1, "cuisine":1})
              .sort({"name":1});


// 10
/*The same question, but display the list as follows:
...
Amerada Hess Express Cafe has a American cuisine
American Express has a American cuisine
American Museum Of Natural History Food Court has an American cuisine
Americas Burger And Wraps has a American cuisine
Amma has a Indian cuisine
Amsterdam Billiards has an American cuisin*/
db.restaurants.find({"borough": "Manhattan"})
              .sort({"name":1})
              . forEach((res) => { print(res.name + " has a " + res.cuisine + " cuisine")});