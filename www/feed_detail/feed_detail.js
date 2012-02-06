// Variables


// Functions

function init()
{
	//createFeedDetail(1, 1, 1, "../resource/face.jpg", "바나나", "19 JAN", "Las Vegas", "KOR", "review", 3, 5);
	//modifyFeedDetail(1, "20 JAN", "Los Angelos", "USA", "review2", 4, 6);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", getId("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(210, wrap);
	
	var content = createClassElement("div", "content", wrap);
	fillContent(content, feed_id, num_likes, num_comments, review);
}

function modifyFeedDetail(feed_id, _time, _place, _region, _review, num_likes, num_comments)
{	
	(getClass("rightTop")[0]).innerText = _time;
	(getClass("leftBottom")[0]).innerText = _place;
	(getClass("rightBottom")[0]).innerText = _region;
	(getClass("review")[0]).innerText = _review;
	(getClass("likeButton")[0]).innerText = num_likes;
	(getClass("commentButton")[0]).innerText = num_comments;
}