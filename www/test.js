// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"});
path = new Array({"lat":"40.737102","lng":"-73.990318"}, {"lat":"40.749825","lng":"-73.987963"}, {"lat":"40.752946","lng":"-73.987384"}, {"lat":"40.755823","lng":"-73.986397"});
imageWidth = 320;
imageHeight = 200;
margin = 10;
iconLike = "resource/like.png";
iconComment = "resource/comment.png";




// Initialize 

function init()
{
	clear();
	
	//addFeed(1, 1, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, "revivieweeviweviewevieweviewvieweviewevieweview", 113, 113);
	//addFeed(1, 1, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, "revivieweeviweviewevieweviewvieweviewevieweview", 3, 3);
	
	//createMainPage();
	//createLoginPage();
	
	//createTitle(123, pic1, "바나나", "19 JAN", "Las Vegas", "KOR");
	//modifyTitle("20 JAN", "Los Angelos", "USA");
	
	//createFeedDetail(1, 1, pic2, "revivieweeviweviewevieweviewvieweviewevieweview", new Object(), new Array(), new Array());
	
	//for(var i = 0; i < 7; i++) addComment(getId("page"), 123, pic1, "바나나", "20 FEB", "revivieweeviweviewevieweviewvieweviewevieweview");
	
	for(var i = 0; i < 7; i++) addSimpleFeed(123, pic2, "Las Vegas", "10 FEB", "revivweview");
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
	gap.style.height = intToPixel(height);
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
	var cover = makeClass("div", "cover profileImage", title);
	
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

function fillThumbnailWrap(thumbnailWrap, pictureUrl, _likes, _comments)
{
	var cover = makeClass("div", "cover thumbnail", thumbnailWrap);
	var thumbnail = makeClass("img", "thumbnail", thumbnailWrap);
	var feedback = makeClass("div", "feedback", thumbnailWrap);
	
	var commentWrap = makeClass("div", "iconWrap", feedback);
	var likeWrap = makeClass("div", "iconWrap", feedback);
	
	var likeIcon = makeClass("img", "icon", likeWrap);
	var commentIcon = makeClass("img", "icon", commentWrap);
	
	var likeText = makeClass("div", "iconText likeText", likeWrap);
	var commentText = makeClass("div", "iconText commentText", commentWrap);
	
	likeIcon.src = iconLike;
	commentIcon.src = iconComment;
	
	likeText.innerText = _likes;
	commentText.innerText = _comments;
	
	thumbnail.src = pictureUrl;
	thumbnail.onload = function() { cover.style.height = intToPixel(thumbnail.clientHeight); }
}



// Supporting Functions

function pixelToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToPixel(value) { return value.toString() + "px"; }

function getId(_id) { return document.getElementById(_id); }
function getName(_name) { return document.getElementsByName(_name); }
function getClass(_name) { return document.getElementsByClassName(_name); }




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = makeClass("div", "wrap", getId("page"));
	
	var title = makeClass("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	createGap(14, wrap);
	
	var thumbnailWrap = makeClass("div", "thumbnailWrap", wrap);
	fillThumbnailWrap(thumbnailWrap, picture_url, num_likes, num_comments);
	
	var reviewText = makeClass("div", "review", wrap);
	reviewText.innerText = review;
	
	thumbnailWrap.onclick = function() { document.location = "imtraveling:feed_detail:" + feed_id; };
}

function addSimpleFeed(feed_id, picture_url, place, time, review)
{
	var wrap = makeClass("div", "singleComment", getId("page"));
	
	var cover = makeClass("div", "cover simpleThumbnail", wrap);
	var simpleThumbnail = makeClass("img", "simpleThumbnail", wrap);
	
	var upperWrap = makeClass("div", "upperWrap", wrap);
	var lowerWrap = makeClass("div", "lowerWrap", wrap);
	
	var placeText = makeClass("div", "place", upperWrap);
	var timeText = makeClass("div", "time", upperWrap);
	var reviewText = makeClass("div", "review", lowerWrap);
	
	simpleThumbnail.src = picture_url;
	placeText.innerText = place;
	timeText.innerText = time;
	reviewText.innerText = review;
	
	upperWrap.style.width = "63%";
	lowerWrap.style.width = "63%";
	wrap.style.height = intToPixel(70 + reviewText.clientHeight);
}

function addComment(commentWrap, user_id, profile_image_url, name, time, content)
{
	var wrap = makeClass("div", "singleComment", commentWrap);
	var cover = makeClass("div", "cover profileImage", wrap);
	var profileImage = makeClass("img", "profileImage", wrap);
	
	var upperWrap = makeClass("div", "upperWrap", wrap);
	var lowerWrap = makeClass("div", "lowerWrap", wrap);
	
	var nameText = makeClass("div", "userName", upperWrap);
	var timeText = makeClass("div", "time", upperWrap);
	var contentText = makeClass("div", "review", lowerWrap);
	
	profileImage.src = profile_image_url;
	nameText.innerText = name;
	timeText.innerText = time;
	contentText.innerText = content;
	wrap.style.height = intToPixel(24 + contentText.clientHeight);
}

function createFeedDetail(trip_id, feed_id, picture_url, review, info, likes, comments)
{
	var wrap = getId("page");
	
	var cover = makeClass("div", "cover detailImage", wrap);
	var picture = makeClass("img", "detailImage", wrap);
	var reviewText = makeClass("div", "review", wrap);
	
	reviewText.innerText = review;
	picture.src = picture_url;
	picture.onload = function() { cover.style.height = intToPixel(picture.clientHeight); }
	
	var infoWrap = makeClass("div", "infoWrap", wrap);
	
}

function createTitle(user_id, profile_image_url, name, time, place, region)
{
	var title = makeClass("div", "title", getId("page"));
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
}

function modifyTitle(time, place, region)
{
	(getClass("time")[0]).innerText = time;
	(getClass("place")[0]).innerText = place;
	(getClass("region")[0]).innerText = region;
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