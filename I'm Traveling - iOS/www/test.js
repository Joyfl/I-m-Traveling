// Resources

srcLike = "resource/like.png";
srcComment = "resource/comment.png";
srcRightArrow = "resource/right_arrow.png";
srcTopArrow = "resource/top_arrow.png";
srcTraveling = "resource/traveling.png";
srcBulb = "resource/bulb.png";
srcCoin = "resource/coin.png";

dmyProfileImage = "resource/dummy/profile_image.jpg";
dmyThumbnailBlack = "resource/dummy/thumbnail_black.jpg";
dmyThumbnailWhite = "resource/dummy/thumbnail_white.jpg";




// Constants

SERVER = "http://imtraveling.joyfl.kr";
RATIO = 10;
SCROLLER_WIDTH = 1.5;




// Variables

simpleFeedArray = [];
simpleTripArray = [];
placeArray = [];
commentArray = [];
peopleArray = [];




// Dummy Data

dmyComments = [{"user_id":"123", "profile_image_src":dmyProfileImage, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevaaaaaaaaaieweviweeviweviewevieweviewdf"}, {"user_id":"123", "profile_image_src":dmyProfileImage, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUeeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKewdf"}];
dmyLikes = [{"name":"바나나", "user_id":"123"}, {"name":"진서연", "user_id":"321"}];
dmyInfo = [{"item":"햄버거", "value":"1.0", "unit":"$"}, {"item":"햄버거", "value":"1.0", "unit":"$"}, {"item":"햄버거", "value":"1.0", "unit":"$"}];
dmyReviewShort = "QUIEHKDJFHUEHJSDHKFJDHKvieweviweviwf3eevie";
dmyReviewKor = "마ㅏㅏ럼ㄴㅇㄹㅁㄴㅇㄹㄱㄴㅇㄱㅇㄴㄱㅁㅇㄴㅂㄴㅇㅎㅁㄱㅇㄴㅎㅁㄱㅇㄴㅎㄱㅁㅈㅇㄴㅎㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹasdfasdfasdfasdfasdfㄱㅈㅇㄴㅁㅈ";
dmyReviewLong = "ㄱrevSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieS";
dmyReviewLongLong = "revSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieSSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKFJDHKvieweviweeviwevieweviweeviweviewevieweviewviewevieweviewevieivwevie";




// Initialize 

function init()
{
	RATIO = getEmSize();
	SCROLLER_WIDTH = pixelToEm(getScrollerWidth());
	
	clear();
	
	//t_fl();
	//t_fd();
	
	//t_p();
	
	//t_sf();
	//t_usf();
	//t_msf();
	
	//t_st();
	
	//t_pll();
	t_pl();
	
	
	//t_cl();
	
}




// Test Functions

