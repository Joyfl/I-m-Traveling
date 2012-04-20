package kr.joyfl.imtraveling.activities;

import java.util.ArrayList;
import java.util.Arrays;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import kr.joyfl.R;
import kr.joyfl.imtraveling.models.Feed;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class FeedListActivity extends Activity
{
	public WebView webView;
	ArrayList<Feed> feeds;
	
	@Override
	public void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		setContentView( R.layout.feed_list );
		
		feeds = new ArrayList<Feed>();
		
		webView = (WebView)findViewById( R.id.webView );
		webView.getSettings().setJavaScriptEnabled( true );
		webView.loadUrl( "http://jshs.woobi.co.kr/traveling/index.html" );
		webView.setWebViewClient( new WebViewClient()
		{
			@Override
			public void onPageFinished( WebView webView, String url )
			{
				Log.i( "asd", url );
				if( url.equals( "http://jshs.woobi.co.kr/traveling/index.html" ) )
				{
					loadData( "http://imtraveling.joyfl.kr/feed_list.php?from=0&order_type=1" );
				}
			}
			
			@Override
			public boolean shouldOverrideUrlLoading( WebView webView, String url )
			{
				String[] components = url.split( ":" );
				if( components[0].equals( "imtraveling" ) )
				{
					messageFromWebView( components[1], Arrays.copyOfRange( components, 2, components.length ) );
					return true;
				}
				
				return false;
			}
		} );
	}
	
	public void messageFromWebView( String message, String[] arguments )
	{
		Log.i( "I'm Traveling", "msg : " + message );
		for( String arg : arguments )
			Log.i( "I'm Traveling", "args : " + arg );
		
		// temp code
//		webView.buildDrawingCache();
//		Bitmap bitmap = webView.getDrawingCache();
//		ImageView imageView = new ImageView( this );
//		imageView.setImageBitmap( bitmap );
//		setContentView( imageView );
	}
	
	public void executeJavascript( String javascript )
	{
		webView.loadUrl( "javascript:" + javascript );
	}
	
	public void onLoadComplete( String data )
	{
		Log.i( "I'm Traveling", data );
		
		executeJavascript( "clear()" );
		
		try
		{
			JSONArray json = new JSONArray( data );
			
			for( int i = 0; i < json.length(); i++ )
			{
				JSONObject f = json.getJSONObject( i );
				
				Feed feed = new Feed();
				feed.feedId = f.getInt( "feed_id" );
				feed.userId = f.getInt( "user_id" );
				feed.name = f.getString( "name" );
				feed.place = f.getString( "place" );
				feed.region = f.getString( "region" );
				feed.time = f.getString( "time" );
				feed.review = f.getString( "review" );
				feed.numLikes = f.getInt( "num_likes" );
				feed.numComments = f.getInt( "num_comments" );
				feed.latitude = f.getDouble( "latitude" );
				feed.longitude = f.getDouble( "longitude" );
				addFeed( feed );
			}
		}
		catch( Exception e )
		{
			
		}
	}
	
	public void loadData( final String url )
	{
		new AsyncTask<Void, Void, Void>()
		{
			@Override
			protected Void doInBackground( Void...voids )
			{
				try
				{
					HttpGet request = new HttpGet( url );
					HttpResponse response = new DefaultHttpClient().execute( request );
					HttpEntity entity = response.getEntity();
					onLoadComplete( EntityUtils.toString( entity ) );
				}
				catch( Exception e )
				{
					Log.i( "I'm Traveling", "Loading Error" );
				}
				
				return null;
			}
		}.execute();
	}
	
	public void addFeed( Feed feed )
	{
		Log.i( "I'm Traveling", "addFeed" + getJavascriptParams(
				feed.feedId,
				feed.userId,
				"http://imtraveling.joyfl.kr/profile/" + feed.userId,
				feed.name,
				feed.time,
				feed.place,
				feed.region,
				"http://imtraveling.joyfl.kr/feed/" + feed.userId + "_" + feed.feedId,
				feed.review,
				feed.numLikes,
				feed.numComments ) );
		
		feeds.add( feed );
		executeJavascript( "addFeed" + getJavascriptParams(
				feed.feedId,
				feed.userId,
				"http://imtraveling.joyfl.kr/profile/" + feed.userId + ".jpg",
				feed.name,
				feed.time,
				feed.place,
				feed.region,
				"http://imtraveling.joyfl.kr/feed/" + feed.userId + "_" + feed.feedId + ".jpg",
				feed.review,
				feed.numLikes,
				feed.numComments ) );
	}
	
	public String getJavascriptParams( Object...objects )
	{
		String params = "(";
		for( int i = 0; i < objects.length; i++ )
		{
			if( objects[i].getClass().equals( String.class ) )
				params += "\"" + objects[i] + "\"";
			else
				params += objects[i];
			
			if( i < objects.length - 1 )
				params += ",";
		}
		return params + ")";
	}
}