function test()
{
	var h1 = document.getElementsByTagName( "h1" )[0];
	h1.innerText = "a";
}

function onButtonClick()
{
	callNativeMethod( "alertMsg", [1, 2, 3] );
	//window.location = "js-call:alertMsg:hello title:tt"
}

function callNativeMethod( methodName, arguments )
{
	var str = "js-call:" + methodName;
	
	for( var i in arguments )
	{
		str += ":" + arguments[i];
	}
	
	window.location = str;
}