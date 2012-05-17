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
	
	_tripUploader = [[ImTravelingLoader alloc] init];
	_tripUploader.delegate = self;
	
	[[SettingsManager manager] clearSettingForKey:SETTING_KEY_LOCAL_SAVED_TRIPS];
	[[SettingsManager manager] clearSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
	
	// 로컬에 저장되어있는 여행 불러와서 업로드 큐에 저장
	_trips = [[NSMutableArray alloc] initWithArray:[[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_SAVED_TRIPS]];
	NSLog( @"로컬에 저장된 여행 개수 : %d개", _trips.count );
	
	for( NSMutableDictionary *trip in _trips )
	{
		[self uploadTrip:trip];
	}
	
	_feedUploader = [[ImTravelingLoader alloc] init];
	_feedUploader.delegate = self;
	
	// 로컬에 저장되어있는 피드 불러와서 업로드 큐에 저장
	_feeds = [[NSMutableArray alloc] initWithArray:[[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS]];
	NSLog( @"로컬에 저장된 피드 개수 : %d개", _feeds.count );
	
	for( NSDictionary *feed in _feeds )
	{
		[self uploadFeed:feed];
	}
	
	return self;
}

- (NSInteger)addTrip:(NSMutableDictionary *)trip
{
	NSInteger localTripId = [self localTripId];
	
	NSLog( @"새로운 여행 추가 (localTripId=%d)", localTripId );
	
	[trip setObject:[NSNumber numberWithInteger:localTripId] forKey:@"trip_id"];
	[_trips addObject:trip];
	
	// 새로운 여행이 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_TRIPS];
	[[SettingsManager manager] flush];
	
	[self uploadTrip:trip];
	
	return localTripId;
}

// 새로운 피드 추가
- (void)addFeed:(NSDictionary *)feed
{
	[_feeds addObject:feed];
	NSLog( @"새로운 피드 추가 후 업로딩 개수 : %d", _feeds.count );
	
	// 새로운 피드가 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
	
	[self uploadFeed:feed];
}

- (void)uploadTrip:(NSMutableDictionary *)trip
{
	[trip setObject:[Utils userIdNumber] forKey:@"user_id"];
	[trip setObject:[Utils email] forKey:@"email"];
	[trip setObject:[Utils password] forKey:@"password"];
	
	NSInteger localTripId = [[trip objectForKey:@"trip_id"] integerValue];
	[trip removeObjectForKey:@"trip_id"];
	
	NSLog( @"업로드 할 여행 : %@", trip );
	
	[_feedUploader loadURL:API_TRIP_ADD withData:trip andId:localTripId];
}

- (void)uploadFeed:(NSDictionary *)feed
{
	NSLog( @"피드 업로드" );
	// uploading에는 picture가 UIImagePNGRepresentation으로 직렬화되어 저장되었기 때문에 다시 풀어준다.
	UIImage *picture = [UIImage imageWithData:[feed objectForKey:@"picture"]];
	
	// 복구시킨 사진을 uploading을 복사한 NSMutableDictionary에 저장
	// uploading은 업로드중 인터넷이 끊어질 경우 다시 로컬에 저장해야 할 경우가 생길지도 모르므로 건드리지 않음.
	NSMutableDictionary *f = [NSMutableDictionary dictionaryWithDictionary:feed];
	[f setObject:picture forKey:@"picture"];
	[f setObject:[Utils userIdNumber] forKey:@"user_id"];
	[f setObject:[Utils email] forKey:@"email"];
	[f setObject:[Utils password] forKey:@"password"];
	
	NSLog( @"업로드 할 피드 : %@", f );
	
	[_feedUploader loadURLPOST:API_UPLOAD withData:f andId:0];
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (BOOL)shouldLoadWithToken:(ImTravelingLoaderToken *)token
{
	// 여행을 업로드중이면 피드 업로드를 중단한다.
	if( token.tokenId > 0 && _tripUploader.queueLength > 0 )
		return NO;
	
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
		
		// 피드 작성중 여행 업로드가 완료될 경우 작성중인 피드의 trip_id를 서버에서 로드한 trip_id로 바꿔줌
		[[(AppDelegate *)[UIApplication sharedApplication].delegate shareViewController] tripLoadingDidFinishWithTripId:tripId andLocalTripId:localTripId];
		
		// localTripId를 서버에서 받은 tripId로 수정
		for( NSMutableDictionary *feed in _feeds )
		{
			if( [[feed objectForKey:@"trip_id"] integerValue] == localTripId )
			{
				[feed setObject:[NSNumber numberWithInteger:tripId] forKey:@"trip_id"];
			}
		}
		
		// 여행 업로드가 되기 전까지 멈춰있던 피드 업로드를 계속함.
		[_feedUploader continueLoading];
	}
	
	// 피드 업로드 완료
	else
	{
		// 업로드가 완료된 피드는 제거
		[_feeds removeObjectAtIndex:0];
		NSLog( @"업로드가 완료된 업로딩 제거 후 업로딩 개수 : %d", _feeds.count );
		
		// 업로드가 완료된 피드가 제거된 배열을 로컬에 저장
		[[SettingsManager manager] setSetting:_feeds forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
		[[SettingsManager manager] flush];
	}
}


#pragma mark -
#pragma mark -

- (NSInteger)localTripId
{
//	static 
	return -1;
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
