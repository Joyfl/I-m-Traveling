// addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
function addFeedsByJSON(data)
{
	var obj = JSON.parse(data);
	for(var i = 0; i < obj.length; i++)
		addFeed(
			obj[i].feed_id,
			obj[i].user_id,
			server + "/profile/" + obj[i].user_id + ".jpg",
			obj[i].name,
			obj[i].time,
			obj[i].place,
			obj[i].region,
			server + "/feed/" + obj[i].user_id + "_" + obj[i].feed_id + "_" + obj[i].picture_url + ".jpg",
			obj[i].review,
			obj[i].num_likes,
			obj[i].num_comments
		);
}

// addTrip(trip_id, user_id, profile_image_url, name, time, trip_title, region, map_info, review, num_likes, num_comments)
function addTripsByJSON(data)
{
	var obj = JSON.parse(data);
	for(var i = 0; i < obj.length; i++)
		addTrip(
			obj[i].trip_id,
			obj[i].user_id,
			server + "/profile/" + obj[i].user_id + ".jpg",
			obj[i].name,
			obj[i].time,
			obj[i].trip_title,
			obj[i].region,
			obj[i].map_info,
			obj[i].review,
			obj[i].num_likes,
			obj[i].num_comments
		);
}

// createFeedDetail(feed_id, trip_id, user_id, profile_image_url, name, time, place, region, pictures, info, review, map_info, num_likes)
function createFeedDetailByJSON(data)
{
	var obj = JSON.parse(data);
	createFeedDetail(
		obj.feed_id,
		obj.trip_id,
		obj.user_id,
		server + "/profile/" + obj.user_id + ".jpg",
		obj.name,
		obj.time,
		obj.place,
		obj.region,
		obj.pictures,
		obj.info,
		obj.review,
		obj.map_info,
		obj.num_likes,
		obj.num_comments,
		obj.comments,
		obj.liked
	);
}

// createTripDetail(trip_id, user_id, profile_image_url, name, time, trip_title, region, companions, review, map_info, num_feeds, num_likes, num_comments, comments, liked)
function createTripDetailByJSON(data)
{
	var obj = JSON.parse(data);
	createTripDetail(
		obj.trip_id,
		obj.user_id,
		server + "/profile/" + obj.user_id + ".jpg",
		obj.name,
		obj.time,
		obj.trip_title,
		obj.region,
		obj.pictures,
		obj.companions,
		obj.review,
		obj.map_info,
		obj.num_feeds,
		obj.num_likes,
		obj.num_comments,
		obj.comments,
		obj.liked
	);
}