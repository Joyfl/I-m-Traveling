// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"});
infos = new Array({"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"});
likes = new Array({"name":"바나나", "user_id":"123"}, {"name":"진서연", "user_id":"321"});
iconLike = "resource/like.png";
iconComment = "resource/comment.png";
marginInPixel = 8;
marginInEm = 0.5;



// Initialize 

function init()
{
	clear();
	
	for(var i = 0; i < 2; i++) addFeed(i, i, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, "ASKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewvieweviewevieweview", 113, 113);
	
	//addFeedDetail(9, 1, infos, 3, 4, 5);
	
	//createMainPage();
	//createLoginPage();
	
	//createTitle(123, pic1, "바나나", "19 JAN", "Las Vegas", "KOR");
	//modifyTitle("20 JAN", "Los Angelos", "USA");
	
	//createFeedDetail(123, 123, 123, pic1, "바나나", "JAN 09", "Yonsei Univ.", "Seoul", pic2, "review", infos, 4, likes, comments)
	
	//for(var i = 0; i < 7; i++) addComment(getId("page"), 123, pic1, "바나나", "20 FEB", "revivieweeviweviewevieweviewvieweviewevieweview");
	
	//for(var i = 0; i < 7; i++) addSimpleFeed(123, pic2, "Las Vegas", "10 FEB", "revivweview");
	
	//clearExcept(2);
}




// Filling Functions

function fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, isThumbnail)
{
	var header = makeClass("div", "header", wrap);
	fillHeader(header, user_id, profile_image_url, name, time, place, region);
	
	var thumbnail = makeClass("div", "thumbnail", wrap);
	fillThumbnail(thumbnail, picture_url, num_likes, num_comments, isThumbnail);
	
	var reviewText = makeClass("div", "review", wrap);
	reviewText.innerText = review;
	
	thumbnail.onclick = function() { call("imtraveling:feed_detail:" + feed_id + ":" + (wrap.offsetTop - window.pageYOffset)); };
}

function fillFeedContents(wrap, info, trip_id, num_all_feeds, num_likes)
{
	var infoList = makeClass("ul", "infoList", wrap);
	fillInfoList(infoList, info);
	
	var button = makeClass("div", "singleButton", wrap);
	button.innerText = "See all " + num_all_feeds + " feeds";
	
	var likeBar = makeClass("div", "likeBar", wrap);
	fillLikeBar(likeBar, num_likes);
	
	createGap(emToPixel(0.3), wrap);
	
	button.onclick = function() {};
}

function fillHeader(header, user_id, _profileImageSrc, _userName, _time, _place, _region)
{
	var cover = makeClass("div", "cover profileImage", header);
	var profileImage = makeClass("img", "profileImage", header);
	
	var upperWrap = makeClass("div", "upperWrap", header);
	var lowerWrap = makeClass("div", "lowerWrap", header);
	
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
	
	header.style.height = intToPixel(60);
	upperWrap.style.width = intToPixel(header.clientWidth - 60 - 8);
	lowerWrap.style.width = intToPixel(header.clientWidth - 60 - 8);
}

function fillThumbnail(thumbnail, pictureUrl, _likes, _comments, isThumbnail)
{
	var cover = makeClass("div", "cover picture", thumbnail);
	var picture = makeClass("img", "picture", thumbnail);
	
	if(!isThumbnail)
	{
		var feedback = makeClass("div", "feedback", thumbnail);
	
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
	}
	
	picture.src = pictureUrl;
	picture.onload = function(){
		var value = intToPixel(picture.clientHeight);
		cover.style.height = value;
		thumbnail.style.height = value;
	};
}

function fillInfoList(infoList, info)
{
	var n = info.length;
	for(var i = 0; i < n; i++)
	{
		var component = makeClass("div", "infoListComponent", infoList);
		var leftWrap = makeClass("div", "leftWrap", component);
		var rightWrap = makeClass("div", "rightWrap", component);
		
		leftWrap.innerText = info[i].key;
		rightWrap.innerText = info[i].unit + " " + info[i].value;
	}
}

function fillLikeBar(likeBar, num_likes)
{
	likeBar.innerText = num_likes + " people likes this feed.";
}

function fillCommentList(commentList, comments)
{
	var n = comments.length;
	for(var i = 0; i < n; i++)
		addComment(commentList, comments[i].user_id, comments[i].profile_image_src, comments[i].name, comments[i].time, comments[i].content);
}

function addComment(commentList, user_id, profile_image_url, name, time, content)
{
	var comment = makeClass("li", "title comment", commentList);
	fillTitle(comment, user_id, profile_image_url, name, time, content, "");
}




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = makeClass("div", "wrap", getId("page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
}

function addFeedDetail(trip_id, feed_id, info, num_all_feeds, num_likes)
{
	fillFeedContents(clearExcept(feed_id), info, trip_id, num_all_feeds, num_likes);
	call("imtraveling:detail_finished");
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, info, num_all_feeds, num_likes)
{
	var wrap = makeClass("div", "wrap", getId("page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, 0, 0, false);
	fillFeedContents(wrap, info, trip_id, num_all_feeds, num_likes);
	call("imtraveling:detail_finished");
}




// Basic Functions

function makeClass(type, className, parent) {
	component = document.createElement(type);
	component.className = className;
	parent.appendChild(component);
	return component;
}
function makeId(type, id, parent) {
	component = document.createElement(type);
	component.id = id;
	parent.appendChild(component);
	return component;
}

function createGap(height, parent) {
	gap = document.createElement("div");
	gap.className = "gap";
	gap.style.height = intToPixel(height);
	parent.appendChild(gap);
	return gap;
}
function clear() {
	var page = getId("page");
	if(page) document.body.removeChild(page);
	makeId("div", "page", document.body);
}

function pixelToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToPixel(value) { return value.toString() + "px"; }
function emToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToEm(value) { return value.toString() + "em"; }
function pixelToEm(value) { return value/16; }
function emToPixel(value) { return value*16; }

function getId(_id) { return document.getElementById(_id); }
function getName(_name) { return document.getElementsByName(_name); }
function getClass(_name) { return document.getElementsByClassName(_name); }

/* 전수열꺼 */
function getHeight() { return H(); }
function getWidth() { return W(); }
function H() { return document.body.clientHeight; }
function W() { return document.body.clientWidth; }
function call(value) { document.location = value; }