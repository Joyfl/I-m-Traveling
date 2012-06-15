// Constants

SERVER = "http://imtraveling.joyfl.kr";
RATIO = 10;
SCROLLER_WIDTH = 1.5;
BODY_WIDTH = 0;
BODY_HEIGHT = 0;




// Dummy Data

dmyProfileImage = "resource/dummy/profile_image.jpg";
dmyThumbnailBlack = "resource/dummy/thumbnail_black.jpg";
dmyThumbnailWhite = "resource/dummy/thumbnail_white.jpg";

dmyComments = [{"user_id":"123", "profile_image_src":dmyProfileImage, "name":"바나나", "time":"2012.01.18", "content":"댓글댓글"}, {"user_id":"123", "profile_image_src":dmyProfileImage, "name":"바나나", "time":"2012.01.18", "content":"aseeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUeeviwevieweviweeviweviewevieweviewviewevieweviewevieSKUHFUHUEHKJSDHFKUEKJSHDIUHFQUIEHKDJFHUEHJSDHKewdf"},{"user_id":"123", "profile_image_src":dmyProfileImage, "name":"바나나", "time":"2012.01.18", "content":"댓글댓글"}];
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
	BODY_WIDTH = getWidth();
	BODY_HEIGHT = getHeight();
	SCROLLER_WIDTH = pixelToEm(getScrollerWidth());
	
	clear();
	
	//t_fl();
	t_fd();
	
	//t_p();
	
	//t_sf();
	//t_usf();
	//t_msf();
	//t_uf();
	
	//t_st();
	//t_ust();
	//t_mst();
	
	//t_cl();
	//t_pl();
	//t_pll();
	//t_nl();
	
	console.log("body loaded");
}




// Test Functions

function t_fl() { for(var i = 0; i < 5; i++) addFeed(i, i, dmyProfileImage, "설진석", "09 JAN", "여기가 오디징? 점점점 됩니다. 흐히히", "KOR", dmyThumbnailWhite, 0.5, "그러겡 어딜까 가갸거겨고교구규그기", 113, 113); }
function t_fd() {createFeedDetail(123, 123, 123, dmyProfileImage, "바나나", "JAN 09", "Yonsei Univ.", "Seoul", dmyThumbnailWhite, dmyThumbnailBlack, 0.5, "review", JSON.stringify(dmyInfo), "See all 4 feeds", "4 people likes this feed"); createMoreComment("이전 댓글 보기"); t_cl(); }

function t_p() { createProfile(123, dmyProfileImage, "Jamie J Seol", "South Korea", 7, "Trips", 72, "Following", 68, "Followers", -1, true); }

