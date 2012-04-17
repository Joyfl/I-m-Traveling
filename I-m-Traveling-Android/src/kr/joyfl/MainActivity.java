package kr.joyfl;

import kr.joyfl.activities.FeedListActivity;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TabHost;

public class MainActivity extends TabActivity
{
	/** Called when the activity is first created. */
	@Override
	public void onCreate( Bundle savedInstanceState)
	{
		super.onCreate( savedInstanceState );
		
		TabHost tabHost = getTabHost();
		tabHost.getTabWidget().setPadding( 0, 50, 0, 0 );
		
		// Feed Tab
		tabHost.addTab( tabHost.newTabSpec( "Feed" )
				.setIndicator( "Feed" )
				.setContent( new Intent( this, FeedListActivity.class ) ) );
	}
}