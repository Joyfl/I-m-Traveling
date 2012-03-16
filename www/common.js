// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevaaaaaaaaaieweviweeviweviewevieweviewdf"}, {"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUeeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKewdf"});
infos = new Array({"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"}, {"key":"햄버거", "value":"1.0", "unit":"$"});
likes = new Array({"name":"바나나", "user_id":"123"}, {"name":"진서연", "user_id":"321"});
iconLike = "resource/like.png";
iconComment = "resource/comment.png";
RATIO = 10;
scrollerWidth = 1.5;
reviewShort = "QUIEHKDJFHUEHJSDHKFJDHKvieweviweviwf3eevie";
reviewKor = "마ㅏㅏ럼ㄴㅇㄹㅁㄴㅇㄹㄱㄴㅇㄱㅇㄴㄱㅁㅇㄴㅂㄴㅇㅎㅁㄱㅇㄴㅎㅁㄱㅇㄴㅎㄱㅁㅈㅇㄴㅎㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹasdfasdfasdfasdfasdfㄱㅈㅇㄴㅁㅈ";
reviewLong = "ㄱrevSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieS";
reviewLongLong = "revSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieivwevie";
sf = new Array();
st = new Array();
pl = new Array();


// Initialize 

function init()
{
	RATIO = getEmSize();
	scrollerWidth = pixelToEm(getScrollerWidth());
	
	//clear();
	
	//var temp = makeClass("ul", "shadowTest", getId("page"));
	//var temp2 = makeClass("li", "shadowText", temp);
	
	//t_fl();
	//t_fd();
	//t_cl();
	//t_sf();
	//t_st();
	//t_pl();
	//t_p();
	//t_pll();
}




// Test Functions

function t_fl() { for(var i = 0; i < 2; i++) addFeed(i, i, pic1, "Nana", "09 JAN", "Las Vegas", "KOR", pic2, reviewShort, 113, 113); }
function t_fd() {createFeedDetail(123, 123, 123, pic1, "바나나", "JAN 09", "Yonsei Univ.", "Seoul", pic2, "review", infos, 4, 4); }
function t_cl() { cl = makeClass("div", "asdf", getId("page")); fillCommentList(cl, comments); }
function t_sf() { for(var i = 0; i < 6; i++) addSimpleFeed(123, pic2, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용"); }
function t_st() { for(var i = 0; i < 6; i++) addSimpleTrip(123, pic2, "Title", "29 FEB", "01 MAR", "기차 여행", 7); }
function t_pl() { for(var i = 0; i < 6; i++) addPeople(123, pic1, "바나나", "KOR", false); }
function t_p() { createProfile(123, pic1, "Jamie J Seol", "South Korea", 68, 72, 7, new Array(pic1, pic1, pic1, pic1), 99, 233, 233, true); }
function t_pll() { for(var i = 0; i < 6; i++) addPlace(i, reviewLong, "음식점"); }




// Modules

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
	
	var profile = function(){ call("create_profile:" + user_id); };
	profileImage.onclick = profile;
	userName.onclick = profile;
	
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - scrollerWidth);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - scrollerWidth);
}

function fillThumbnail(thumbnail, pictureUrl, _likes, _comments, isThumbnail)
{
	var cover = makeClass("div", "cover picture", thumbnail);
	var picture = makeClass("img", "picture", thumbnail);
	
	if(isThumbnail)
	{
		var feedback = makeClass("div", "feedback", thumbnail);
	
		var commentWrap = makeClass("div", "iconWrap", feedback);
		var likeWrap = makeClass("div", "iconWrap", feedback);
	
		var likeIcon = makeClass("img", "icon", likeWrap);
		var commentIcon = makeClass("img", "icon", commentWrap);
	
		var likeText = makeClass("div", "iconText blue", likeWrap);
		var commentText = makeClass("div", "iconText green", commentWrap);
		
		likeIcon.src = iconLike;
		commentIcon.src = iconComment;
		
		likeText.innerText = _likes;
		commentText.innerText = _comments;
	}
	
	picture.src = pictureUrl;
	setWidth(picture, "100%");
	picture.onload = function(){
		setWidth(cover, intToPixel(picture.clientWidth));
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
		
		leftWrap.innerHTML = "<img src=\"./resource/coin.png\" class=\"coin\" /> " + info[i].key;
		if(info[i].unit == '\\')
			rightWrap.innerHTML = "<span class=\"moneyUnit\">" + info[i].unit + "</span> " + info[i].value;
		else
			rightWrap.innerHTML = info[i].value + " <span class=\"moneyUnit\">" + info[i].unit + "</span>";
	}
}

