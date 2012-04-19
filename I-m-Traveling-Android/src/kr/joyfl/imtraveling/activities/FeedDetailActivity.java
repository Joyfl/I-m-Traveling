package kr.joyfl.imtraveling.activities;

import kr.joyfl.R;
import android.app.Activity;
import android.os.Bundle;
import android.widget.ImageView;

public class FeedDetailActivity extends Activity
{
	@Override
	public void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		
		ImageView navigationBar = new ImageView( this );
		navigationBar.setImageResource( R.drawable.navigation_bar );
		setContentView( navigationBar );
	}
}
