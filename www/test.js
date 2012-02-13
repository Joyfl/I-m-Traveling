// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"asdf"});
infos = new Array({"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"});
likes = new Array({"name":"바나나", "user_id":"123"}, {"name":"진서연", "user_id":"321"});
iconLike = "resource/like.png";
iconComment = "resource/comment.png";



// Initialize 

function init()
{
	clear();
	for(var i = 0; i < 3; i++) addFeed(i, i, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, "revivieweeviweviewevieweviewvieweviewevieweview", 113, 113);
	
	addFeedDetail(1, 1, infos, 3, likes, comments);
	
	//createMainPage();
	//createLoginPage();
	
	//createTitle(123, pic1, "바나나", "19 JAN", "Las Vegas", "KOR");
	//modifyTitle("20 JAN", "Los Angelos", "USA");
	
	//createFeedDetail(1, 1, pic2, "revivieweeviweviewevieweviewvieweviewevieweview", new Object(), new Array(), new Array());
	//test();
	//for(var i = 0; i < 7; i++) addComment(getId("page"), 123, pic1, "바나나", "20 FEB", "revivieweeviweviewevieweviewvieweviewevieweview");
	
	//for(var i = 0; i < 7; i++) addSimpleFeed(123, pic2, "Las Vegas", "10 FEB", "revivweview");
	
	//clearExcept(2);
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

function fillThumbnail(thumbnail, pictureUrl, _likes, _comments)
{
	var cover = makeClass("div", "cover picture", thumbnail);
	var picture = makeClass("img", "picture", thumbnail);
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
	
	picture.src = pictureUrl;
	picture.onload = function() { cover.style.height = intToPixel(picture.clientHeight); }
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

function fillLikeBar(likeBar, likes)
{
	likeBar.innerText = likes.length + " people likes this feed.";
}

function fillCommentList(commentList, comments)
{
	
}





// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = makeId("div", "wrap_" + feed_id, getId("page"));
	
	var title = makeClass("div", "title", wrap);
	fillTitle(title, user_id, profile_image_url, name, time, place, region);
	
	createGap(14, wrap);
	
	var thumbnail = makeClass("div", "thumbnail", wrap);
	fillThumbnail(thumbnail, picture_url, num_likes, num_comments);
	
	var reviewText = makeClass("div", "review", wrap);
	reviewText.innerText = review;
	
	createGap(10, wrap);
	
	thumbnail.onclick = function() { document.location = "imtraveling:feed_detail:" + feed_id + ":" + (wrap.offsetTop - window.pageYOffset); };
}

function addFeedDetail(trip_id, feed_id, info, num_all_feeds, likes, comments)
{
	var wrap = clearExcept(feed_id);
	
	var infoList = makeClass("ul", "infoList", wrap);
	fillInfoList(infoList, info);
	
	var button = makeClass("div", "singleButton", wrap);
	button.innerText = "See all " + num_all_feeds + " feeds";
	
	var likeBar = makeClass("div", "likeBar", wrap);
	fillLikeBar(likeBar, likes);
	
	var commentList = makeClass("div", "commentList", wrap);
	fillCommentList(commentList, comments);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, info, likes, comments)
{
	
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

function clearExcept(feed_id)
{
	var target = "wrap_" + feed_id;
	var page = getId("page");
	var wraps = page.childNodes;
	var ret;
	for(var i = 0; i < wraps.length;)
		if(wraps[i].id != target) page.removeChild(wraps[i]);
		else ret = wraps[i++];
	return ret;
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