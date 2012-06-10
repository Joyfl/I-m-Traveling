package loaders
{	
	import events.ImTravelingLoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	

	public class ImTravelingLoader extends EventDispatcher
	{
		private var _loader : URLLoader = new URLLoader();
		private var _queue : Array = [];
		
		public function ImTravelingLoader()
		{
			_loader.addEventListener( Event.COMPLETE, onLoadComplete );
		}
		
		public function add( url : String, params : Object = null, id : int = 0, method : String = "GET" ) : void
		{
			var token : ImTravelingLoaderToken = new ImTravelingLoaderToken();
			token.url = url;
			token.id = id;
			token.params = params;
			token.method = method;
			_queue.push( token );
		}
		
		public function startLoading() : void
		{
			if( _queue.length > 0 )
			{
				var token : ImTravelingLoaderToken = _queue[0];
				loadToken( token );
			}
		}
		
		public function getErrorCode( json : Object ) : int
		{
			if( !json.status ) json.result;
			return -1;
		}
		
		
		private function loadToken( token : ImTravelingLoaderToken ) : void
		{
			var request : URLRequest = new URLRequest( token.url );
			request.method = token.method;
			request.data = token.data;
			_loader.load( request );
		}
		
		private function onLoadComplete( e : Event ) : void
		{
			var event : ImTravelingLoadEvent = new ImTravelingLoadEvent( ImTravelingLoadEvent.LOAD_COMPLETE );
			event.token = _queue.shift();
			event.token.data = _loader.data;
			dispatchEvent( event );
			
			if( _queue.length > 0 )
			{
				loadToken( _queue[0] );
			}
		}
	}
}