function t_sf() { for(var i = 0; i < 6; i++) addSimpleFeed(i, dmyThumbnailWhite, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용" + dmyReviewShort); }
function t_usf() { for(var i = 0; i < 6; i++) addUnloadedSimpleFeed(i); }
function t_msf() { for(var i = 0; i < 6; i++) modifySimpleFeed(i, dmyThumbnailWhite, "여행/피드 제목", "날짜", "리뷰/설명 등의 내용"); }
function t_uf() { for(var i = 0; i < 6; i++) addUploadingFeed(i, dmyThumbnailWhite, "여행/피드 제목", "uploading...", "리뷰/설명 등의 내용" + dmyReviewShort); }

function t_st() { for(var i = 0; i < 6; i++) addSimpleTrip(i, dmyThumbnailWhite, "Title", "29 FEB", "01 MAR", "기차 여행 간단한 요약", "7 feeds"); }
function t_ust() { for(var i = 0; i < 6; i++) addUnloadedSimpleTrip(i); }
function t_mst() { for(var i = 0; i < 6; i++) modifySimpleTrip(i, dmyThumbnailWhite, "Title", "29 FEB", "01 MAR", "기차 여행 간단한 요약", "7 feeds"); }

function t_cl() { for(var i = 0; i < dmyComments.length; i++) addComment(dmyComments[i].user_id, dmyComments[i].profile_image_src, dmyComments[i].name, dmyComments[i].time, dmyComments[i].content); }
function t_cl2() { for(var i = 0; i < dmyComments.length; i++) addComment(dmyComments[i].user_id, dmyComments[i].profile_image_src, dmyComments[i].name, dmyComments[i].time, dmyComments[i].content, true); }
function t_pl() { for(var i = 0; i < 5; i++) addPerson(123, dmyProfileImage, "바나나", "KOR", false); }
function t_pll() { for(var i = 0; i < 6; i++) addPlace(i, "뿔레 치킨 맛있긔 ㅋㅅㅋ", "음식점"); }
function t_nl() { for(var i = 0; i < 6; i++) addNotification(i, dmyProfileImage, "<span class=\"bold\">얘</span>가 댓글을 남겼대요", "6분 전"); }




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
	
	var place = _("span", ".place .ellipsis .shadow", lowerWrap);
	var region = _("span", ".region .ellipsis", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	name.innerText = _name;
	time.innerText = _time;
	place.innerText = _place;
	region.innerText = _region;
	
	var call_profile = function(){ call(["create_profile", user_id, _name]); };
	cover.onclick = call_profile;
	profileImage.onclick = call_profile;
	name.onclick = call_profile;
	
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6 - SCROLLER_WIDTH);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6 - SCROLLER_WIDTH);
}

function fillThumbnail(thumbnail, pictureUrl, pictureRatio, _likes, _comments, isThumbnail, pictureHighUrl)
{
	/*
		<thumbnail>
			<preloadBG />
			<preloadIcon />
			<picture />
			<cover />
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
	
	var loaderLow = new Image();
	var loaderHigh = new Image();
	var preloadBG = _("div", ".preloadBG .picture", thumbnail);
	var cover = _("div", ".cover .picture", thumbnail);
	var preloadIcon = _("div", ".preloadIcon", thumbnail);
	var picture = _("img", ".picture", thumbnail);
	
	loaderLow.src = pictureUrl;
	if(pictureHighUrl) loaderHigh.src = pictureHighUrl;
	
	if(isThumbnail)
	{
		var feedback = _("div", ".feedback", thumbnail);
	
		var commentWrap = _("span", ".iconWrap", feedback);
		var commentIcon = _("div", ".icon .iconComment", commentWrap);
		var commentText = _("span", ".iconText .blue", commentWrap);
		commentText.innerText = _comments;
		
		var likeWrap = _("span", ".iconWrap", feedback);
		var likeIcon = _("div", ".icon .iconLike", likeWrap);
		var likeText = _("span", ".iconText .green", likeWrap);
		likeText.innerText = _likes;
	}
	
	var pictureWidthPixel = intToPixel(BODY_WIDTH * 0.9);
	var pictureHeightPixel = intToPixel(BODY_WIDTH * 0.9 * pictureRatio);
	setWidth(cover, pictureWidthPixel);
	setHeight(cover, pictureHeightPixel);
	setWidth(preloadBG, pictureWidthPixel);
	setHeight(preloadBG, pictureHeightPixel);
	setHeight(picture, pictureHeightPixel);
	setHeight(thumbnail, pictureHeightPixel);
	preloadIcon.style.marginTop = intToEm(pixelToEm(BODY_WIDTH * 0.9 * pictureRatio / 2) - 2);
	
	loaderLow.onload = function(){
		preloadIcon.style.display = "none";
		preloadBG.style.display = "none";
		picture.src = loaderLow.src;
		if(pictureHighUrl) loaderHigh.onload = function() { picture.src = loaderHigh.src; };
	};
	
	/*loaderLow.onload = function(){
		setTimeout(function(){
		preloadIcon.style.display = "none";
		preloadBG.style.display = "none";
		picture.src = loaderLow.src;}, 2000);
		//if(pictureHighUrl) loaderHigh.onload = function() { picture.src = loaderHigh.src; };
	};*/
	
	
	
	/*
	
	var preloadIcon = _("div", ".preloadIcon", thumbnail);
	var preloadBG = _("div", ".preloadBG .picture", thumbnail);
	var cover = _("div", ".cover .picture", thumbnail);
	var loaderLow = new Image();
	var loaderHigh = new Image();
	var picture = _("img", ".picture", thumbnail);
	
	picture.src = src["preloadBG"];
	loaderLow.src = pictureUrl;
	if(pictureHighUrl) loaderHigh.src = pictureHighUrl;
	
	if(isThumbnail)
	{
		var feedback = _("div", ".feedback", thumbnail);
	
		var commentWrap = _("span", ".iconWrap", feedback);
		var commentIcon = _("div", ".icon .iconComment", commentWrap);
		var commentText = _("span", ".iconText .blue", commentWrap);
		commentText.innerText = _comments;
		
		var likeWrap = _("span", ".iconWrap", feedback);
		var likeIcon = _("div", ".icon .iconLike", likeWrap);
		var likeText = _("span", ".iconText .green", likeWrap);
		likeText.innerText = _likes;
	}
	
	var pictureWidthPixel = intToPixel(BODY_WIDTH * 0.9);
	var pictureHeightPixel = intToPixel(BODY_WIDTH * 0.9 * pictureRatio);
	setWidth(cover, pictureWidthPixel);
	setHeight(cover, pictureHeightPixel);
	setHeight(picture, pictureHeightPixel);
	setHeight(thumbnail, pictureHeightPixel);
	preloadIcon.style.marginTop = intToEm(pixelToEm(BODY_WIDTH * 0.9 * pictureRatio / 2) - 2);
	
	loaderLow.onload = function(){
		preloadIcon.style.display = "none";
		picture.src = loaderLow.src;
		if(pictureHighUrl) loaderHigh.onload = function() { picture.src = loaderHigh.src; };
	};
	*/
	
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
		
		_("div", ".coin", leftWrap);
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
	/*
		<likeBar>
			<icon />
			<text />
		</likeBar>
	*/
	
	_("div", "#likeIcon .iconLike", likeBar);
	_("span", ".shadow", likeBar).innerHTML = likes_text;
	likeBar.onclick = function() { call(["people_list", "trip", trip_id]); };
}

