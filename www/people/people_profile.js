function refresh()
{
	createProfile("../face.jpg", "바나나", "South Korea", new Array(), new Array({"place":"Las Vegas, USA", "time":"2012.01.18"}, {"place":"Las Vegas, USA", "time":"2012.01.18"}), new Array(), 5, 3, 2);
	show_feeds();
}

function createProfile(profile_img_url, name, region, badges, feeds, trips, num_followings, num_followers, num_notification)
{
	var profile = document.getElementById("profile");
	fillProfile(profile, profile_img_url, name, region, num_notification);
	
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
	var followingsWrap = createClassElement("a", "wrap", info);
	var followingsNum = createClassElement("div", "num", followingsWrap);
	var followingsText = createClassElement("div", "text", followingsWrap);
	
	var followersWrap = createClassElement("a", "wrap", info);
	var followersNum = createClassElement("div", "num", followersWrap);
	var followersText = createClassElement("div", "text", followersWrap);
	
	var badgesWrap = createClassElement("a", "wrap", info);
	var badgesNum = createClassElement("div", "num", badgesWrap);
	var badgesText = createClassElement("div", "text", badgesWrap);
	
	followingsWrap.href = "#";
	followingsNum.innerText = _followingsNum;
	followingsText.innerText = "following";
	followersWrap.href = "#";
	followersNum.innerText = _followersNum;
	followersText.innerText = "followers";
	badgesWrap.href = "#";
	badgesNum.innerText = _badgesNum;
	badgesText.innerText = "badges";
}

function fillMore(more, feedArray, tripArray)
{
	var more_feeds = document.getElementById("more_feeds");
	var more_trips = document.getElementById("more_trips");
	
	more_feeds.href = "#";
	more_trips.href = "#";
	
	more_feeds.innerHTML = "See all " + feedArray.length + " feeds" + "<div class=\"button\">\></div>";
	more_trips.innerHTML = "See all " + tripArray.length + " trips" + "<div class=\"button\">\></div>";
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