package
{
	import events.ImTravelingWebViewEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.LocationChangeEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import mx.core.UIComponent

	public class ImTravelingWebView extends UIComponent
	{
		public var stageWebView : StageWebView = new StageWebView();
		
		private var _scrollY : int;
		public function get scrollY() : int { return _scrollY; }
		public function set scrollY( y : int ) : void { callJavascript( "scrollTo", 0, _scrollY = y ); }
		
		private var _contentHeight : int;
		public function get contentHeight() : int { return _contentHeight; }
		
		override public function get x() : Number
		{
			if( stageWebView.viewPort ) return 0;
			return stageWebView.viewPort.x;
		}
		override public function set x( x : Number ) : void
		{
			if( !stageWebView.viewPort ) return;
			var rect : Rectangle = stageWebView.viewPort;
			rect.x = x;
			stageWebView.viewPort = rect;
		}
		
		override public function get y() : Number
		{
			if( !stageWebView.viewPort ) return 0;
			return stageWebView.viewPort.y;
		}
		
		override public function set y( y : Number ) : void
		{
			if( !stageWebView.viewPort ) return;
			var rect : Rectangle = stageWebView.viewPort;
			rect.y = y;
			stageWebView.viewPort = rect;
		}
		
		public function set stage( stage : Stage ) : void
		{
			stageWebView.stage = stage;
			
			if( !stageWebView.viewPort )
				stageWebView.viewPort = new Rectangle( 0, 68, stage.stageWidth, stage.stageHeight - 144 );
		}
		
		public function ImTravelingWebView( stage : Stage = null )
		{
			if( stage ) this.stage = stage;
			
			stageWebView.addEventListener( Event.COMPLETE, onWebViewLoadComplete );
			stageWebView.addEventListener( LocationChangeEvent.LOCATION_CHANGING, onWebViewLocationChanging );
		}
		
		public function loadHTML( fileName : String ) : void
		{
			var url : String;
			
			if( Const.LOCAL_HTML )
				url = "file:" + File.applicationStorageDirectory.resolvePath( "www" ).resolvePath( fileName + ".html" ).nativePath;
				
			else
				url = "http://jshs.woobi.co.kr/traveling/index.html";
			
			stageWebView.loadURL( url );
		}
		
		private function onWebViewLoadComplete( e : Event ) : void
		{
			trace( "webview load complete" );
			
			stageWebView.loadURL( 'javascript:window.onscroll = function() { call( ["scrollY", scrollY] ); }' );
			stageWebView.loadURL( 'javascript:getHeight = function() { call( ["contentHeight", document.body.clientHeight] ); return document.body.clientHeight; }' );
			
			var event : ImTravelingWebViewEvent = new ImTravelingWebViewEvent( ImTravelingWebViewEvent.LOAD_COMPLETE );
			event.webView = this;
			dispatchEvent( event );
		}
		
		private function onWebViewLocationChanging( e : LocationChangeEvent ) : void
		{
			if( e.location.search( "imtraveling:" ) == 0 )
			{
				e.preventDefault();
				
				var arguments : Array = e.location.split( ":" );
				arguments.shift();
				
				var message : String = arguments.shift();
				switch( message )
				{
					case "scrollY":
						_scrollY = arguments[0];
						var scrollEvent : ImTravelingWebViewEvent = new ImTravelingWebViewEvent( ImTravelingWebViewEvent.SCROLL );
						dispatchEvent( scrollEvent );
						return;
						
					case "contentHeight":
						_contentHeight = arguments[0];
						return;
				}
				
				var event : ImTravelingWebViewEvent = new ImTravelingWebViewEvent( ImTravelingWebViewEvent.RECEIVE_MESSAGE );
				event.message = message;
				event.arguments = arguments;
				dispatchEvent( event );
			}
		}
		
		public function callJavascript( functionName : String, ...args ) : void
		{
			var url : String = "javascript:" + functionName + "(";
			
			for( var i : int = 0; i < args.length; i++ )
			{
				if( args[i] is Number )
					url += args[i];
				else
					url += "'" + args[i] + "'";
				
				if( i < args.length - 1 )
					url += ",";
			}
			
			url += ");getHeight();";
			
			stageWebView.loadURL( url );
			trace( url );
		}
	}
}