function createArrow()
{
	/*
		<topMargin>
			<topArrow />
		</topMargin>
		<page />
	*/

	var page = $("#page");
	var topMargin = _("div", "#topMargin", document.body, true);
	var topArrow = _("div", "#topArrow", topMargin);
	topArrow.onload = function() { topArrow.style.marginLeft = intToPixel(W()/2 - topArrow.clientWidth/2); };
}

function fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review)
{
	/*
		<wrap>
			<cover />
			<thumbnail />
			<upperWrap>
				<place />
				<time />
			</upperWrap
			<lowerWrap>
				<review />
			</lowerWrap>
			<expensor />
		</wrap>
	*/
	
	var cover = _("div", ".cover .profileImage", wrap);
	var thumbnail = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var place = _("span", ".place .shadow .ellipsis", upperWrap);
	var time = _("span", ".time", upperWrap);
	var review = _("div", ".review .paragraph .shadow", lowerWrap);
	var expensor = _("div", ".expensor", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = _time;
	place.innerText = _place;
	review.innerText = _review;
	
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	
	wrap.onclick = function() { call(["select_feed", feed_id]); };
}

function fillUploadingFeed(wrap, feed_id, picture_url, _place, _message, _review)
{
	/*
		<wrap>
			<cover />
			<thumbnail />
			<upperWrap>
				<place />
				<message />
			</upperWrap
			<lowerWrap>
				<review />
			</lowerWrap>
			<expensor />
		</wrap>
	*/
	
	var cover = _("div", ".cover .profileImage", wrap);
	var thumbnail = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var place = _("span", ".place .shadow .ellipsis", upperWrap);
	var message = _("span", ".message", upperWrap);
	var review = _("div", ".review .paragraph .shadow", lowerWrap);
	var expensor = _("div", ".expensor", wrap);
		
	thumbnail.src = picture_url;
	message.innerText = _message;
	place.innerText = _place;
	review.innerText = _review;
	
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	
	wrap.onclick = function() { call(["select_feed", feed_id]); };
}

function fillSimpleTrip(wrap, trip_id, picture_url, _title, start_date, end_date, _summary, feeds_text)
{
	
	/*
		<wrap>
			<cover />
			<thumbnail />
			<upperWrap>
				<time />
				<feeds />
				<title />
			</upperWrap>
			<lowerWrap>
				<summary />
			</lowerWrap>
			<expensor />
		</wrap>
	*/
	
	var cover = _("div", ".cover .profileImage", wrap);
	var thumbnail = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var time = _("div", ".time .shadow", upperWrap);
	var feeds = _("div", ".feeds", upperWrap);
	var title = _("div", ".title .shadow", upperWrap);
	var summary = _("div", ".summary .paragraph .shadow", lowerWrap);
	var expensor = _("div", ".expensor", wrap);
		
	thumbnail.src = picture_url;
	time.innerText = start_date + " ~ " + end_date;
	feeds.innerText = feeds_text;
	title.innerText = _title;
	summary.innerText = _summary;
	
	setHeight(cover, intToEm(pixelToEm(thumbnail.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(1.6)));
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 12);
	
	wrap.onclick = function() { call(["select_trip", trip_id]); };
}

function fillPerson(wrap, user_id, _profileImageSrc, _userName, _nation, isFollowing)
{
	/*
		<wrap>
			<cover />
			<profileImage />
			<userName />
			<nation />
			<arrow />
		</wrap>
	*/
	
	var cover = _("div", ".cover .profileImage", wrap);
	var profileImage = _("img", ".profileImage", wrap);
	
	var userName = _("span", ".userName .shadow", wrap);
	var nation = _("span", ".nation", wrap);
	var arrow = _("div", ".arrow", wrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	nation.innerText = _nation;
	
	wrap.onclick = function() { call(["create_profile", user_id, _userName]); };
}

function fillPlaceList(wrap, place_id, name, category)
{
	/*
		<wrap>
			<name />
			<category />
			<expensor />
		</wrap>
	*/
	
	wrap.onclick = function() { call(["select_place", place_id]); };
	_("div", ".name .paragraph", wrap).innerText = name;
	_("div", ".category .paragraph", wrap).innerText = category;
	_("div", ".expensor", wrap);
}

function fillNotification(wrap, notification_id, image_url, _text, _time)
{
	/*
		<wrap>
			<cover />
			<image />
			<upperWrap>
				<text />
			</upperWrap>
			<lowerWrap>
				<time />
			</lowerWrap>
			<expensor />
		</wrap>
	*/
		
	var cover = _("div", ".cover .profileImage", wrap);
	var image = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var text = _("span", ".text .shadow", upperWrap);
	var time = _("span", ".time .shadow", lowerWrap);
	var expensor = _("div", ".expensor", wrap);
		
	image.src = image_url;
	text.innerHTML = _text;
	time.innerText = _time;
	
	setHeight(cover, intToEm(pixelToEm(image.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(0.8)));
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6);
	
	wrap.onclick = function() { call(["notification", notification_id]); };
}

function fillProfile(wrap, user_id, profile_image_url, name, nation, trips_num, trips_text, following_num, following_text, followers_num, followers_text, notice, is_on_trip)
{
	/*
		<wrap>
			<background>
				<gap />
				<pseudoTopWrap />
				<pseudoBottomWrap />
				<profileImageWrapper />
			</background>
			<foreground>
				<topWrap>
					<cover />
					<profileImage />
					<userName />
					<travelingInfo>
						<nation />
					</travelingInfo>
					<noticeWrap>
						<noticeNumber />
					</noticeWrap>
				</topWrap>
				<bottomWrap>
					<infoBox type="trips">
						<number />
						<text />
					</infoBox>
					<verticalSegment />
					<infoBox type="following">
						<number />
						<text />
					</infoBox>
					<verticalSegment />
					<infoBox type="followers">
						<number />
						<text />
					</infoBox>
				</bottomWrap>
			</foreground>
		</wrap>
	*/
	
	//<div class=\"topWrap profileGradient\"></div>\
	
	wrap.innerHTML = "\
		<div id=\"background\">\
			<div class=\"gap\" style=\"height: 5em;\"></div>\
			<div id=\"pseudoTopWrap\" class=\"profileShadow\"></div>\
			<div id=\"pseudoBottomWrap\"></div>\
			<div id=\"profileImageWrapper\" class=\"profileShadow\"></div>\
		</div>\
		<div id=\"foreground\">\
			<div class=\"gap\" style=\"height: 5em;\"></div>\
			<div id=\"topWrap\">\
				<div class=\"cover profileImage\"></div>\
				<img class=\"profileImage\" src=\"" + profile_image_url + "\" />\
				<div id=\"userName\">" + name + "</div>\
				<div id=\"travelingInfo\">\
					<div id=\"nation\">" + nation + "</div>\
				</div>\
				<div id=\"noticeWrap\">\
					<div id=\"noticeText\" ></div>\
				</div>\
			</div>\
			<div id=\"bottomWrap\">\
				<div class=\"infoBox\" onclick=\"call([\'profile_trips\']);\">\
					<div class=\"infoNumber\">" + trips_num + "</div>\
					<div class=\"infoText\">" + trips_text + "</div>\
				</div>\
				<div class=\"verticalSegment\"></div>\
				<div class=\"infoBox\" onclick=\"call([\'profile_following\']);\">\
					<div class=\"infoNumber\">" + following_num + "</div>\
					<div class=\"infoText\">" + following_text + "</div>\
				</div>\
				<div class=\"verticalSegment\"></div>\
				<div class=\"infoBox\" onclick=\"call([\'profile_followers\']);\">\
					<div class=\"infoNumber\">" + followers_num + "</div>\
					<div class=\"infoText\">" + followers_text + "</div>\
				</div>\
				<div class=\"expensor\"></div>\
			</div>\
		</div>\
		";
	
	if(notice >= 0)
	{
		$("#noticeText").innerText = notice;
	}
	
	if(notice < 0)
	{
		$("#noticeWrap").style.display = "none";
	}
	
	var wSize = intToPixel(BODY_WIDTH - emToPixel(11));
	//setWidth(userName, wSize);
	//setWidth(nationWrap, wSize);
}

function setNumNotification(n)
{
	if($("#noticeText")) $("#noticeText").innerText = n;
}




// Back-End Functions

function fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, picture_ratio, _review, num_likes, num_comments, is_thumbnail, isDetail, picture_high_url)
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
	if(isDetail) header.style.borderTop = "0px solid #FFF";
	fillHeader(header, user_id, profile_image_url, name, time, place, region);
	
	var content = _("div", ".content", wrap);
	var component = _("div", ".component", content);
	
	var thumbnail = _("div", ".thumbnail", component);
	fillThumbnail(thumbnail, picture_url, picture_ratio, num_likes, num_comments, is_thumbnail, picture_high_url);
	
	var gap = createGap(component, 0.5);
	
	var review = _("div", ".review .paragraph .shadow", component);
	review.innerText = _review;
	
	thumbnail.onclick = function() { call(["feed_detail", feed_id, (wrap.offsetTop - window.pageYOffset), wrap.clientHeight]); };
}

