// Variables


// Functions

function init()
{
	addFeed(1, 1, "../resource/face.jpg", "Nana", "09 JAN", "Las Vegas", "KOR", "../resource/thumbnail.jpg", "review", 3, 3);
}

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", document.getElementById("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(10, wrap);
	var picture = createClassElement("img", "picture", wrap);
	picture.src = picture_url;
	picture.onclick = function() { document.location = "imtraveling:feed_detail:" + feed_id; };
	
	var onLike = function() {};
	var onComment = function() {};
	
	var content = createClassElement("div", "content", wrap);
	fillContent(content, num_likes, onLike, num_comments, onComment, review);
}

function fillGap(gap, pictureUrl)
{
	var picture = createClassElement("img", "picture", gap);
	picture.src = pictureUrl;
}