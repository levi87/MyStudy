//
//  FansInfo.h
//  freebao
//
//  Created by freebao on 13-7-24.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansInfo : NSObject {
    NSString *_userName;
    NSString *_userId;
    NSString *_userFacePath;
}

@property NSString *userName;
@property NSString *userId;
@property NSString *userFacePath;

@end
