peopleArray = new Array();

function refresh()
{
	// create list
	for(var index = 0; index < 3; index++)
		addPeople(1001, "../face.jpg", "바나나", "South Korea");
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

function removeAllPeople()
{
	document.body.removeChild(document.getElementById("peopleList"));
	createIdElement("ul", "peopleList", document.body);
}

function addPeople(user_id, profile_img_url, name, region)
{
	peopleArray.push(user_id);
	peopleList = document.getElementById("peopleList");
	var component = createClassElement("li", "li", peopleList);
	var wrap = createClassElement("div", "wrap", component);
	fillContent(wrap, user_id, profile_img_url, name, region);
}

function fillContent(wrap, user_id, _profileImageSrc, _userName, _region)
{
	var profileImageWrap = createClassElement("div", "profileImageWrap", wrap);
	var profileImage = createClassElement("img", "profileImage", profileImageWrap);
	
	var leftBlock = createClassElement("div", "leftBlock", wrap);
	var rightBlock = createClassElement("div", "rightBlock", wrap);
	
	var userName = createClassElement("div", "userName", leftBlock);
	var region = createClassElement("div", "region", leftBlock);
	var follow = createClassElement("div", "follow", rightBlock);
	
	profileImage.src = _profileImageSrc;
	userName.innerText = _userName;
	region.innerText = _region;
	follow.innerText = "ㅇ Follow";
}