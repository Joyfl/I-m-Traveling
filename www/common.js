// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"});
path = new Array({"lat":"40.737102","lng":"-73.990318"}, {"lat":"40.749825","lng":"-73.987963"}, {"lat":"40.752946","lng":"-73.987384"}, {"lat":"40.755823","lng":"-73.986397"});
imageWidth = 320;
imageHeight = 200;
margin = 10;




// Initialize 

function init()
{
	//for(var i = 0; i < 5; i++) loadFeedImage(i, pic2);
	//createFeedDetail(1, 1, 1, pic1, "바나나", "19 JAN", "Las Vegas", "KOR", "review", 3, 5);
	//modifyFeedDetail(1, "20 JAN", "Los Angelos", "USA", "review2", 4, 6);
	//addFeed(1, 1, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, "review", 3, 3);
}




// Basic Functions

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

function createGap(height, parent)
{
	gap = document.createElement("div");
	gap.className = "gap";
	parent.appendChild(gap);
	gap.style.height = intToWidth(height);
	return gap;
}

function clear()
{
	var page = getId("page");
	if(page) document.body.removeChild(page);
	createIdElement("div", "page", document.body);
}




// Filling Functions

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

function fillContent(content, feed_id, _likes, _comments, _review)
{
	var review = createClassElement("div", "review", content);
	var action = createClassElement("div", "action", content);
	
	var likeButton = createClassElement("div", "likeButton", action);
	var commentButton = createClassElement("div", "commentButton", action);
	
	review.innerText = _review;
	likeButton.innerText = "☆ " + _likes;
	likeButton.onclick = function() {};
	commentButton.innerText = "▣ " + _comments;
	commentButton.onclick = function() {};
}

function fillGap(gap, pictureUrl)
{
	var picture = createClassElement("img", "picture", gap);
	picture.src = pictureUrl;
}




// Supporting Functions

function widthToInt(width) { return Number(width.slice(0, width.length - 2)); }
function intToWidth(value) { return value.toString() + "px"; }

function getId(_id) { return document.getElementById(_id); }
function getName(_name) { return document.getElementsByName(_name); }
function getClass(_name) { return document.getElementsByClassName(_name); }




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = createClassElement("div", "wrap", getId("page"));
	
	var title = createClassElement("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(10, wrap);
	var picture = createClassElement("img", "picture", wrap);
	picture.src = picture_url;
	picture.onclick = function() { document.location = "imtraveling:feed_detail:" + feed_id; };
	
	var content = createClassElement("div", "content", wrap);
	fillContent(content, feed_id, num_likes, num_comments, review);
}

function loadFeedImage(index, feed_image_url)
{
	var scroll = getId("scroll");
	if(scroll == null)
	{
		document.body.style.width = intToWidth(imageWidth);
		scroll = createIdElement("div", "scroll", getId("page"));
	}
	if(imageWidth * (index + 1) > widthToInt(document.body.style.width))
		document.body.style.width = intToWidth(imageWidth * (index + 1));
	var image = createClassElement("img", "detailImage", scroll);
	image.style.width = intToWidth(imageWidth - 2 * margin);
	image.style.height = intToWidth(imageHeight);
	image.style.left = intToWidth(imageWidth * index);
	image.src = feed_image_url;
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