function fillLikeBar(likeBar, trip_id, num_likes)
{
	makeClass("img", "smallIcon", likeBar).src = iconLike;
	makeClass("div", "pseudo-1", likeBar).innerHTML = "<span class=\"likeBarNumber\">" + num_likes + "</span> people likes this feed."
	likeBar.onclick = function() { call("people_list:" + "trip:" + trip_id); };
}

function addComment(commentList, user_id, profile_image_url, name, _time, _content)
{
	var wrap = makeClass("li", "commentWrap", commentList);
	
	var cover = makeClass("div", "cover profileImage", wrap);
	var profileImage = makeClass("img", "profileImage", wrap);
	
	var upperWrap = makeClass("div", "upperWrap", wrap);
	var lowerWrap = makeClass("div", "lowerWrap", wrap);
	
	var userName = makeClass("div", "userName", upperWrap);
	var time = makeClass("div", "time", upperWrap);
	var content = makeClass("div", "review", lowerWrap);
	var zfbe = makeClass("div", "zfbe", wrap);
		
	profileImage.src = profile_image_url;
	userName.innerText = name;
	time.innerText = _time;
	content.innerText= _content;
	
	setHeight(cover, intToEm(pixelToEm(profileImage.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(0.8)));
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 6);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 6);
	
	var profile = function(){ call("create_profile:" + user_id); };
	profileImage.onclick = profile;
	userName.onclick = profile;
}

function fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review)
{
	var cover = makeClass("div", "cover profileImage", wrap);
	var thumbnail = makeClass("img", "profileImage", wrap);
	
	var upperWrap = makeClass("div", "upperWrap", wrap);
	var lowerWrap = makeClass("div", "lowerWrap", wrap);
	
	var place = makeClass("div", "place darkblue", upperWrap);
	var time = makeClass("div", "time", upperWrap);
	var review = makeClass("div", "review", lowerWrap);
	var zfbe = makeClass("div", "zfbe", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = _time;
	place.innerText = _place;
	review.innerText = _review;
	
	review.style.marginTop = "0.3em";
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 12);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 12);
	
	wrap.onclick = function() { call("select_feed:" + feed_id); };
}

function fillSimpleTrip(wrap, trip_id, picture_url, _title, start_date, end_date, _summary, num_feeds)
{
	var cover = makeClass("div", "cover profileImage", wrap);
	var thumbnail = makeClass("img", "profileImage", wrap);
	
	var upperWrap = makeClass("div", "upperWrap", wrap);
	var lowerWrap = makeClass("div", "lowerWrap", wrap);
	
	var time = makeClass("div", "time", upperWrap);
	var numText = makeClass("div", "numText", upperWrap);
	var title = makeClass("div", "title", upperWrap);
	var summary = makeClass("div", "summary", lowerWrap);
	var zfbe = makeClass("div", "zfbe", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = start_date + " ~ " + end_date;
	if(num_feeds > 1) numText.innerText = num_feeds + " feeds";
	else numText.innerText = num_feeds + " feed";
	title.innerText = _title;
	summary.innerText = _summary;
	
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 12);
	
	wrap.onclick = function() { call("select_trip:" + trip_id); };
}

