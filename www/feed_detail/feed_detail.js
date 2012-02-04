// Variables


// Functions

function init()
{
	createFeedDetail(1, 1, "../resource/face.jpg", "바나나", "19 JAN", "Las Vegas", "KOR", "review", 3, 5);
}

function createFeedDetail(trip_id, user_id, profile_image_url, name, time, place, region, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(210, wrap);
	
	var onLike = function() {};
	var onComment = function() {};
	
	var content = createClassElement("div", "content", wrap);
	fillContent(content, 0, onLike, 0, onComment, review);
}

function modifyFeedDetail(time, place, region, review, num_likes, num_comments)
{
	
}