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
	document.body.removeChild(document.getElementById("page"));
	createIdElement("div", "page", document.body);
}

function positionToStaticMapUrl(mapInfo, color, marker, size, sensor)
{
	var url = "http://maps.googleapis.com/maps/api/staticmap?center=";
	var pos = mapInfo.lat + "," + mapInfo.lng;
	return url + pos + "&markers=color:" + color + "|label:" + marker + "|" + pos + "&size=" + size + "&sensor=" + sensor;
}

function traceToStaticMapUrl(mapInfo, color, weight, size, sensor)
{
	var url = "http://maps.googleapis.com/maps/api/staticmap?path=";
	var path = "";
	for(var i = 0; i < mapInfo.length; i++)
		path += "|" + mapInfo[i].lat + "," + mapInfo[i].lng;
	return url + "color:" + color + "|weight:" + weight + path + "&size=" + size + "&sensor=" + sensor;
}