function fillFeedDetail(wrap, info, trip_id, see_all_feed_text, likes_text)
{
	/*
		<wrap>
			<feed />
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
	
	if(info.length > 0)
	{
		var infoList = _("ul", "#infoList", detail);
		fillInfoList(infoList, info);
		createGap(detail, 1.5);
	}
	
	createGap(detail, 0.1, false, "#E7CEBB");
	
	var button = _("div", "#seeAll", detail);
	_("span", ".shadow", button).innerText = see_all_feed_text;
	_("div", ".arrow", button);
	
	var likeBar = _("div", "#likeBar", detail);
	fillLikeBar(likeBar, trip_id, likes_text);
	
	// createGap(detail, 0.1, false, "#F7EAE4");
	// see all comment
	// comment list
	
	button.onclick = function() { call(["all_feed", trip_id]); };
}

function fillComment(wrap, user_id, profile_image_url, name, _time, _comment)
{
	/*
		<wrap>
			<cover />
			<profileImage />
			<upperWrap>
				<userName />
				<time />
			</upperWrap>
			<lowerWrap>
				<comment />
			</lowerWrap>
			<expensor />
		</wrap>
	*/
		
	var cover = _("div", ".cover .profileImage", wrap);
	var profileImage = _("img", ".profileImage", wrap);
	
	var upperWrap = _("div", ".upperWrap", wrap);
	var lowerWrap = _("div", ".lowerWrap", wrap);
	
	var userName = _("span", ".userName .shadow", upperWrap);
	var time = _("span", ".time .shadow", upperWrap);
	var comment = _("div", ".comment .shadow .paragraph", lowerWrap);
	var expensor = _("div", ".expensor", wrap);
		
	profileImage.src = profile_image_url;
	userName.innerText = name;
	time.innerText = _time;
	comment.innerText= _comment;
	
	setHeight(cover, intToEm(pixelToEm(profileImage.clientHeight)));
	wrap.style.minHeight = intToEm(pixelToEm(cover.clientHeight + emToPixel(0.8)));
	upperWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6);
	lowerWrap.style.width = intToEm(pixelToEm(BODY_WIDTH) - 6);
	
	var profile = function(){ call(["create_profile", user_id, name]); };
	cover.onclick = profile;
	profileImage.onclick = profile;
	userName.onclick = profile;
}




