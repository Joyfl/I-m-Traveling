server = "http://imtraveling.joyfl.kr";
comments = new Array({"profile_image_src":"resource/face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"profile_image_src":"resource/face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"});
path = new Array({"lat":"40.737102","lng":"-73.990318"}, {"lat":"40.749825","lng":"-73.987963"}, {"lat":"40.752946","lng":"-73.987384"}, {"lat":"40.755823","lng":"-73.986397"});

function refresh()
{
	addFeed(2, 3, "resource/face.jpg", "바나나", "01 JAN", "Las Vegas, USA", "KOR", "resource/thumbnail.jpg", "review", 3, 5);
	addTrip(1001, 1001, "resource/face.jpg", "바나나", "18 JAN ~ 22 JAN", "Las Vegas, USA", "South Korea", path, "I've stayed in this hotel! It was awesome!", 3, 5);
	
	//createFeedDetail(123, 123, 123, "resource/face.jpg", "바나나", "19 JAN", "Las Vegas, USA", "South Korea", new Array(), new Array(), "review review lol", {"lat":"40.718217","lng":"-73.998284"}, 3, 6, comments, false);
	//createTripDetail(123, 123, "resource/face.jpg", "바나나", "19 JAN", "Trip Title", "South Korea", new Array(), "review review", path, 7, 3, 5, comments, false);
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

function fillListContent(content, callback, _thumbnailImageSrc, _likes, _comments, _review)
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

function fillDetailContent(content, callback, _thumbnailImageSrc, _likes, _comments, _info, _review)
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

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var content = createClassElement("div", "content", wrap);
	var callback = function(){ document.location = "imtraveling:feed_detail:" + feed_id; };
	fillListContent(content, callback, picture_url, num_likes, num_comments, review);
}

function addTrip(trip_id, user_id, profile_image_url, name, time, trip_title, region, map_info, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, trip_title, region);
	
	var content = createClassElement("div", "content", wrap);
	var callback = function(){ document.location = "imtraveling:trip_detail:" + trip_id; };
	var map = traceToStaticMapUrl(map_info, "0x0000ff", "4", "300x192", "false");
	fillListContent(content, callback, map, num_likes, num_comments, review);
}

function createFeedDetail(feed_id, trip_id, user_id, profile_image_url, name, time, place, region, pictures, info, review, map_info, num_likes)
{
	var page = document.getElementById("page");
	var wrap = createClassElement("div", "wrap", page);
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var imageScroll = createClassElement("div", "imageScroll", wrap);
	
	var content = createClassElement("div", "content", wrap);
	var callback = document.location = "imtraveling:googleMap:" + "{\"lat\":\"" + map_info.lat + "\",\"lng\":\"" + map_info.lng + "\"}";
	var map = positionToStaticMapUrl(map_info, 0x000033, "S", "260x192", "false");
	fillDetailContent(content, callback, map, num_likes, num_comments, info, review);
}

/*function createTripDetail(trip_id, user_id, profile_image_url, name, time, trip_title, region, companions, review, map_info, num_feeds, num_likes, num_comments, comments, liked)
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
}*/