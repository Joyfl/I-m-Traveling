package events
{
	import flash.events.Event;

	public class ImTravelingWebViewEvent extends Event
	{
		public static const LOAD_COMPLETE : String = "loadComplete";
		public static const RECEIVE_MESSAGE : String = "receiveMessage";
		public static const SCROLL : String = "scroll";
		
		public var webView : ImTravelingWebView;
		public var message : String;
		public var arguments : Array;
		
		public function ImTravelingWebViewEvent( type : String )
		{
			super( type );
		}
	}
}