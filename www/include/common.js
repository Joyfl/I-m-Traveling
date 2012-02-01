server = "http://imtraveling.joyfl.kr/";

function refresh()
{
	var comments = new Array(
		{"profile_image_src":"face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"},
		{"profile_image_src":"face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"}
	);
	path = new Array({"lat":"40.737102","lng":"-73.990318"}, {"lat":"40.749825","lng":"-73.987963"}, {"lat":"40.752946","lng":"-73.987384"}, {"lat":"40.755823","lng":"-73.986397"});

	//addFeed(2, 3, "face.jpg", "바나나", "01 JAN", "Las Vegas, USA", "KOR", "thumbnail.jpg", "review", 3, 5);
	//addTrip(1001, 1001, "face.jpg", "바나나", "18 JAN ~ 22 JAN", "Las Vegas, USA", "South Korea", path, "I've stayed in this hotel! It was awesome!", 3, 5);
	
	//createFeedDetail(123, 123, "face.jpg", "바나나", "19 JAN", "Las Vegas, USA", "South Korea", new Array(), new Array(), "review review lol", {"lat":"40.718217","lng":"-73.998284"}, 3, 6, comments, false);
	//createTripDetail(123, 123, "face.jpg", "바나나", "19 JAN", "Trip Title", "South Korea", new Array(), "review review", path, 7, 3, 5, comments, false);
}

function createClassElement(type, className, parent)
{
	component = document.createElement(type);
	component.className = className;
	parent.appendChild(component);
	return component;
}

function createIdElement(type, id, parent)
{
	component = document.createElement(type);
	component.id = id;
	parent.appendChild(component);
	return component;
}

function clear()
{
	document.body.removeChild(document.getElementById("page"));
	createIdElement("div", "page", document.body);
}

function positionToStaticMapUrl(mapInfo, color, marker, size, sensor)
{
	var url = "http://maps.googleapis.com/maps/api/staticmap?";
	var pos = mapInfo.lat + "," + mapInfo.lng;
	url += "center=" + pos;
	return url + "&markers=color:" + color + "|label:" + marker + "|" + pos + "&size=" + size + "&sensor=" + sensor;
}

function traceToStaticMapUrl(mapInfo, color, weight, size, sensor)
{
	var url = "http://maps.googleapis.com/maps/api/staticmap?path=";
	var path = "";
	for(var i = 0; i < mapInfo.length; i++)
	{
		path += "|";
		path += mapInfo[i].lat;
		path += ",";
		path += mapInfo[i].lng;
	}
	return url + "color:" + color + "|weight:" + weight + path + "&size=" + size + "&sensor=" + sensor;
}

