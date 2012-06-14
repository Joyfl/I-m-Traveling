//
//  FacebookManager.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 6. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookManager : NSObject <FBSessionDelegate, FBRequestDelegate>
{
	Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

+ (FacebookManager *)manager;

- (void)makeAlbumWithName:(NSString *)name andDescription:(NSString *)desc;
- (void)postPhoto;

- (BOOL)connected;


@end
