function refresh()
{
	createProfile("../face.jpg", "바나나", "South Korea", new Array(), new Array({"place":"Las Vegas, USA", "time":"2012.01.18"}, {"place":"Las Vegas, USA", "time":"2012.01.18"}), new Array(), 5, 3, 2);
}

function createProfile(profile_image_url, name, region, badges, feeds, trips, num_followings, num_followers, num_notification)
{
	var profile = document.getElementById("profile");
	fillProfile(profile, profile_image_url, name, region, num_notification);
	
	var info = document.getElementById("info");
	fillInfo(info, num_followings, num_followers, badges.length);
	
	var more = document.getElementById("more");
	fillMore(more, feeds, trips);
}

function fillProfile(profile, profileImageSrc, _userName, _region, _notice)
{
	var profileImageWrap = createClassElement("div", "profileImageWrap", profile);
	var profileImage = createClassElement("img", "profileImage", profileImageWrap);
	
	var leftBlock = createClassElement("div", "leftBlock", profile);
	var rightBlock = createClassElement("div", "rightBlock", profile);
	
	var userName = createClassElement("div", "userName", leftBlock);
	var region = createClassElement("div", "region", leftBlock);
	var notice = createClassElement("div", "notice", rightBlock);
	
	profileImage.src = profileImageSrc;
	userName.innerText = _userName;
	region.innerText = _region;
	notice.innerText = _notice;
}

function fillInfo(info, _followingsNum, _followersNum, _badgesNum)
{
	var followingsWrap = createClassElement("div", "wrap", info);
	var followingsNum = createClassElement("div", "num", followingsWrap);
	var followingsText = createClassElement("div", "text", followingsWrap);
	
	var followersWrap = createClassElement("div", "wrap", info);
	var followersNum = createClassElement("div", "num", followersWrap);
	var followersText = createClassElement("div", "text", followersWrap);
	
	var badgesWrap = createClassElement("div", "wrap", info);
	var badgesNum = createClassElement("div", "num", badgesWrap);
	var badgesText = createClassElement("div", "text", badgesWrap);
	
	followingsNum.innerText = _followingsNum;
	followingsText.innerText = "following";
	followersNum.innerText = _followersNum;
	followersText.innerText = "followers";
	badgesNum.innerText = _badgesNum;
	badgesText.innerText = "badges";
}

function fillMore(more, feedArray, tripArray)
{
	var more_feeds = document.getElementById("more_feeds");
	var more_trips = document.getElementById("more_trips");
	
	var text1 = createClassElement("div", "listText", more_feeds);
	var text2 = createClassElement("div", "listText", more_trips);
	
	text1.innerText = "See all " + feedArray.length + " feeds";
	text2.innerText = "See all " + tripArray.length + " trips";
	
	var button1 = createClassElement("div", "button", more_feeds);
	var button2 = createClassElement("div", "button", more_trips);
	
	button1.innerText = ">";
	button2.innerText = ">";
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