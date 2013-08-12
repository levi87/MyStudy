//
//  PeopleMayKnowInfo.h
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleMayKnowInfo : NSObject {
    NSString *_userName;
    NSString *_userId;
    NSString *_userFacePath;
    NSString *_age;
    NSString *_sex;
    NSString *_isFriend;
}

@property NSString *userName;
@property NSString *userId;
@property NSString *userFacePath;
@property NSString *age;
@property NSString *sex;
@property NSString *isFriend;
@end
