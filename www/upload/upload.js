feedArray = new Array();

function refresh()
{
	// create list
	for(var index = 0; index < 10; index++)
		addFeed(1001, "../face.jpg", "바나나", "Riviera Hotel", "2012.01.18", "Las Vegas, USA", "../thumbnail.jpg", "I've stayed in this hotel! It was awesome!", 3, 5);
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

function addFeed(feed_id, profile_image_url, name, place, time, region, picture_url, review, num_likes, num_comments)
{
	feedArray.push(feed_id);
	feedList = document.getElementById("feedList");
	var component = createClassElement("li", "li", feedList);
	var wrap = createIdElement("div", "__item" + feedArray.length, component);
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, profile_image_url, name, place, time, region);
	
	var content = createClassElement("div", "content", wrap);
	fillContent(content, picture_url, num_likes, num_comments, review);
}

function fillTitle(title, _profileImageSrc, _userName, _place, _time, _region)
{
	var profileImageWrap = createClassElement("a", "profileImageWrap", title);
	var profileImage = createClassElement("img", "profileImage", profileImageWrap);
	
	var leftBlock = createClassElement("div", "leftBlock", title);
	var rightBlock = createClassElement("div", "rightBlock", title);
	
	var userName = createClassElement("a", "userName", leftBlock);
	var place = createClassElement("div", "place", leftBlock);
	var time = createClassElement("div", "time", rightBlock);
	var region = createClassElement("div", "region", rightBlock);
	
	profileImageWrap.href = "#";
	profileImage.src = _profileImageSrc;
	userName.href = "#";
	userName.innerText = _userName;
	place.innerText = _place;
	time.innerText = _time;
	region.innerText = _region;
}

function fillContent(content, _thumbnailImageSrc, _likes, _comments, _review)
{	
	var thumbnail = createClassElement("a", "thumbnail", content);
	var thumbnailImage = createClassElement("img", "thumbnailImage", thumbnail);
	var info = createClassElement("div", "info", thumbnail);
	var likes = createClassElement("div", "likes", info);
	var comments = createClassElement("div", "comments", info);
	var review = createClassElement("div", "review", content);
	
	thumbnail.href = "#";
	thumbnailImage.src = _thumbnailImageSrc;
	likes.innerText = "☆ " + _likes;
	comments.innerText = " ▣ " + _comments
	review.innerText = _review;
}