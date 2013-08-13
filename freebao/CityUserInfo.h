//
//  CityUserInfo.h
//  freebao
//
//  Created by freebao on 13-8-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityUserInfo : NSObject {
    NSString *_userName;
    NSString *_userId;
    NSString *_userFacePath;
}

@property NSString *userName;
@property NSString *userId;
@property NSString *userFacePath;

@end
