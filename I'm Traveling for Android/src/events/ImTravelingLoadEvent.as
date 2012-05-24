package events
{
	import flash.events.Event;
	
	import loaders.ImTravelingLoaderToken;

	public class ImTravelingLoadEvent extends Event
	{
		public static const LOAD_COMPLETE : String = "loadComplete";
		
		public var token : ImTravelingLoaderToken;
		
		public function ImTravelingLoadEvent( type : String )
		{
			super( type );
		}
	}
}