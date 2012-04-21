//
//  Const.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

// 정의되어있으면 loadPage에서 local파일을 로드한다.
//#define LOCAL

#ifdef LOCAL
	#define HTML_INDEX			@"index"
#else
	#define HTML_INDEX			@"http://jshs.woobi.co.kr/traveling/index.html"
#endif

#define API_LOGIN				@"https://imtraveling.joyfl.kr/login.php"
#define API_FEED_LIST			@"https://imtraveling.joyfl.kr/feed_list.php"
#define API_FEED_DETAIL			@"https://imtraveling.joyfl.kr/feed_detail.php"
#define API_FEED_COMMENT		@"https://imtraveling.joyfl.kr/feed_comment.php"
#define API_FEED_MAP			@"https://imtraveling.joyfl.kr/feed_map.php"
#define API_FEED_IMAGE			@"http://imtraveling.joyfl.kr/feed/"
#define API_TRIP_LIST			@"https://imtraveling.joyfl.kr/trip_list.php"
#define API_TRIP_ADD			@"https://imtraveling.joyfl.kr/trip_add.php"
#define API_PLACE_LIST			@"https://imtraveling.joyfl.kr/place_list.php"
#define API_PLACE_ADD			@"https://imtraveling.joyfl.kr/place_add.php"
#define API_UPLOAD				@"https://imtraveling.joyfl.kr/upload.php"
#define API_PROFILE				@"https://imtraveling.joyfl.kr/profile.php"
#define API_PROFILE_IMAGE		@"http://imtraveling.joyfl.kr/profile/"

#define SETTING_KEY_LOGGED_IN	@"logged_in"
#define SETTING_KEY_EMAIL		@"email"
#define SETTING_KEY_PASSWORD	@"password"
#define SETTING_KEY_USER_ID		@"user_id"
#define SETTING_KEY_REGION		@"region"