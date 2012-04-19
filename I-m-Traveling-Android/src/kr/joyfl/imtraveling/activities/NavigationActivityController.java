package kr.joyfl.imtraveling.activities;

import kr.joyfl.R;
import android.app.Activity;
import android.os.Bundle;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class NavigationActivityController extends Activity
{
	@Override
	public void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		setContentView( R.layout.navigation_activity_controller );
		
		Activity activity = (Activity)getIntent().getExtras().get( "rootActivity" );
		LinearLayout content = (LinearLayout)findViewById( R.id.content );
		
	}
	
	
}
