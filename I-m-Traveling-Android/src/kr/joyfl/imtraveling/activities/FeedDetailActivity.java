package kr.joyfl.imtraveling.activities;

import kr.joyfl.R;
import kr.joyfl.imtraveling.Const;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Matrix.ScaleToFit;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;;

public class FeedDetailActivity extends Activity
{
	@Override
	public void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		
		setContentView( R.layout.feed_detail );
		
		RelativeLayout layout = (RelativeLayout)findViewById( R.id.layout );
		
		ImageView topImageView = new ImageView( this );
		topImageView.setImageBitmap( FeedListActivity.topBitmap );
		topImageView.setScaleType( ScaleType.FIT_START );
		LayoutParams topImageViewLayoutParams = new LayoutParams( LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT );
		topImageViewLayoutParams.setMargins( 0, Const.navigationBarHeight, 0, 0 );
		topImageView.setLayoutParams( topImageViewLayoutParams );
		layout.addView( topImageView );
		
		
		Log.i( "Asdsad", "a : " + FeedListActivity.topBitmap.getHeight() );
		ImageView bottomImageView = new ImageView( this );
		bottomImageView.setScaleType( ScaleType.FIT_START );
		bottomImageView.setImageBitmap( FeedListActivity.bottomBitmap );
		LayoutParams bottomImageViewLayoutParams = new LayoutParams( LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT );
		bottomImageViewLayoutParams.setMargins( 0, Const.navigationBarHeight + FeedListActivity.topBitmap.getHeight() * 3 / 2, 0, 0 );
		bottomImageView.setLayoutParams( bottomImageViewLayoutParams );
		layout.addView( bottomImageView );
		
		FeedListActivity.topBitmap = null;
		FeedListActivity.bottomBitmap = null;
	}
}
