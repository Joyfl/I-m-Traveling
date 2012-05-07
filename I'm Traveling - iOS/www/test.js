// Variables

pic1 = "resource/face.jpg";
pic2 = "resource/thumbnail.jpg";
server = "http://imtraveling.joyfl.kr";
comments = new Array({"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevaaaaaaaaaieweviweeviweviewevieweviewdf"}, {"user_id":"123", "profile_image_src":pic1, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUeeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKewdf"});
//infos = new Array({"item":"햄버거", "value":"1.0", "unit":"$"}, {"item":"햄버거", "value":"1.0", "unit":"$"}, {"item":"햄버거", "value":"1.0", "unit":"$"});
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
cl = new Array();


// Initialize 

function init()
{
	RATIO = getEmSize();
	scrollerWidth = pixelToEm(getScrollerWidth());
	
	clear();
	
	//var temp = _("ul", "shadowTest", $("#page"));
	//var temp2 = _("li", "shadowText", temp);
	
	t_fl();
	//t_fd();
	//t_cl();
	//t_sf();
	//t_st();
	//t_pl();
	//t_p();
	//t_pll();
	//t_usf();
	//t_msf();
}




// Test Functions

function t_fl() { for(var i = 0; i < 2; i++) addFeed(i, i, pic1, "Nana", "09 JAN", "a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a ", "KOR", pic2, reviewShort, 113, 113); }
function t_fd() {createFeedDetail(123, 123, 123, pic1, "바나나", "JAN 09", "Yonsei Univ.", "Seoul", pic2, "review", "[{\"item\":\"햄버거\", \"value\":\"1.0\", \"unit\":\"$\"}]", "See all 4 feeds", "4 people likes this feed"); }
function t_cl()
{
	for(var i = 0; i < comments.length; i++)
	{
		addComment(comments[i].user_id, comments[i].profile_image_src, comments[i].name, comments[i].time, comments[i].content);
	}
}
function t_sf() { for(var i = 0; i < 6; i++) addSimpleFeed(i, pic2, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용" + reviewLong); }
function t_st() { for(var i = 0; i < 6; i++) addSimpleTrip(123, pic2, "Title", "29 FEB", "01 MAR", "기차 여행" + reviewLong, 7); }
function t_pl() { for(var i = 0; i < 6; i++) addPerson(123, pic1, "바나나", "KOR", false); }
function t_p() { createProfile(123, pic1, "Jamie J Seol", "South Korea", 7, "Trips", 72, "Following", 68, "Followers", 99, true); }
function t_pll() { for(var i = 0; i < 6; i++) addPlace(i, "뿔레 치킨 맛있긔 ㅋㅅㅋ", "음식점"); }
function t_usf() { for(var i = 0; i < 6; i++) addUnloadedSimpleFeed(i); }
function t_msf() { for(var i = 0; i < 6; i++) modifySimpleFeed(i, pic2, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용"); }




// Modules

function fillHeader(header, user_id, _profileImageSrc, _userName, _time, _place, _region)
{
	var cover = _("div", ".cover profileImage", header);
	var profileImage = _("img", ".profileImage", header);
	
	var upperWrap = _("div", ".upperWrap", header);
	var lowerWrap = _("div", ".lowerWrap", header);
	
	var userName = _("div", ".userName", upperWrap);
	var time = _("div", ".time", upperWrap);
	var place = _("div", ".place", lowerWrap);
	var region = _("div", ".region", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	
	time.innerText = _time;
	place.innerText = _place;
	region.innerText = _region;
	
	var profile = function(){ call("create_profile:" + user_id + ":" + _userName); };
	profileImage.onclick = profile;
	userName.onclick = profile;
	
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - scrollerWidth);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - scrollerWidth);
}

function fillThumbnail(thumbnail, pictureUrl, _likes, _comments, isThumbnail)
{
	var cover = _("div", ".cover picture", thumbnail);
	var picture = _("img", ".picture", thumbnail);
	
	if(isThumbnail)
	{
		var feedback = _("div", ".feedback", thumbnail);
	
		var commentWrap = _("div", ".iconWrap", feedback);
		var likeWrap = _("div", ".iconWrap", feedback);
	
		var likeIcon = _("img", ".icon", likeWrap);
		var commentIcon = _("img", ".icon", commentWrap);
	
		var likeText = _("div", ".iconText green", likeWrap);
		var commentText = _("div", ".iconText blue", commentWrap);
		
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
		var component = _("div", ".infoListComponent", infoList);
		var leftWrap = _("div", ".leftWrap", component);
		var rightWrap = _("div", ".rightWrap", component);
		
		leftWrap.innerHTML = "<img src=\"./resource/coin.png\" class=\"coin\" /> " + info[i].item;
		if(info[i].unit == '\\')
			rightWrap.innerHTML = "<span class=\"moneyUnit\">" + info[i].unit + "</span> " + info[i].value;
		else
			rightWrap.innerHTML = info[i].value + " <span class=\"moneyUnit\">" + info[i].unit + "</span>";
	}
}

function fillLikeBar(likeBar, trip_id, likes_text)
{
	_("img", ".smallIcon", likeBar).src = iconLike;
	_("div", ".pseudo-1", likeBar).innerHTML = likes_text;
	//_("div", ".pseudo-1", likeBar).innerHTML = "<span class=\"likeBarNumber\">" + num_likes + "</span> people likes this feed.";
	likeBar.onclick = function() { call("people_list:" + "trip:" + trip_id); };
}

function createArrow()
{
	var page = $("#page");
	var marger = document.createElement("div");
	marger.id = "marger";
	document.body.insertBefore(marger, page);
	var topArrow = _("img", "#topArrow", marger);
	topArrow.src = "resource/topArrow.png";
	topArrow.onload = function() { topArrow.style.marginLeft = intToPixel(W()/2 - topArrow.clientWidth/2); };
	var shadower = document.createElement("div");
	shadower.id = "shadower";
	document.body.insertBefore(shadower, page);
}

function fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review)
{
	var cover = _("div", ".cover profileImage", wrap);
	var thumbnail = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var place = _("div", ".place darkblue", upperWrap);
	var time = _("div", ".time", upperWrap);
	var review = _("div", ".review", lowerWrap);
	var zfbe = _("div", ".zfbe", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = _time;
	time.disabled = true;
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
	var cover = _("div", ".cover profileImage", wrap);
	var thumbnail = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var time = _("div", ".time", upperWrap);
	var numText = _("div", ".numText", upperWrap);
	var title = _("div", ".title", upperWrap);
	var summary = _("div", ".summary", lowerWrap);
	var zfbe = _("div", ".zfbe", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = start_date + " ~ " + end_date;
	time.disabled = true;
	if(num_feeds > 1) numText.innerText = num_feeds + " feeds";
	else numText.innerText = num_feeds + " feed";
	title.innerText = _title;
	summary.innerText = _summary;
	
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 12);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 12);
	
	wrap.onclick = function() { call("select_trip:" + trip_id); };
}

function fillPerson(wrap, user_id, _profileImageSrc, _userName, _nation, isFollowing)
{
	var cover = _("div", ".cover profileImage", wrap);
	var profileImage = _("img", ".profileImage", wrap);
	
	var textWrap = _("div", ".peopleText", wrap);
	var userName = _("div", ".userName", textWrap);
	var nation = _("div", ".nation", textWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	nation.innerText = _nation;
	
	wrap.onclick = function() { call("create_profile:" + user_id + ":" + _userName); };
}

function fillPlaceList(wrap, place_id, name, category)
{
	wrap.onclick = function() { call("select_place:" + place_id); };
	_("div", ".name", wrap).innerText = name;
	_("div", ".category", wrap).innerText = category;
	_("div", ".zfbe", wrap);
}

function fillProfile(wrap, user_id, profile_image_url, name, nation, trips_num, trips_text, following_num, following_text, followers_num, followers_text, notice, is_on_trip)
{
	$("#page").style.marginTop = "6em";
	$("#page").style.marginBottom = "6em";
	
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
	
	$(".profileImage")[1].src = profile_image_url;
	var onTrip;
	if(is_on_trip) onTrip = "resource/traveling.png";
	$(".onTrip")[0].src = onTrip;
	
	var badgeWrap = $(".badgeWrap")[0];
	var userName = $(".userName")[0];
	var nationWrap = $(".nationWrap")[0];
	
	//for(var i = 0; i < min(badges.length, 4); i++)
	//	_("img", ".badge", badgeWrap).src = rep_badges[i];
	
	var wSize = intToPixel(getWidth() - emToPixel(11));
	setWidth(badgeWrap, wSize);
	setWidth(userName, wSize);
	setWidth(nationWrap, wSize);
	userName.innerText = name;
	nationWrap.childNodes[3].innerText = nation;
	
	if(notice > 0)
	{
		$(".noticeImage")[0].src = "resource/bulb.png";
		$(".noticeText")[0].innerHTML = "<div class=\"green\">" + notice + "</div>";
	}
	
	var numbers = $(".number");
	numbers[0].innerText = trips_num;
	numbers[1].innerText = following_num;
	numbers[2].innerText = followers_num;
	
	var texts = $(".text");
	texts[0].innerText = trips_text;
	texts[1].innerText = following_text;
	texts[2].innerText = followers_text;
	
	var bottomWrap = $(".bottomWrap")[0];
	_("div", ".border", bottomWrap);
	
	var infoBoxes = $(".infoBox");
	infoBoxes[0].onclick = function() { call("profile_trips"); };
	infoBoxes[1].onclick = function() { call("profile_following"); };
	infoBoxes[2].onclick = function() { call("profile_followers"); };
	
	/*
	var seeAllFeed = _("div", ".seeAllFeed seeAll", bottomWrap);
	seeAllFeed.onclick = function() { call("all_feed:" + user_id); };
	_("div", ".border", bottomWrap);
	var seeAllTrip = _("div", ".seeAllTrip seeAll", bottomWrap);
	seeAllTrip.onclick = function() { call("all_trip:" + user_id); };

	_("div", ".darkblue", seeAllFeed).innerHTML = see_all_feed_text + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
	_("div", ".darkgreen", seeAllTrip).innerHTML = see_all_trip_text + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
	
	//_("div", ".darkblue", seeAllFeed).innerHTML = "See all <span class=\"blue\">" + num_feeds + "</span> feeds" + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
	//_("div", ".darkgreen", seeAllTrip).innerHTML = "See all <span class=\"green\">" + num_trips + "</span> trips" + "<img src=\"resource/arrow.png\" class=\"arrow\" />";
	*/
}




// Back-End Functions

function fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, _review, num_likes, num_comments, isThumbnail)
{
	var header = _("div", ".header", wrap);
	fillHeader(header, user_id, profile_image_url, name, time, place, region);
	
	var thumbnail = _("div", ".thumbnail component", wrap);
	fillThumbnail(thumbnail, picture_url, num_likes, num_comments, isThumbnail);
	
	var review = _("div", ".review component", wrap);
	review.innerText = _review;
	
	createGap(wrap, 0.1);
	
	thumbnail.onclick = function() { call("feed_detail:" + feed_id + ":" + (wrap.offsetTop - window.pageYOffset) + ":" + wrap.clientHeight); };
}

function fillFeedContents(wrap, info, trip_id, see_all_feed_text, likes_text)
{
	var infoList = _("ul", ".infoList", wrap);
	fillInfoList(infoList, info);
	
	_("div", ".border", wrap);
	
	var button = _("div", ".seeAll", wrap);
	button.innerText = see_all_feed_text;
	
	var likeBar = _("div", ".likeBar", wrap);
	fillLikeBar(likeBar, trip_id, likes_text);
	
	_("div", ".border", wrap);
	
	button.onclick = function() { call("all_feed:" + trip_id); };
}

function fillComment(wrap, user_id, profile_image_url, name, _time, _content)
{	
	var cover = _("div", ".cover profileImage", wrap);
	var profileImage = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var userName = _("div", ".userName", upperWrap);
	var time = _("div", ".time", upperWrap);
	var content = _("div", ".review", lowerWrap);
	var zfbe = _("div", ".zfbe", wrap);
		
	profileImage.src = profile_image_url;
	userName.innerText = name;
	time.innerText = _time;
	content.innerText= _content;
	
	setHeight(cover, intToEm(pixelToEm(profileImage.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(0.8)));
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 6);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 6);
	
	var profile = function(){ call("create_profile:" + user_id + ":" + name); };
	profileImage.onclick = profile;
	userName.onclick = profile;
}




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = _("div", ".wrap", $("#page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
}

function addFeedTop(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = document.createElement("div");
	var page = $("#page");
	page.insertBefore(wrap, page.firstChild);
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
}

function addSimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	sf.push(1);
	var wrap = _("div", coloring(sf.length, ".simpleFeed"), $("#page"));
	wrap.id = "simple_feed_" + feed_id;
	fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review);
}

function addUnloadedSimpleFeed(feed_id)
{
	addSimpleFeed(feed_id, " ", " ", " ", "loading...");
}

function modifySimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	var wrap = $("#simple_feed_" + feed_id);
	wrap.innerHTML = "";
	fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review);
}