function fillPeople(wrap, user_id, _profileImageSrc, _userName, _nation, isFollowing)
{
	var cover = makeClass("div", "cover profileImage", wrap);
	var profileImage = makeClass("img", "profileImage", wrap);
	
	var textWrap = makeClass("div", "peopleText", wrap);
	var userName = makeClass("div", "userName", textWrap);
	var nation = makeClass("div", "nation", textWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	nation.innerText = _nation;
	
	wrap.onclick = function() { call("create_profile:" + user_id); };
}

function fillPlaceList(wrap, place_id, name, category)
{
	wrap.onclick = function() { call("select_place:" + place_id); };
	makeClass("div", "name", wrap).innerText = name;
	makeClass("div", "category", wrap).innerText = category;
	makeClass("div", "zfbe", wrap);
}

function fillProfile(wrap, user_id, profile_image_url, name, nation, followers, following, badges, rep_badges, notice, num_feeds, num_trips, is_on_trip)
{
	getId("page").style.marginTop = "6em";
	getId("page").style.marginBottom = "6em";
	
	wrap.innerHTML = "\
		<div class=\"boing softShadow\"></div>\
		<div class=\"topWrapPseudo softShadow\"></div>\
		<div class=\"topWrap profileGradient\"></div>\
		\
		<div class=\"profileInfo\">\
		\
			<div class=\"cover profileImage\"></div>\
			<img class=\"profileImage\" />\
			<div class=\"badgeWrap\"></div>\
			<div class=\"userName\"></div>\
			<div class=\"nationWrap\">\
				<img class=\"onTrip\" />\
				<div class=\"nationText\"></div>\
			</div>\
			<div class=\"noticeWrap\">\
				<img class=\"noticeImage noticeRight\" />\
				<div class=\"noticeText noticeRight\"></div>\
			</div>\
			<div class=\"gap\" style=\"height: 0.5em\"></div>\
			<div class=\"infoBox\">\
				<div class=\"number\"></div>\
				<div class=\"text\"></div>\
			</div>\
			<div class=\"verticalSegment\"></div>\
			<div class=\"infoBox\">\
				<div class=\"number\"></div>\
				<div class=\"text\"></div>\
			</div>\
			<div class=\"verticalSegment\"></div>\
			<div class=\"infoBox\">\
				<div class=\"number\"></div>\
				<div class=\"text\"></div>\
			</div>\
			\
		</div>\
		\
		<div class=\"bottomWrap\"></div>";
	
	getClass("profileImage")[1].src = profile_image_url;
	var onTrip;
	if(is_on_trip) onTrip = "resource/traveling.png";
	getClass("onTrip")[0].src = onTrip;
	
	var badgeWrap = getClass("badgeWrap")[0];
	var userName = getClass("userName")[0];
	var nationWrap = getClass("nationWrap")[0];
	
	for(var i = 0; i < min(badges.length, 4); i++)
		makeClass("img", "badge", badgeWrap).src = rep_badges[i];
	
	var wSize = intToPixel(getWidth() - emToPixel(11));
	setWidth(badgeWrap, wSize);
	setWidth(userName, wSize);
	setWidth(nationWrap, wSize);
	userName.innerText = name;
	nationWrap.childNodes[3].innerText = nation;
	
	if(notice > 0)
	{
		getClass("noticeImage")[0].src = "resource/bulb.png";
		getClass("noticeText")[0].innerHTML = "<div class=\"green\">" + notice + "</div>";
	}
	
	var numbers = getClass("number");
	numbers[0].innerText = followers;
	numbers[1].innerText = following;
	numbers[2].innerText = badges;
	
	var texts = getClass("text");
	texts[0].innerText = "Followers";
	texts[1].innerText = "Following";
	texts[2].innerText = "Badges";
	
	var bottomWrap = getClass("bottomWrap")[0];
	makeClass("div", "border", bottomWrap);
	var seeAllFeed = makeClass("div", "seeAllFeed seeAll", bottomWrap);
	makeClass("div", "border", bottomWrap);
	var seeAllTrip = makeClass("div", "seeAllTrip seeAll", bottomWrap);
	
	makeClass("div", "darkblue", seeAllFeed).innerHTML = "See all <span class=\"blue\">" + num_feeds + "</span> feeds" + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
	makeClass("div", "darkgreen", seeAllTrip).innerHTML = "See all <span class=\"green\">" + num_trips + "</span> trips" + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
}




// Back-End Functions

function fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, _review, num_likes, num_comments, isThumbnail)
{
	var header = makeClass("div", "header", wrap);
	fillHeader(header, user_id, profile_image_url, name, time, place, region);
	
	var thumbnail = makeClass("div", "thumbnail component", wrap);
	fillThumbnail(thumbnail, picture_url, num_likes, num_comments, isThumbnail);
	
	var review = makeClass("div", "review component", wrap);
	review.innerText = _review;
	
	createGap(wrap, 0.1);
	
	thumbnail.onclick = function() { call("feed_detail:" + feed_id + ":" + (wrap.offsetTop - window.pageYOffset)); };
}

function fillFeedContents(wrap, info, trip_id, num_all_feeds, num_likes)
{
	var infoList = makeClass("ul", "infoList", wrap);
	fillInfoList(infoList, info);
	
	makeClass("div", "border", wrap);
	
	var button = makeClass("div", "seeAll", wrap);
	button.innerText = "See all " + num_all_feeds + " feeds";
	
	var likeBar = makeClass("div", "likeBar", wrap);
	fillLikeBar(likeBar, trip_id, num_likes);
	
	makeClass("div", "border", wrap);
	
	createGap(wrap, 0.1);
	
	button.onclick = function() { call("all_feed:" + trip_id); };
}

