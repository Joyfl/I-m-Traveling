// Variables

imageWidth = 300;
imageHeight = 300;


// Functions

function init()
{
	document.body.style.width = intToWidth(imageWidth);
	for(var i = 0; i < 12; i++) loadFeedImage(i, "../resource/thumbnail.jpg");
}

function loadFeedImage(index, feed_image_url)
{
	if(imageWidth * (index + 1) > widthToInt(document.body.style.width))
		document.body.style.width = intToWidth(imageWidth * (index + 1));
	var image = createClassElement("img", "detailImage", document.getElementById("scroll"));
	image.style.width = intToWidth(imageWidth);
	image.style.height = intToWidth(imageHeight);
	image.style.left = intToWidth(imageWidth * index);
	image.src = feed_image_url;
}

function widthToInt(width) { return Number(width.slice(0, width.length-2)); }
function intToWidth(value) { return value.toString() + "px"; }