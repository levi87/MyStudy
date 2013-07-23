//
//  ProfileInfo.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfo : NSObject {
    NSString *_userId;
    NSString *_userAge;
    NSString *_userSex;
    NSString *_userCountry;
    NSString *_facePath;
    NSString *_describe;
    NSString *_userName;
    NSString *_userBirthday;
    NSString *_userHeight;
    NSString *_userWeight;
    NSString *_bloodType;
    NSString *_constellation;
    NSString *_country;
    NSString *_occupation;
    NSString *_interests;
    NSString *_countriesVisited;
    NSString *_travelingPlans;
}

@property NSString *userId;
@property NSString *userAge;
@property NSString *userSex;
@property NSString *userCountry;
@property NSString *facePath;
@property NSString *describe;
@property NSString *userName;
@property NSString *userBirthday;
@property NSString *userHeight;
@property NSString *userWeight;
@property NSString *bloodType;
@property NSString *constellation;
@property NSString *country;
@property NSString *occupation;
@property NSString *interests;
@property NSString *countriesVisited;
@property NSString *travelingPlans;
@end