function addSimpleTrip(trip_id, picture_url, title, start_date, end_date, summary, num_feeds)
{
	st.push(1);
	var wrap = _("div", coloring(st.length, ".simpleTrip"), $("#page"));
	fillSimpleTrip(wrap, trip_id, picture_url, title, start_date, end_date, summary, num_feeds);
}

function addPerson(user_id, profile_image_url, name, nation, isFollowing)
{
	var wrap = _("div", ".header", $("#page"));
	fillPerson(wrap, user_id, profile_image_url, name, nation, isFollowing);
}

function addPlace(place_id, name, category)
{
	pl.push(1);
	var wrap = _("div", coloring(pl.length, ".placeList"), $("#page"));
	fillPlaceList(wrap, place_id, name, category);
}

function addComment(user_id, profile_image_url, name, _time, _content)
{
	cl.push(1);
	if(!$("#commentList"))
		_("div", "#commentList", $("#page"));
	var wrap = _("div", coloring(cl.length, ".commentWrap"), $("#commentList"));
	fillComment(wrap, user_id, profile_image_url, name, _time, _content);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, info, see_all_feed_text, likes_text)
{
	createArrow();
	var wrap = _("div", ".wrap", $("#page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, 0, 0, false);
	fillFeedContents(wrap, JSON.parse(info), trip_id, see_all_feed_text, likes_text);
}

function createProfile(user_id, profile_image_url, name, nation, trips_num, trips_text, following_num, following_text, followers_num, followers_text, notice, is_on_trip)
{
	var wrap = _("div", ".profile", $("#page"));
	fillProfile(wrap, user_id, profile_image_url, name, nation, trips_num, trips_text, following_num, following_text, followers_num, followers_text, notice, is_on_trip);
}




// Basic Functions

function $(input)
{
	var content = input.slice(1, input.length);
	if(input[0] == "#")
		return document.getElementById(content);
	else if(input[0] == ".")
		return document.getElementsByClassName(content);
	else if(input[0] == "*")
		return document.getElementsByName(content);
	else if(input[0] == "<" && input[input.length - 1] == ">")
		return document.getElementsByTagName(content.slice(0, content.length - 1));
}

function _(type, name, parent)
{
	element = document.createElement(type);
	if(name[0] == "#")	
		element.id = name.slice(1, name.length);
	else if(name[0] == ".")
		element.className = name.slice(1, name.length);
	parent.appendChild(element);
	return element;
}

function coloring(index, name)
{
	if(index % 2 == 0) name += " even";
	else name += " odd";
	return name;
}

function createGap(parent, height) {
	var gap = _("div", ".gap", parent);
	gap.style.height = intToEm(height);
	return gap;
}
function clear() {
	var page = $("#page");
	if(page) document.body.removeChild(page);
	_("div", "#page", document.body);
	
	var temp = $("#marger");
	if(temp) document.body.removeChild(temp);
	temp = $("#shadower");
	if(temp) document.body.removeChild(temp);
	
	sf = new Array();
	st = new Array();
	pl = new Array();
	cl = new Array();
}

function clearCommentList()
{
	if($("#commentList")) $("#page").removeChild($("#commentList"));
}
function clearProfileTabContents()
{
	var page = $("#page");
	var children = page.childNodes;
	for(var i = children.length - 1; i > 0; i--)
		page.removeChild(children[i]);
}

function pixelToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToPixel(value) { return value.toString() + "px"; }
function emToInt(value) { return Number(value.slice(0, value.length - 2)); }
function intToEm(value) { return value.toString() + "em"; }
function pixelToEm(value) { return value/RATIO; }
function emToPixel(value) { return value*RATIO; }

function getEmSize() {
	var temp = _("div", ".pseudo", document.body);
	temp.style.height = "1em";
	var ret = temp.offsetHeight;
	document.body.removeChild(temp);
	return ret;
}
function getEmSizeByEl(el) {
	if (typeof el == "string") el = document.getElementById(el);
	if (el != null)
	{
    	var tempDiv = document.createElement("div");
    	tempDiv.style.height = "1em";
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