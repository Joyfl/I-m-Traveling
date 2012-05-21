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


@implementation UploadManager

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
	NSLog( @"로컬에 저장된 여행 개수 : %d개", _trips.count );
	
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
	NSLog( @"로컬에 저장된 피드 개수 : %d개", _feeds.count );
	
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
	
	NSLog( @"새로운 여행(localTripId=%d) 추가 후 여행 개수 : %d", localTripId, _trips.count );
	
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
	NSLog( @"새로운 피드 추가 후 피드 개수 : %d", _feeds.count );
	
	// 새로운 피드가 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
	
	[self uploadFeed:feed];
}

- (void)uploadTrip:(NSMutableDictionary *)trip
{
	NSInteger localTripId = [[trip objectForKey:@"trip_id"] integerValue];
	
	NSLog( @"업로드 할 여행 (localTripId=%d) : %@", localTripId, trip );
	
	[_tripUploader loadURL:API_TRIP_ADD withData:trip andId:localTripId];
}

- (void)uploadFeed:(NSMutableDictionary *)feed
{
	// picture가 UIImagePNGRepresentation으로 직렬화되어 저장되었을 경우 UIImage로 풀어준다.
	if( [[feed objectForKey:@"picture"] isKindOfClass:NSData.class] )
	{
		UIImage *picture = [UIImage imageWithData:[feed objectForKey:@"picture"]];
		[feed setObject:picture forKey:@"picture"];
	}
	
	NSLog( @"업로드 할 피드 : %@", feed );
	
	[_feedUploader loadURLPOST:API_UPLOAD withData:feed andId:0];
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (BOOL)shouldLoadWithToken:(ImTravelingLoaderToken *)token
{
	NSLog( @"shouldLoadWithToken tokenId=%d", token.tokenId );
	// 업로드할 것인지 물어본 토큰이 속한 로더가 피드 업로드이고, 여행이 업로드중이면 피드 업로드 중단.
	if( token.tokenId == 0 && _tripUploader.queueLength > 0 )
	{
		NSLog( @"여행이 업로드중임!! 피드 업로드 중단!" );
		return NO;
	}
	
	if( token.tokenId == 0 )
		NSLog( @"여행이 업로드중이지 않음!! 피드 업로드!!" );
	else
		NSLog( @"여행 업로드!!" );
	
	return YES;
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSLog( @"업로드 결과(id=%d) : %@", token.tokenId, token.data );
	
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [[json objectForKey:@"status"] integerValue] == 0 )
	{
		NSLog( @"업로드 에러" );
		return;
	}
	
	// 여행 업로드 완료
	if( token.tokenId < 0 )
	{
		NSInteger tripId = [[json objectForKey:@"result"] integerValue];
		NSInteger localTripId = token.tokenId;
		
		NSLog( @"서버에서 받아온 여행 id : %d", tripId );
		
		// 피드 작성중 여행 업로드가 완료될 경우 작성중인 피드의 trip_id를 서버에서 로드한 trip_id로 바꿔줌
		[[(AppDelegate *)[UIApplication sharedApplication].delegate shareViewController] tripLoadingDidFinishWithTripId:tripId andLocalTripId:localTripId];
		
		// _feeds는 클리어할 것이므로 사본을 만들어둠
		NSArray *feeds = [NSArray arrayWithArray:_feeds];
		
		// uploader의 큐에 있는 데이터는 tripId가 localTripId로 저장된 feed들이므로, 새로 받은 tripId로 치환 후 다시 큐에 넣어준다.
		NSLog( @"큐 클리어" );
		[_feedUploader clearQueue];
		[_feeds removeAllObjects];
		
		// localTripId를 서버에서 받은 tripId로 수정
		for( NSMutableDictionary *feed in feeds )
		{
			NSLog( @"_feeds 루프돌리는 중, trip_id : %d", [[feed objectForKey:@"trip_id"] integerValue] );
			if( [[feed objectForKey:@"trip_id"] integerValue] == localTripId )
			{
				NSLog( @"trip id가 %d인 피드 발견!! %d로 바꿈!", localTripId, tripId );
				[feed setObject:[NSNumber numberWithInteger:tripId] forKey:@"trip_id"];
				
				[self addFeed:feed];
			}
		}
		
		// 업로드가 완료된 여행은 제거
		[_trips removeObjectAtIndex:0];
		NSLog( @"업로드가 완료된 여행 제거 후 여행 개수 : %d", _trips.count );
		
		// 업로드가 완료된 여행이 제거된 배열을 로컬에 저장
		[[SettingsManager manager] setSetting:_trips forKey:SETTING_KEY_LOCAL_SAVED_TRIPS];
		
		// 사용이 완료된 localTripId를 다시 큐에 저장
		NSMutableArray *localTripIds = [[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_TRIP_IDS];
		[localTripIds addObject:[NSNumber numberWithInteger:localTripId]];
		[[SettingsManager manager] setSetting:localTripIds forKey:SETTING_KEY_LOCAL_TRIP_IDS];
		
		[[SettingsManager manager] flush];
	}
	
	// 피드 업로드 완료
	else
	{
		// 업로드가 완료된 피드는 제거
		[_feeds removeObjectAtIndex:0];
		NSLog( @"업로드가 완료된 피드 제거 후 피드 개수 : %d", _feeds.count );
		
		// 업로드가 완료된 피드가 제거된 배열을 로컬에 저장
		[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
		[[SettingsManager manager] flush];
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