// Front-End Functions

function addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, picture_ratio, review, num_likes, num_comments, is_top)
{
	if(!$("#feedList"))
		_("ul", "#feedList", $("#page"));
	var wrap = _("li", "", $("#feedList"), is_top);
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_url, picture_ratio, review, num_likes, num_comments, true);
}

function addFeedTop(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, picture_ratio, review, num_likes, num_comments)
{
	addFeed(feed_id, user_id, profile_image_url, name, time, place, region, picture_url, picture_ratio, review, num_likes, num_comments, true);
	console.log("function \"addFeedTop\" is deprecated");
}

function addSimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	if(!$("#simpleFeedList"))
		_("ul", "#simpleFeedList", $("#page"));
	var wrap = _("li", "#simpleFeed_" + feed_id, $("#simpleFeedList"));
	fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review);
	listview();
}

function addUnloadedSimpleFeed(feed_id)
{
	addSimpleFeed(feed_id, " ", " ", " ", "loading...");
}

function modifySimpleFeed(feed_id, picture_url, _place, _time, _review)
{
	var wrap = $("#simpleFeed_" + feed_id);
	wrap.innerHTML = "";
	fillSimpleFeed(wrap, feed_id, picture_url, _place, _time, _review);
}

function addUploadingFeed(feed_id, picture_url, _place, _message, _review)
{
	if(!$("#uploadingFeedList"))
		_("ul", "#uploadingFeedList .listview", $("#page"));
	var wrap = _("li", "", $("#uploadingFeedList"));
	fillUploadingFeed(wrap, feed_id, picture_url, _place, _message, _review);
	listview();
}

