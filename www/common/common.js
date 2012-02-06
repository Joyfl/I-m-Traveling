// Variables

server = "http://imtraveling.joyfl.kr";
comments = new Array({"profile_image_src":"resource/face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"}, {"profile_image_src":"resource/face.jpg", "name":"바나나", "time":"2012.01.18", "content":"asdf"});
path = new Array({"lat":"40.737102","lng":"-73.990318"}, {"lat":"40.749825","lng":"-73.987963"}, {"lat":"40.752946","lng":"-73.987384"}, {"lat":"40.755823","lng":"-73.986397"});


// Functions

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

function createGap(height, parent)
{
	gap = document.createElement("div");
	gap.className = "gap";
	parent.appendChild(gap);
	gap.style.height = intToWidth(height);
	return gap;
}

function clear()
{
	var page = getId("page");
	if(page) document.body.removeChild(page);
	createIdElement("div", "page", document.body);
}

function fillTitle(title, user_id, _profileImageSrc, _userName, _rightTop, _leftBottom, _rightBottom)
{
	var profileImage = createClassElement("img", "profileImage", title);
	
	var upperWrap = createClassElement("div", "upperWrap", title);
	var lowerWrap = createClassElement("div", "lowerWrap", title);
	
	var userName = createClassElement("div", "leftTop", upperWrap);
	var rightTop = createClassElement("div", "rightTop", upperWrap);
	var leftBottom = createClassElement("div", "leftBottom", lowerWrap);
	var rightBottom = createClassElement("div", "rightBottom", lowerWrap);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	
	rightTop.innerText = _rightTop;
	leftBottom.innerText = _leftBottom;
	rightBottom.innerText = _rightBottom;
	
	var profile = function(){};
	
	profileImage.onclick = profile;
	userName.onclick = profile;
}

function fillContent(content, feed_id, _likes, _comments, _review)
{
	var review = createClassElement("div", "review", content);
	var action = createClassElement("div", "action", content);
	
	var likeButton = createClassElement("div", "likeButton", action);
	var commentButton = createClassElement("div", "commentButton", action);
	
	review.innerText = _review;
	likeButton.innerText = "☆ " + _likes;
	likeButton.onclick = function() {};
	commentButton.innerText = "▣ " + _comments;
	commentButton.onclick = function() {};
}

function widthToInt(width) { return Number(width.slice(0, width.length - 2)); }
function intToWidth(value) { return value.toString() + "px"; }

function getId(_id) { return document.getElementById(_id); }
function getName(_name) { return document.getElementsByName(_name); }
function getClass(_name) { return document.getElementsByClassName(_name); }