function fillTitle(title, user_id, _profileImageSrc, _userName, _rightTop, _leftBottom, _rightBottom)
{
	var profileImage = createClassElement("img", "profileImage", title);
	
	var upperWrap = createClassElement("div", "upperWrap", title);
	var lowerWrap = createClassElement("div", "lowerWrap", title);
	
	var userName = createClassElement("div", "userName", upperWrap);
	var rightTop = createClassElement("div", "rightTop", upperWrap);
	var leftBottom = createClassElement("div", "leftBottom", lowerWrap);
	var rightBottom = createClassElement("div", "rightBottom", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	
	rightTop.innerText = _rightTop;
	leftBottom.innerText = _leftBottom;
	rightBottom.innerText = _rightBottom;
	
	var profile = function(){};
	
	profileImage.onclick = profile;
	userName.onclick = profile;
}

function fillContent(content, callback, _thumbnailImageSrc, _likes, _comments, _review)
{
	var thumbnailWrap = createClassElement("div", "thumbnailWrap", content);
	var thumbnailImage = createClassElement("img", "thumbnailImage", thumbnailWrap);
	var feedback = createClassElement("div", "feedback", content);
	var miniComments = createClassElement("div", "miniComments", feedback);
	var miniLikes = createClassElement("div", "miniLikes", feedback);
	var review = createClassElement("div", "review", content);
	
	thumbnailImage.src = _thumbnailImageSrc;
	miniLikes.innerText = "☆ " + _likes;
	miniComments.innerText = "▣ " + _comments;
	review.innerText = _review;
	
	thumbnailImage.onclick = callback;
}

function fillCommentWrap(commentWrap, object_id, type, comments)
{
	var length = comments.length;
	var doMore = false;
	if(length > 8) { length = 8; doMore = true; }
	
	for(var i = 0; i < length; i++)
	{
		var component = createClassElement("div", "comment", commentWrap);
		fillTitle(component, comments[i].user_id, comments[i].profile_image_src, comments[i].name, comments[i].time, comments[i].content, "");
	}
	
	if(doMore)
	{
		var moreComment = createClassElement("div", "buttonOne", commentWrap);
		moreComment.innerText = "See all " + (comments.length - 8) + " comments";
		moreComment.onclick = function(){};
	}	
}

function fillReaction(reaction, object_id, type, liked)
{
	var buttonLike = createClassElement("div", "buttonTwo", reaction);
	var buttonComment = createClassElement("div", "buttonTwo", reaction);
	
	if(liked)
	{
		buttonLike.innerText = "☆ Unlike";
		buttonLike.onclick = function(){ document.location = "imtraveling:" + type + "_detail_unlike:" + feed_id; };
	}
	else
	{
		buttonLike.innerText = "☆ Like";
		buttonLike.onclick = function(){ document.location = "imtraveling:" + type + "_detail_like:" + feed_id; };
	}
	
	buttonComment.innerText = "▣ Comment";
	buttonComment.onclick = function(){ document.location = "imtraveling:" + type + "_detail_comment:" + feed_id; };
}

function addFeedsByJSON(data)
{
	var obj = JSON.parse(data);
	for(var i = 0; i < obj.length; i++)
		addFeed(
			obj[i].feed_id,
			obj[i].user_id,
			server + "/profile/" + obj.user_id + ".jpg",
			obj[i].name,
			obj[i].time,
			obj[i].place,
			obj[i].region,
			server + "/feed/" + obj.user_id + "_" + obj.feed_id + "_" + obj.picture_url + ".jpg",
			obj[i].review,
			obj[i].num_likes,
			obj[i].num_comments
		);
}

function addTripsByJSON(data)
{
	var obj = JSON.parse(data);
	for(var i = 0; i < obj.length; i++)
		addTrip(
			obj[i].trip_id,
			obj[i].user_id,
			server + "/profile/" + obj.user_id + ".jpg",
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

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var content = createClassElement("div", "content", wrap);
	var callback = function(){ document.location = "imtraveling:feed_detail:" + feed_id; };
	fillContent(content, callback, picture_url, num_likes, num_comments, review);
}

function addTrip(trip_id, user_id, profile_image_url, name, time, trip_title, region, map_info, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, trip_title, region);
	
	var content = createClassElement("div", "content", wrap);
	var callback = function(){ document.location = "imtraveling:trip_detail:" + trip_id; };
	var map = traceToStaticMapUrl(map_info, "0x0000ff", "4", "300x192", "false");
	fillContent(content, callback, map, num_likes, num_comments, review);
}

function createFeedDetail(feed_id, trip_id, user_id, profile_image_url, name, time, place, region, pictures, info, review, map_info, num_likes, num_comments, comments, liked)
{
	var page = document.getElementById("page");
	var wrap = createClassElement("div", "wrap", page);
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var imageScroll = createClassElement("div", "imageScroll", wrap);
	
	var content = createClassElement("div", "content", wrap);
	var callback = document.location = "imtraveling:googleMap:" + "{\"lat\":\"" + map_info.lat + "\",\"lng\":\"" + map_info.lng + "\"}";
	var map = positionToStaticMapUrl(map_info, 0x000033, "S", "260x192", "false");
	fillContent(content, callback, map, num_likes, num_comments, review);
	
	var infoWrap = createClassElement("div", "infoWrap", wrap);
	
	var commentWrap = createClassElement("div", "commentWrap", wrap);
	fillCommentWrap(commentWrap, feed_id, "feed", comments);
	
	var reaction = createClassElement("div", "reaction", wrap);
	fillReaction(reaction, feed_id, "feed", liked);
}

function createTripDetail(trip_id, user_id, profile_image_url, name, time, trip_title, region, companions, review, map_info, num_feeds, num_likes, num_comments, comments, liked)
{
	var page = document.getElementById("page");
	var wrap = createClassElement("div", "wrap", page);
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, trip_title, region);
	
	var content = createClassElement("div", "content", wrap);
	var callback = document.location = "imtraveling:googleMap:" + "{\"lat\":\"" + map_info[0].lat + "\",\"lng\":\"" + map_info[0].lng + "\"}";
	var map = traceToStaticMapUrl(map_info, "0x0000ff", "4", "300x192", "false");
	fillContent(content, callback, map, num_likes, num_comments, review);
	
	var companionWrap = createClassElement("div", "companionWrap", wrap);
	
	var seeAllFeeds = createClassElement("div", "buttonOne", wrap);
	seeAllFeeds.innerText = "See all " + num_feeds + " feeds";
	seeAllFeeds.onclick = function(){};
	
	var commentWrap = createClassElement("div", "commentWrap", wrap);
	fillCommentWrap(commentWrap, trip_id, "trip", comments);
	
	var reaction = createClassElement("div", "reaction", wrap);
	fillReaction(reaction, trip_id, "trip", liked);
}