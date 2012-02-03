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

function clear()
{
	var page = document.getElementById("page");
	if(page) document.body.removeChild(page);
	createIdElement("div", "page", document.body);
}