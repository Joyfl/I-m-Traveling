package kr.joyfl.imtraveling.activities;

import kr.joyfl.R;
import kr.joyfl.R.layout;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TabHost;

public class MainActivity extends TabActivity
{
	/** Called when the activity is first created. */
	@Override
	public void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		setContentView( R.layout.tab_activity_controller );
		
		TabHost tabHost = getTabHost();
		
		// Feed Tab		
		tabHost.addTab( tabHost.newTabSpec( "Feed" )
				.setIndicator( "Feed" )
				.setContent( new Intent( this, FeedListActivity.class ) ) );
		
		tabHost.addTab( tabHost.newTabSpec( "Profile" )
				.setIndicator( "Profile" )
				.setContent( new Intent( this, FeedListActivity.class ) ) );
	}
}