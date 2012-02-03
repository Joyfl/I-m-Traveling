// Variables


// Functions

function init()
{
	//addFeed(1, 1, "../resource/face.jpg", "Nana", "09 JAN", "Las Vegas", "KOR", "../resource/thumbnail.jpg", "review", 3, 3);
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

function fillTitle(title, user_id, _profileImageSrc, _userName, _rightTop, _leftBottom, _rightBottom)
{
	var profileImage = createClassElement("img", "profileImage", title);
	
	var upperWrap = createClassElement("div", "upperWrap", title);
	var lowerWrap = createClassElement("div", "lowerWrap", title);
	
	var userName = createClassElement("div", "leftTop", upperWrap);
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
	var thumbnailInfo = createClassElement("div", "thumbnailInfo", thumbnailWrap);
	var miniComments = createClassElement("div", "miniComments", thumbnailInfo);
	var miniLikes = createClassElement("div", "miniLikes", thumbnailInfo);
	var review = createClassElement("div", "review", content);
	
	thumbnailImage.src = _thumbnailImageSrc;
	miniLikes.innerText = "☆ " + _likes;
	miniComments.innerText = "▣ " + _comments;
	review.innerText = _review;
	
	thumbnailImage.onclick = callback;
}