//
//  UserCDItem.h
//  freebao
//
//  Created by freebao on 13-7-8.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserCDItem : NSManagedObject

@property (nonatomic, retain) NSNumber * allowAllActMsg;
@property (nonatomic, retain) NSData * avatarImage;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSNumber * friendsCount;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * geoEnabled;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileImageUrl;
@property (nonatomic, retain) NSString * profileLargeImageUrl;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSNumber * statusesCount;
@property (nonatomic, retain) NSString * theDescription;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * userKey;
@property (nonatomic, retain) NSNumber * verified;

@end
