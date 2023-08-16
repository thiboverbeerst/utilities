
db.restaurants.find(
{
    $and : [
    { $or : [{ "cuisine" : "American" },{ "cuisine" : "Italion" }]},
    { "grades.score": { $gte: 55}},
    { 'borough': { $not: { $regex: "Bronx" } }}
    ],
},
{
    "_id": 0
});


db.restaurants.find(
{"address.coord.1": {$gt: 42, $lte : 52}},
{"restaurant_id": 1, "name": 1, "address": 1, "coord": 1}
);