function fillCommentList(commentList, comments)
{
	var n = comments.length;
	for(var i = 0; i < n; i++)
		addComment(commentList, comments[i].user_id, comments[i].profile_image_src, comments[i].name, comments[i].time, comments[i].content);
}




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = makeClass("div", "wrap", getId("page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
}

function addFeedTop(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = document.createElement("div");
	var page = getId("page");
	page.insertBefore(wrap, page.firstChild);
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
}

function addSimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	sf.push(1);
	var wrap, cName;
	if(sf.length % 2 == 0) cName = "simpleFeed even";
	else cName = "simpleFeed odd";
	wrap = makeClass("div", cName, getId("page"));
	fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review);
}

function addSimpleTrip(trip_id, picture_url, title, start_date, end_date, summary, num_feeds)
{
	st.push(1);
	var wrap, cName;
	if(st.length % 2 == 0) cName = "simpleTrip even";
	else cName = "simpleTrip odd";
	wrap = makeClass("div", cName, getId("page"));
	fillSimpleTrip(wrap, trip_id, picture_url, title, start_date, end_date, summary, num_feeds);
}

function addPeople(user_id, profile_image_url, name, nation, isFollowing)
{
	var wrap = makeClass("div", "header", getId("page"));
	fillPeople(wrap, user_id, profile_image_url, name, nation, isFollowing);
}

function addPlace(place_id, name, category)
{
	pl.push(1);
	var wrap, cName;
	if(pl.length % 2 == 0) cName = "placeList even";
	else cName = "placeList odd";
	wrap = makeClass("div", cName, getId("page"));
	fillPlaceList(wrap, place_id, name, category);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, info, num_all_feeds, num_likes)
{
	var wrap = makeClass("div", "wrap", getId("page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, 0, 0, false);
	fillFeedContents(wrap, info, trip_id, num_all_feeds, num_likes);
}

function createProfile(user_id, profile_image_url, name, nation, followers, following, badges, rep_badges, notice, num_feeds, num_trips, is_on_trip)
{
	var wrap = makeClass("div", "profile", getId("page"));
	fillProfile(wrap, user_id, profile_image_url, name, nation, followers, following, badges, rep_badges, notice, num_feeds, num_trips, is_on_trip);
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

function createGap(parent, height) {
	gap = document.createElement("div");
	gap.className = "gap";
	gap.style.height = intToEm(height);
	parent.appendChild(gap);
	return gap;
}
function clear() {
	var page = getId("page");
	if(page) document.body.removeChild(page);
	makeId("div", "page", document.body);
	sf = new Array();
	st = new Array();
	pl = new Array();
}

function pixelToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToPixel(value) { return value.toString() + "px"; }
function emToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToEm(value) { return value.toString() + "em"; }
function pixelToEm(value) { return value/RATIO; }
function emToPixel(value) { return value*RATIO; }

function getId(id) { return document.getElementById(id); }
function getClass(name) { return document.getElementsByClassName(name); }

function getEmSize() {
	var temp = makeClass("div", "pseudo", document.body);
	temp.style.height = "1em";
	var ret = temp.offsetHeight;
	document.body.removeChild(temp);
	return ret;
}
function getEmSizeByEl(el) {
	if (typeof el == "string") el = document.getElementById(el);
	if (el != null)
	{
    	var tempDiv = document.createElement('div');
    	tempDiv.style.height = '1em';
    	el.appendChild(tempDiv);
    	var emSize = tempDiv.offsetHeight;
    	el.removeChild(tempDiv);
    	return emSize;
	}
}
function getScrollerWidth() {
	var scr = document.createElement('div');
	var inn = document.createElement('div');
	var wNoScroll = 0;
	var wScroll = 0;
	scr.style.position = 'absolute';
	scr.style.top = '-1000px';
	scr.style.left = '-1000px';
	scr.style.width = '100px';
	scr.style.height = '50px';
	scr.style.overflow = 'hidden';
	inn.style.width = '100%';
	inn.style.height = '200px';
	scr.appendChild(inn);
	document.body.appendChild(scr);
	wNoScroll = inn.offsetWidth;
	scr.style.overflow = 'auto';
	wScroll = inn.offsetWidth;
	document.body.removeChild(document.body.lastChild);
	return (wNoScroll - wScroll);
}

function setWidth(c, w) { c.style.width = w; }
function setHeight(c, h) { c.style.height = h; }
function setSize(c, w, h) { setWidth(c, w); setHeight(c, h); } 

function max(a, b) { return (a > b)? a : b; }
function min(a, b) { return (a > b)? b : a; }

/* 전수열꺼 */
function getHeight() { return document.body.clientHeight; }
function getWidth() { return document.body.clientWidth; }
function H() { return window.innerHeight; }
function W() { return window.innerWidth; }
function call(value) { document.location = "imtraveling:" + value; }