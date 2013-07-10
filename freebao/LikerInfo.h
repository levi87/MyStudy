//
//  LikerInfo.h
//  freebao
//
//  Created by levi on 13-7-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikerInfo : NSObject {
    NSString *_nickName;
    NSString *_sex;
    NSString *_age;
    NSString *_city;
}

@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *city;

@end
