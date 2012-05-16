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
	
	_loader = [[ImTravelingLoader alloc] init];
	_loader.delegate = self;
//	[[SettingsManager manager] clearSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS]; [[SettingsManager manager] flush];
	// 로컬에 저장되어있는 피드 불러와서 업로드 큐에 저장
	_uploadings = [[NSMutableArray alloc] initWithArray:[[SettingsManager manager] getSettingForKey:SETTING_KEY_LOCAL_SAVED_FEEDS]];
	NSLog( @"로컬에 저장된 피드 개수 : %d개", _uploadings.count );
	
	for( NSDictionary *uploading in _uploadings )
	{
		[self upload:uploading];
	}
	
	return self;
}

// 새로운 피드 업로드
- (void)addUploading:(NSDictionary *)uploading
{
	[_uploadings addObject:uploading];
	NSLog( @"새로운 업로딩 추가 후 업로딩 개수 : %d", _uploadings.count );
	
	// 새로운 피드가 추가된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_uploadings forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
	
	[self upload:uploading];
}

- (void)upload:(NSDictionary *)uploading
{
	NSLog( @"업로드" );
	// uploading에는 picture가 UIImagePNGRepresentation으로 직렬화되어 저장되었기 때문에 다시 풀어준다.
	UIImage *picture = [UIImage imageWithData:[uploading objectForKey:@"picture"]];
	
	// 복구시킨 사진을 uploading을 복사한 NSMutableDictionary에 저장
	// uploading은 업로드중 인터넷이 끊어질 경우 다시 로컬에 저장해야 할 경우가 생길지도 모르므로 건드리지 않음.
	NSMutableDictionary *feed = [NSMutableDictionary dictionaryWithDictionary:uploading];
	[feed setObject:picture forKey:@"picture"];
	[feed setObject:[Utils userIdNumber] forKey:@"user_id"];
	[feed setObject:[Utils email] forKey:@"email"];
	[feed setObject:[Utils password] forKey:@"password"];
	
	NSLog( @"업로드 할 피드 : %@", feed );
	
	[_loader loadURLPOST:API_UPLOAD withData:feed andId:0];
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSLog( @"업로드 결과 : %@", token.data );
	
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [[json objectForKey:@"status"] integerValue] == 0 )
	{
		NSLog( @"업로드 에러" );
		return;
	}
	
	// 업로드가 완료된 피드는 제거
	[_uploadings removeObjectAtIndex:0];
	NSLog( @"업로드가 완료된 업로딩 제거 후 업로딩 개수 : %d", _uploadings.count );
	
	// 업로드가 완료된 피드가 제거된 배열을 로컬에 저장
	[[SettingsManager manager] setSetting:_uploadings forKey:SETTING_KEY_LOCAL_SAVED_FEEDS];
	[[SettingsManager manager] flush];
}


#pragma mark -
#pragma mark Getter

- (NSInteger)numUploadings
{
	return _uploadings.count;
}

@end
