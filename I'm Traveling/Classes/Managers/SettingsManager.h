//
//  SettingsManager.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 22..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject
{
	NSMutableDictionary *_settings;
}

+ (SettingsManager *)manager;

- (id)getSettingForKey:(NSString *)key;
- (void)setSetting:(id)data forKey:(NSString *)key;
- (BOOL)flush;

@end
