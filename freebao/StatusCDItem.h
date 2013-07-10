//
//  StatusCDItem.h
//  freebao
//
//  Created by freebao on 13-7-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusCDItem, UserCDItem;

@interface StatusCDItem : NSManagedObject

@property (nonatomic, retain) NSString * bmiddlePic;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * hasImage;
@property (nonatomic, retain) NSNumber * hasReply;
@property (nonatomic, retain) NSNumber * hasRetwitter;
@property (nonatomic, retain) NSNumber * haveRetwitterImage;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * inReplyToScreenName;
@property (nonatomic, retain) NSNumber * inReplyToStatusId;
@property (nonatomic, retain) NSNumber * inReplyToUserId;
@property (nonatomic, retain) NSNumber * isHomeLine;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * originalPic;
@property (nonatomic, retain) NSNumber * retweetsCount;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSNumber * statusId;
@property (nonatomic, retain) NSNumber * statusKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnailPic;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSNumber * homeLineCommentCount;
@property (nonatomic, retain) id homeLineCommentsStr;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) StatusCDItem *retweetedStatus;
@property (nonatomic, retain) UserCDItem *user;

@end