function addSimpleTrip(trip_id, picture_url, title, start_date, end_date, summary, feeds_text)
{
	if(!$("#simpleTripList"))
		_("ul", "#simpleTripList .listview", $("#page"));
	var wrap = _("li", "#simpleTrip_" + trip_id, $("#simpleTripList"));
	fillSimpleTrip(wrap, trip_id, picture_url, title, start_date, end_date, summary, feeds_text);
	listview();
}

function addUnloadedSimpleTrip(trip_id)
{
	addSimpleTrip(trip_id, " ", " ", " ", " ", "loading...", " ");
}

function modifySimpleTrip(trip_id, picture_url, title, start_date, end_date, summary, feeds_text)
{
	var wrap = $("#simpleTrip_" + trip_id);
	wrap.innerHTML = "";
	fillSimpleTrip(wrap, trip_id, picture_url, title, start_date, end_date, summary, feeds_text);
}

function addPerson(user_id, profile_image_url, name, nation, isFollowing)
{
	if(!$("#peopleList"))
		_("ul", "#peopleList .listview", $("#page"));
	var wrap = _("li", "", $("#peopleList"));
	fillPerson(wrap, user_id, profile_image_url, name, nation, isFollowing);
	listview();
}

function addPlace(place_id, name, category)
{
	if(!$("#placeList"))
		_("ul", "#placeList .listview", $("#page"));
	var wrap = _("li", "", $("#placeList"));
	fillPlaceList(wrap, place_id, name, category);
	listview();
}