function t_fl() { for(var i = 0; i < 2; i++) addFeed(i, i, dmyProfileImage, "Nana", "09 JAN", "a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a ", "KOR", dmyThumbnailWhite, dmyReviewShort, 113, 113); }
function t_fd() {createFeedDetail(123, 123, 123, dmyProfileImage, "바나나", "JAN 09", "Yonsei Univ.", "Seoul", dmyThumbnailWhite, "review", JSON.stringify(dmyInfo), "See all 4 feeds", "4 people likes this feed"); }
//"[{\"item\":\"햄버거\", \"value\":\"1.0\", \"unit\":\"$\"}]"
function t_cl()
{
	for(var i = 0; i < comments.length; i++)
	{
		addComment(comments[i].user_id, comments[i].profile_image_src, comments[i].name, comments[i].time, comments[i].content);
	}
}
function t_sf() { for(var i = 0; i < 6; i++) addSimpleFeed(i, dmyThumbnailWhite, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용" + dmyReviewLong); }
function t_st() { for(var i = 0; i < 6; i++) addSimpleTrip(123, dmyThumbnailWhite, "Title", "29 FEB", "01 MAR", "기차 여행" + dmyReviewLong, 7); }
function t_pl() { for(var i = 0; i < 6; i++) addPerson(123, dmyProfileImage, "바나나", "KOR", false); }
function t_p() { createProfile(123, pic1, "Jamie J Seol", "South Korea", 7, "Trips", 72, "Following", 68, "Followers", 99, true); }
function t_pll() { for(var i = 0; i < 6; i++) addPlace(i, "뿔레 치킨 맛있긔 ㅋㅅㅋ", "음식점"); }
function t_usf() { for(var i = 0; i < 6; i++) addUnloadedSimpleFeed(i); }
function t_msf() { for(var i = 0; i < 6; i++) modifySimpleFeed(i, dmyThumbnailWhite, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용"); }




// Modules

function fillHeader(header, user_id, _profileImageSrc, _name, _time, _place, _region)
{
	/*
		<header>
			<cover />
			<profileImage />
			<upperWrap>
				<name />
				<time />
			</upperWrap>
			<lowerWrap>
				<place />
				<region />
			</lowerWrap>
		</header>
	*/
	
	var cover = _("div", ".cover .profileImage", header);
	var profileImage = _("img", ".profileImage", header);
	
	var upperWrap = _("div", ".upperWrap", header);
	var lowerWrap = _("div", ".lowerWrap", header);
	
	var name = _("span", ".name", upperWrap);
	var time = _("span", ".time", upperWrap);
	
	var place = _("span", ".place", lowerWrap);
	var region = _("span", ".region", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	name.innerText = _name;
	time.innerText = _time;
	place.innerText = _place;
	region.innerText = _region;
	
	var call_profile = function(){ call(["create_profile", user_id, _name]); };
	profileImage.onclick = call_profile;
	name.onclick = call_profile;
	
	upperWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - SCROLLER_WIDTH);
	lowerWrap.style.width = intToEm(pixelToEm(getWidth()) - 6 - SCROLLER_WIDTH);
}

function fillThumbnail(thumbnail, pictureUrl, _likes, _comments, isThumbnail)
{
	/*
		<thumbnail>
			<cover />
			<picture />
			<feedback>
				<commentWrap>
					<commentIcon />
					<commentText />
				</commentWrap>
				<likeWrap>
					<likeIcon />
					<likeText />
				</likeWrap>
			</feedback>
		</thumbnail>
	*/
	
	var cover = _("div", ".cover .picture", thumbnail);
	var picture = _("img", ".picture", thumbnail);
	
	if(isThumbnail)
	{
		var feedback = _("div", ".feedback", thumbnail);
	
		var commentWrap = _("div", ".iconWrap", feedback);
		var likeWrap = _("div", ".iconWrap", feedback);
	
		var likeIcon = _("img", ".icon", likeWrap);
		var commentIcon = _("img", ".icon", commentWrap);
	
		var likeText = _("span", ".iconText .green", likeWrap);
		var commentText = _("span", ".iconText .blue", commentWrap);
		
		likeIcon.src = srcLike;
		commentIcon.src = srcComment;
		
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
	/*
		<infoList>
			<li>
				<leftWrap />>
				<rightWrap />
			</li>
		</infoList>
	*/
	
	var n = info.length;
	for(var i = 0; i < n; i++)
	{
		var component = _("li", "", infoList);
		var leftWrap = _("div", ".leftWrap", component);
		var rightWrap = _("div", ".rightWrap", component);
		
		_("img", ".coin", leftWrap).src = srcCoin;
		_("span", "", leftWrap).innerText = " " + info[i].item;
		
		// Case for [unit + value] (Consider float: right!)
		_("span", "", rightWrap).innerText = " " + info[i].value;
		_("span", ".moneyUnit", rightWrap).innerText = info[i].unit;
		
		// Case for [value + unit] (Consider float: right!)
		//_("span", ".moneyUnit", rightWrap).innerText = info[i].unit;
		//_("span", "", rightWrap).innerText = " " + info[i].value;
	}
}

function fillLikeBar(likeBar, trip_id, likes_text)
{
	_("img", "#likeIcon", likeBar).src = srcLike;
	_("span", "", likeBar).innerHTML = likes_text;
	likeBar.onclick = function() { call(["people_list", "trip", trip_id]); };
}

function createArrow()
{
	/*
		<topMargin>
			<topArrow />
		</topMargin>
		<topShadow />
		<page />
	*/

	var page = $("#page");
	
	var topShadow = _("div", "#topShadow", document.body, true);
	var topMargin = _("div", "#topMargin", document.body, true);
	
	var topArrow = _("img", "#topArrow", topMargin);
	topArrow.src = srcTopArrow;
	topArrow.onload = function() { topArrow.style.marginLeft = intToPixel(W()/2 - topArrow.clientWidth/2); };
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
	
	wrap.onclick = function() { call(["select_feed", feed_id]); };
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
	
	wrap.onclick = function() { call(["select_trip", trip_id]); };
}

function fillPerson(wrap, user_id, _profileImageSrc, _userName, _nation, isFollowing)
{
	var cover = _("div", ".cover .profileImage", wrap);
	var profileImage = _("img", ".profileImage", wrap);
	
	var userName = _("span", ".userName", wrap);
	var nation = _("span", ".nation", wrap);
	var arrow = _("img", ".arrow", wrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	nation.innerText = _nation;
	arrow.src = srcRightArrow;
	
	wrap.onclick = function() { call(["create_profile", user_id, _userName]); };
}

function fillPlaceList(wrap, place_id, name, category)
{
	wrap.onclick = function() { call(["select_place", place_id]); };
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
	if(is_on_trip)
	{	
		onTrip = srcTraveling;
		$(".onTrip")[0].src = onTrip;
	}
	
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
		$(".noticeImage")[0].src = srcBulb;
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
	infoBoxes[0].onclick = function() { call(["profile_trips"]); };
	infoBoxes[1].onclick = function() { call(["profile_following"]); };
	infoBoxes[2].onclick = function() { call(["profile_followers"]); };
	
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
	/*
		<wrap>
			<header />
			<content>
				<component>
					<thumbnail />
					<gap />
					<review />
				</component>
			</content>
		</wrap>
	*/
	
	var header = _("div", ".header", wrap);
	fillHeader(header, user_id, profile_image_url, name, time, place, region);
	
	var content = _("div", ".content", wrap);
	var component = _("div", ".component", content);
	
	var thumbnail = _("div", ".thumbnail", component);
	fillThumbnail(thumbnail, picture_url, num_likes, num_comments, isThumbnail);
	
	var gap = createGap(component, 0.5);
	
	var review = _("div", ".review", component);
	review.innerText = _review;
	
	thumbnail.onclick = function() { call(["feed_detail", feed_id, (wrap.offsetTop - window.pageYOffset), wrap.clientHeight]); };
}

function fillFeedDetail(wrap, info, trip_id, see_all_feed_text, likes_text)
{
	/*
		<wrap>
			<detail>
				<infoList />
				<border />
				<seeAll />
				<likeBar />
				<border />
			</detail>
		</wrap>
	*/
	
	var detail = _("div", "#detail", wrap);
	
	var infoList = _("ul", "#infoList", detail);
	fillInfoList(infoList, info);
	
	createGap(detail, 1.5);
	createGap(detail, 0.1, false, "#E4C1A3");
	
	var button = _("div", "#seeAll", detail);
	_("span", "", button).innerText = see_all_feed_text;
	_("img", ".arrow", button).src = srcRightArrow;
	
	var likeBar = _("div", "#likeBar", detail);
	fillLikeBar(likeBar, trip_id, likes_text);
	
	// createGap(detail, 0.1, false, "#F7EAE4");
	// see all comment
	// comment list
	
	button.onclick = function() { call(["all_feed", trip_id]); };
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
	
	var profile = function(){ call(["create_profile", user_id, name]); };
	profileImage.onclick = profile;
	userName.onclick = profile;
}




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = _("div", ".feed_list", $("#page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
	createGap(wrap, 0.1, false, "#F7F2ED");
}

function addFeedTop(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments)
{
	var wrap = _("div", ".feed_list", $("#page"), true);
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, num_likes, num_comments, true);
	createGap(wrap, 0.1, false, "#F7F2ED");
}

function addSimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	simpleFeedArray.push(1);
	var wrap = _("div", coloring(simpleFeedArray.length, ".simpleFeed"), $("#page"));
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
	simpleTripArray.push(1);
	var wrap = _("div", coloring(simpleTripArray.length, ".simpleTrip"), $("#page"));
	fillSimpleTrip(wrap, trip_id, picture_url, title, start_date, end_date, summary, num_feeds);
}

function addPerson(user_id, profile_image_url, name, nation, isFollowing)
{
	peopleArray.push(1);
	var wrap = _("div", coloring(peopleArray.length, ".person"), $("#page"));
	fillPerson(wrap, user_id, profile_image_url, name, nation, isFollowing);
}

function addPlace(place_id, name, category)
{
	placeArray.push(1);
	var wrap = _("div", coloring(placeArray.length, ".placeList"), $("#page"));
	fillPlaceList(wrap, place_id, name, category);
}

function addComment(user_id, profile_image_url, name, _time, _content)
{
	commentArray.push(1);
	if(!$("#commentList"))
		_("div", "#commentList", $("#page"));
	var wrap = _("div", coloring(commentArray.length, ".commentWrap"), $("#commentList"));
	fillComment(wrap, user_id, profile_image_url, name, _time, _content);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, info, see_all_feed_text, likes_text)
{
	createArrow();
	var wrap = _("div", ".wrap", $("#page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, review, 0, 0, false);
	fillFeedDetail(wrap, JSON.parse(info), trip_id, see_all_feed_text, likes_text);
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
	else
		return null;
}

function giveAttribute(element, attribute)
{
	var className = "";
	attribute = attribute.split(" ");
	for(var i = 0; i < attribute.length; i++)
	{
		var cutOff = attribute[i].slice(1, attribute[i].length);
		if(attribute[i][0] == "#")	
			element.id = cutOff;
		else if(attribute[i][0] == ".")
			className += cutOff + " ";
	}
	element.className = className;
}

function _(type, attribute, parent, onTop)
{
	element = document.createElement(type);
	giveAttribute(element, attribute);
	if(onTop) parent.insertBefore(element, parent.firstChild);
	else parent.appendChild(element);
	return element;
}

function coloring(index, name)
{
	if(index % 2 == 0) name += " .even";
	else name += " .odd";
	return name;
}

function createGap(parent, height, clear, color) {
	var gap = _("div", ".gap", parent);
	gap.style.height = intToEm(height);
	if(clear) gap.style.clear = "both";
	if(color) gap.style.backgroundColor = color;
	return gap;
}
function clear() {
	var page = $("#page");
	if(page) document.body.removeChild(page);
	_("div", "#page", document.body);
	
	if($("#topMargin")) document.body.removeChild($("#topMargin"));
	if($("#topShadow")) document.body.removeChild($("#topShadow"));
	
	simpleFeedArray = [];
	simpleTripArray = [];
	placeArray = [];
	commentArray = [];
	peopleArray = [];
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
function call(argument)
{
	var ret = "imtraveling";
	for(var i = 0; i < argument.length; i++) ret += ":" + argument[i];
	document.location = ret;
	temp = ret;
}