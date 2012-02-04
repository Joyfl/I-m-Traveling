// Variables

imageWidth = 320;
imageHeight = 200;
margin = 10;

// Functions

function init()
{
	document.body.style.width = intToWidth(imageWidth);
	for(var i = 0; i < 5; i++) loadFeedImage(i, "../resource/thumbnail.jpg");
}

function loadFeedImage(index, feed_image_url)
{
	if(imageWidth * (index + 1) > widthToInt(document.body.style.width))
		document.body.style.width = intToWidth(imageWidth * (index + 1));
	var image = createClassElement("img", "detailImage", document.getElementById("scroll"));
	image.style.width = intToWidth(imageWidth - 2 * margin);
	image.style.height = intToWidth(imageHeight);
	image.style.left = intToWidth(imageWidth * index);
	image.src = feed_image_url;
}