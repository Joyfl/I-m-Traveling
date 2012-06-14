//
//  UploadManager.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 17..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UploadManager.h"
#import "ImTravelingLoader.h"
#import "SettingsManager.h"
#import "Const.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "ShareViewController.h"
#import "FacebookManager.h"


@implementation UploadManager

enum {
	kTokenIdFeed = 0,
	kTokenIdFacebookPhoto = 1
};

+ (UploadManager *)manager
{
	static UploadManager *manager;
	
	if( !manager )
	{
		manager = [[UploadManager alloc] init];
	}
	
	return manager;
}

- (id)init
{
	self = [super init];
	
//	[[SettingsManager manager] clearSettingForKey:SETTING_KEY_LOCAL_SAVED_TRIPS]; [[SettingsManager manager] clearSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS]; [[SettingsManager manager] flush];
	
	_tripUploader = [[ImTravelingLoader alloc] init];
	_tripUploader.delegate = self;
	
	// 로컬에 저장되어있는 여행 불러와서 업로드 큐에 저장
	_trips = [[NSMutableArray alloc] initWithArray:[[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_SAVED_TRIPS]];
	NSLog( @"Local saved trips : %d", _trips.count );
	
	for( NSMutableDictionary *trip in _trips )
	{
		if( [trip objectForKey:@"user_id"] == [Utils userIdNumber] )
		{
			[self uploadTrip:trip];
		}
	}
	
	
	_feedUploader = [[ImTravelingLoader alloc] init];
	_feedUploader.delegate = self;
	
	// 로컬에 저장되어있는 피드 불러와서 업로드 큐에 저장
	_feeds = [[NSMutableArray alloc] initWithArray:[[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS]];
	NSLog( @"Local saved feeds : %d", _feeds.count );
	
	for( NSMutableDictionary *feed in _feeds )
	{
		if( [feed objectForKey:@"user_id"] == [Utils userIdNumber] )
		{
			[self uploadFeed:feed];
		}
	}
	
	return self;
}

- (NSInteger)addTrip:(NSMutableDictionary *)trip
{
	NSInteger localTripId = [self localTripId];
	[trip setObject:[NSNumber numberWithInteger:localTripId] forKey:@"trip_id"];
	[trip setObject:[Utils userIdNumber] forKey:@"user_id"];
	[trip setObject:[Utils email] forKey:@"email"];
	[trip setObject:[Utils password] forKey:@"password"];
	[_trips addObject:trip];
	
	NSLog( @"_trips.count after adding new trip(localTripId=%d) : %d", localTripId, _trips.count );
	
	// 새로운 여행이 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_trips forKey:SETTING_KEY_LOCAL_SAVED_TRIPS];
	[[SettingsManager manager] flush];
	
	[self uploadTrip:trip];
	
	return localTripId;
}

// 새로운 피드 추가
- (void)addFeed:(NSMutableDictionary *)feed
{
	[feed setObject:[Utils userIdNumber] forKey:@"user_id"];
	[feed setObject:[Utils email] forKey:@"email"];
	[feed setObject:[Utils password] forKey:@"password"];
	[_feeds addObject:feed];
	NSLog( @"_feeds after adding new feed : %d", _feeds.count );
	
	// 새로운 피드가 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
	
	[self uploadFeed:feed];
}

- (void)uploadTrip:(NSMutableDictionary *)trip
{
	NSInteger localTripId = [[trip objectForKey:@"trip_id"] integerValue];
	
	NSLog( @"upload trip (localTripId=%d) : %@", localTripId, trip );
	
	// Facebook Album에 먼저 업로드하고, facebook album id를 얻어와서 ImTraveling 서버로 업로드한다.
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   [FacebookManager manager].facebook.accessToken, @"access_token",
								   [trip objectForKey:@"trip_title"], @"name",
								   [trip objectForKey:@"summary"], @"message", nil];
	[_tripUploader addTokenWithTokenId:localTripId - 1000 url:@"https://graph.facebook.com/me/albums" method:ImTravelingLoaderMethodPOST params:params];
	
	// ImTraveling Trip
	[_tripUploader addTokenWithTokenId:localTripId url:API_TRIP_ADD method:ImTravelingLoaderMethodGET params:trip];
	[_tripUploader startLoading];
}

- (void)uploadFeed:(NSMutableDictionary *)feed
{
	UIImage *picture = [feed objectForKey:@"picture"];
	
	// picture가 UIImagePNGRepresentation으로 직렬화되어 저장되었을 경우 UIImage로 풀어준다.
	if( [picture isKindOfClass:NSData.class] )
	{
		picture = [UIImage imageWithData:[feed objectForKey:@"picture"]];
		[feed setObject:picture forKey:@"picture"];
	}
	
	NSLog( @"upload feed : %@", feed );
	
	// ImTraveling Feed
	[_feedUploader addTokenWithTokenId:kTokenIdFeed url:API_UPLOAD method:ImTravelingLoaderMethodPOST params:feed];
	
	// Facebook Photo
	if( [[feed objectForKey:@"share_to_facebook"] boolValue] )
	{
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   [FacebookManager manager].facebook.accessToken, @"access_token",
									   picture, @"source",
									   [feed objectForKey:@"review"], @"name", nil];
		NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos", [feed objectForKey:@"facebook_album_id"]];
		[_feedUploader addTokenWithTokenId:kTokenIdFacebookPhoto url:url method:ImTravelingLoaderMethodPOST params:params];
	}
	
	[_feedUploader startLoading];
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (BOOL)shouldLoadWithToken:(ImTravelingLoaderToken *)token
{
	NSLog( @"shouldLoadWithToken tokenId=%d", token.tokenId );
	// 업로드할 것인지 물어본 토큰이 속한 로더가 피드 업로드이고, 여행이 업로드중이면 피드 업로드 중단.
	if( token.tokenId >= 0 && _tripUploader.queueLength > 0 )
	{
		NSLog( @"Trip is uploading. Stop feed uploading." );
		return NO;
	}
	
	if( token.tokenId >= 0 )
	{
		NSLog( @"No trip is uploading. Start uploading feed." );
	}
	else
	{
		NSLog( @"Upload trip." );
	}
	
	return YES;
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSLog( @"result(id=%d) : %@", token.tokenId, token.data );
	
	// 페이스북 앨범 생성 완료
	if( token.tokenId < -1000 )
	{
		NSString *facebookAlbumId = [[Utils parseJSON:token.data] objectForKey:@"id"];
		NSInteger localTripId = token.tokenId + 1000;
		
		for( NSInteger i = 0; i < _tripUploader.queueLength; i++ )
		{
			NSMutableDictionary *params = [_tripUploader tokenAtIndex:i].params;
			if( [[params objectForKey:@"trip_id"] integerValue] == localTripId )
			{
				NSLog( @"Find out the trip which trip id is %d. Change facebook_album_id to %@", localTripId, facebookAlbumId );
				[params setObject:facebookAlbumId forKey:@"facebook_album_id"];
			}
		}
		
		for( NSInteger i = 0; i < _feedUploader.queueLength; i++ )
		{
			NSMutableDictionary *params = [_feedUploader tokenAtIndex:i].params;			
			if( [[params objectForKey:@"share_to_facebook"] boolValue] && [[params objectForKey:@"trip_id"] integerValue] == localTripId )
			{
				NSLog( @"Find out the feed which trip id is %d. Change facebook_album_id to %@", localTripId, facebookAlbumId );
				[params setObject:facebookAlbumId forKey:@"facebook_album_id"];
			}
		}
	}
	
	// 페이스북 사진 업로드 완료
	else if( token.tokenId == kTokenIdFacebookPhoto )
	{
		NSLog( @"Facebook photo uploading finished." );
	}
	else
	{
		NSDictionary *json = [Utils parseJSON:token.data];
		if( [[json objectForKey:@"status"] integerValue] == 0 )
		{
			NSLog( @"Error" );
			return;
		}
		
		// 여행 업로드 완료
		if( token.tokenId < 0 )
		{
			NSInteger tripId = [[json objectForKey:@"result"] integerValue];
			NSInteger localTripId = token.tokenId;
			
			NSLog( @"tripId from server : %d", tripId );
			
			// 피드 작성중 여행 업로드가 완료될 경우 ShareView에서 작성중인 피드의 trip_id를 서버에서 로드한 trip_id로 바꿔줌
			[[(AppDelegate *)[UIApplication sharedApplication].delegate shareViewController] tripLoadingDidFinishWithTripId:tripId andLocalTripId:localTripId];
			
			for( NSInteger i = 0; i < _feedUploader.queueLength; i++ )
			{
				NSMutableDictionary *params = [_feedUploader tokenAtIndex:i].params;
				
				NSLog( @"_feeds looping, trip_id : %d", [[params objectForKey:@"trip_id"] integerValue] );
				
				if( [[params objectForKey:@"trip_id"] integerValue] == localTripId )
				{
					NSLog( @"Find out the feed which trip id is %d. Change to %d", localTripId, tripId );
					[params setObject:[NSNumber numberWithInteger:tripId] forKey:@"trip_id"];
				}
			}
			
			// 업로드가 완료된 여행은 제거
			[_trips removeObjectAtIndex:0];
			NSLog( @"_trips.count after removing uploading finished trip : %d", _trips.count );
			
			// 피드 업로드 계속 진행
			[_feedUploader startLoading];
			
			// 업로드가 완료된 여행이 제거된 배열을 로컬에 저장
			[[SettingsManager manager] setSetting:_trips forKey:SETTING_KEY_LOCAL_SAVED_TRIPS];
			
			// 사용이 완료된 localTripId를 다시 큐에 저장
			NSMutableArray *localTripIds = [[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_TRIP_IDS];
			[localTripIds addObject:[NSNumber numberWithInteger:localTripId]];
			[[SettingsManager manager] setSetting:localTripIds forKey:SETTING_KEY_LOCAL_TRIP_IDS];
			
			[[SettingsManager manager] flush];
		}
		
		// 피드 업로드 완료
		else if( token.tokenId == kTokenIdFeed )
		{
			// 업로드가 완료된 피드는 제거
			[_feeds removeObjectAtIndex:0];
			NSLog( @"_feeds.count after removing uploading finished feed : %d", _feeds.count );
			
			// 업로드가 완료된 피드가 제거된 배열을 로컬에 저장
			[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
			[[SettingsManager manager] flush];
		}
	}
}


#pragma mark -
#pragma mark 

- (NSInteger)localTripId
{
	NSMutableArray *localTripIds = [[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_TRIP_IDS];
	if( localTripIds == nil )
	{
		localTripIds = [[NSMutableArray alloc] init];
		
		for( NSInteger i = -1; i > -50; i-- )
		{
			[localTripIds addObject:[NSNumber numberWithInteger:i]];
		}
	}
	
	NSInteger localTripId = [[localTripIds objectAtIndex:0] integerValue];
	[localTripIds removeObjectAtIndex:0];
	
	[[SettingsManager manager] setSetting:localTripIds forKey:SETTING_KEY_LOCAL_TRIP_IDS];
	[[SettingsManager manager] flush];
	
	return localTripId;
}


#pragma mark -
#pragma mark Getter

- (NSInteger)numUploadings
{
	return _feeds.count;
}

- (NSDictionary *)currentUploading
{
	return [_feeds objectAtIndex:0];
}

@end
