var express = require('express')
var app = express();
var request = require('request');
var Twitter = require('twitter');

app.use(express.static(__dirname + '/public'));

var client = new Twitter({
  consumer_key: '9KN4xlwXztHv9I4rfhE3NwMii',
  consumer_secret: 'Ml4kmPZBUjhQKzAuirJsZKJcELKcG7nQw30wt9xNCZ8yVhu8JL',
  access_token_key: '174634653-HWyE1Fe7IzEceC1eFhVRrz1D9XdZltzaQLTUcEwl',
  access_token_secret: 'yPrpSp6DtGbSiTb79pZ2RqF4qlvgsVkSKKI2jvOyom1Xx'
});

app.get("/coord/:location", function(req, res, next) {
	var params = {geocode: req.params.location};
	console.log(params);
	client.get('search/tweets', params, function(error, tweets, response){
	  if (!error) {
	  	var result = [];
	  	for (var i = tweets.statuses.length - 1; i >= 0; i--) {
	  		result.push({
	  			name: tweets.statuses[i].user.screen_name,
	  			text: tweets.statuses[i].text,
				img: tweets.statuses[i].user.profile_image_url,
				date: new Date(tweets.statuses[i].created_at)
	  		});
	  	};
	    res.send(result);
	  }
	});
});

app.get("/timeline", function(req, res, next) {
	var params = {screen_name: 'kamokaizen'};
	client.get('statuses/user_timeline', params, function(error, tweets, response){
	  if (!error) {
	    res.send(tweets);
	  }
	});
});

app.listen(8080);
