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
	//createMainPage();
	//createLoginPage();
	//clear();
}




// Basic Functions

function makeClass(type, className, parent)
{
	component = document.createElement(type);
	component.className = className;
	parent.appendChild(component);
	return component;
}

function makeId(type, id, parent)
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
	gap.style.height = intToWidth(height);
	parent.appendChild(gap);
	return gap;
}

function clear()
{
	var page = getId("page");
	if(page) document.body.removeChild(page);
	makeId("div", "page", document.body);
}




// Filling Functions

function fillTitle(title, user_id, _profileImageSrc, _userName, _time, _place, _region)
{
	var profileImage = makeClass("img", "profileImage", title);
	
	var upperWrap = makeClass("div", "upperWrap", title);
	var lowerWrap = makeClass("div", "lowerWrap", title);
	
	var userName = makeClass("div", "userName", upperWrap);
	var time = makeClass("div", "time", upperWrap);
	var place = makeClass("div", "place", lowerWrap);
	var region = makeClass("div", "region", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	
	time.innerText = _time;
	place.innerText = _place;
	region.innerText = _region;
	
	var profile = function(){};
	
	profileImage.onclick = profile;
	userName.onclick = profile;
}

function fillContent(content, feed_id, _likes, _comments, _review)
{
	var review = makeClass("div", "review", content);
	var action = makeClass("div", "action", content);
	
	var likeButton = makeClass("div", "likeButton", action);
	var commentButton = makeClass("div", "commentButton", action);
	
	review.innerText = _review;
	likeButton.innerText = "☆ " + _likes;
	commentButton.innerText = "▣ " + _comments;
	
	likeButton.onclick = function() {};
	commentButton.onclick = function() {};
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
	var wrap = makeClass("div", "wrap", getId("page"));
	
	var title = makeClass("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(10, wrap);
	var picture = makeClass("img", "picture", wrap);
	picture.src = picture_url;
	
	var content = makeClass("div", "content", wrap);
	fillContent(content, feed_id, num_likes, num_comments, review);
	
	picture.onclick = function() { document.location = "imtraveling:feed_detail:" + feed_id; };
}

function loadFeedImage(index, feed_image_url)
{
	var scroll = getId("scroll");
	if(scroll == null)
	{
		document.body.style.width = intToWidth(imageWidth);
		scroll = makeId("div", "scroll", getId("page"));
	}
	if(imageWidth * (index + 1) > widthToInt(document.body.style.width))
		document.body.style.width = intToWidth(imageWidth * (index + 1));
	var image = makeClass("img", "detailImage", scroll);
	image.style.width = intToWidth(imageWidth - 2 * margin);
	image.style.height = intToWidth(imageHeight);
	image.style.left = intToWidth(imageWidth * index);
	image.src = feed_image_url;
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, review, num_likes, num_comments)
{
	var wrap = getId("page");
	
	var title = makeClass("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	var gap = createGap(210, wrap);
	
	var content = makeClass("div", "content", wrap);
	fillContent(content, feed_id, num_likes, num_comments, review);
}

function modifyFeedDetail(feed_id, time, place, region, review, num_likes, num_comments)
{	
	(getClass("time")[0]).innerText = time;
	(getClass("place")[0]).innerText = place;
	(getClass("region")[0]).innerText = region;
	(getClass("review")[0]).innerText = review;
	(getClass("likeButton")[0]).innerText = num_likes;
	(getClass("commentButton")[0]).innerText = num_comments;
}

function createMainPage()
{
	var wrap = getId("page");
	
	makeId("img", "mainPicture", wrap).src = pic2;
	
	var login = makeClass("div", "mainButton", wrap);
	var signUp = makeClass("div", "mainButton", wrap);
	var cancel = makeClass("div", "mainButton", wrap);
	
	login.innerText = "Login";
	signUp.innerText = "Sign Up";
	cancel.innerText = "Cancel";
	
	login.onclick = function() {};
	signUp.onclick = function() {};
	calcel.onclick = function() {};
}