function addComment(user_id, profile_image_url, name, _time, _content, is_top)
{
	if(!$("#commentList"))
		_("ul", "#commentList .listview", $("#page"));
	var wrap = _("li", "", $("#commentList"), is_top);
	fillComment(wrap, user_id, profile_image_url, name, _time, _content);
	//listview();
}

function addNotification(notification_id, image_url, text, time)
{
	if(!$("#notificationList"))
		_("ul", "#notificationList .listview", $("#page"));
	var wrap = _("li", "", $("#notificationList"));
	fillNotification(wrap, notification_id, image_url, text, time);
}

function createFeedDetail(trip_id, feed_id, user_id, profile_image_url, name, time, place, region, picture_low_url, picture_high_url, picture_ratio, review, info, see_all_feed_text, likes_text)
{
	createArrow();
	var wrap = _("div", "#feedDetail", $("#page"));
	fillFeed(wrap, feed_id, user_id, profile_image_url, name, time, place, region, picture_low_url, picture_ratio, review, 0, 0, false, true, picture_high_url);
	fillFeedDetail(wrap, JSON.parse(info), trip_id, see_all_feed_text, likes_text);
}

function createProfile(user_id, profile_image_url, name, nation, trips_num, trips_text, following_num, following_text, followers_num, followers_text, notice, is_on_trip)
{
	var wrap = _("div", "#profile", $("#page"));
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
	var element = document.createElement(type);
	giveAttribute(element, attribute);
	if(onTop) parent.insertBefore(element, parent.firstChild);
	else parent.appendChild(element);
	return element;
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
}

function listview()
{
	temp_list = $("<ul>");
	for(var i = 0; i < temp_list.length; i++)
	{
		var count = temp_list[i].childElementCount;
		if(count % 2 == 0) temp_list[i].style.borderBottom = "1px solid #F6EEE8";
		else temp_list[i].style.borderBottom = "1px solid #E5CAB2";
	}
}


function createMoreComment(more_comment_text)
{
	var moreComment;
	if(!$("#commentList"))
		moreComment = _("div", "#moreComment", $("#page"));
	else
	{
		moreComment = document.createElement("div");
		moreComment.id = "moreComment";
		$("#page").insertBefore(moreComment, $("#commentList"));
	}
	_("div", "#commentIcon", moreComment);
	_("span", ".shadow", moreComment).innerText = more_comment_text;
	moreComment.onclick = function(){ call(["more_comment"]); };
}
function clearMoreComment()
{
	if($("#moreComment")) $("#page").removeChild($("#moreComment"));
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
}