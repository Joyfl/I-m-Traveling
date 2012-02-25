//
//  Utils.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface Utils : NSObject

+ (BOOL)loggedIn;
+ (NSString *)getHtmlFromUrl:(NSString *)url;
+ (id)parseJSON:(NSString *)json;

@end
