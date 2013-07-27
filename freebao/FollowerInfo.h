//
//  FollowerInfo.h
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowerInfo : NSObject {
    NSString *_userName;
    NSString *_userId;
    NSString *_userFacePath;
}

@property NSString *userName;
@property NSString *userId;
@property NSString *userFacePath;

@end
