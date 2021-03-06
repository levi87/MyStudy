//
//  Status.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Status.h"
#import "CoreDataManager.h"

@implementation Status
@synthesize statusId, createdAt, text, source, sourceUrl, favorited, truncated, longitude, latitude, inReplyToStatusId;
@synthesize inReplyToUserId, inReplyToScreenName, thumbnailPic, bmiddlePic, originalPic, user;
@synthesize commentsCount, homeLineCommentCount, retweetsCount, retweetedStatus, unread, hasReply;
@synthesize statusKey;
@synthesize hasRetwitter;
@synthesize haveRetwitterImage;
@synthesize hasImage;
@synthesize statusImage;
@synthesize cellIndexPath;
@synthesize isRefresh;
@synthesize homeLineComments;
@synthesize likeCount;
@synthesize distance;
@synthesize isPlayTransVoice = _isPlayTransVoice;
@synthesize language = _language;
@synthesize soundPath = _soundPath;
@synthesize soundLength = _soundLength;
@synthesize isFakeWeibo = _isFakeWeibo;

-(StatusCDItem*)updateStatusCDItem:(StatusCDItem*)sts index:(int)theIndex isHomeLine:(BOOL) isHome
{
    sts.bmiddlePic          = self.bmiddlePic;
    sts.language            = self.language;
    sts.soundPath           = self.soundPath;
    sts.commentsCount       = [NSNumber numberWithInt:self.commentsCount];
    sts.homeLineCommentCount= [NSNumber numberWithInt:self.homeLineCommentCount];
    sts.likeCount           = [NSNumber numberWithInt:self.likeCount];
    sts.createdAt           = self.createdAt;
    sts.favorited           = [NSNumber numberWithBool:self.favorited];
    sts.hasImage            = [NSNumber numberWithBool:self.hasImage];
    sts.hasReply            = [NSNumber numberWithBool:self.hasReply];
    sts.hasRetwitter        = [NSNumber numberWithBool:self.hasRetwitter];
    sts.haveRetwitterImage  = [NSNumber numberWithBool:self.haveRetwitterImage];
    sts.inReplyToScreenName = self.inReplyToScreenName;
    sts.inReplyToStatusId   = [NSNumber numberWithInt:self.inReplyToStatusId];
    sts.inReplyToUserId     = [NSNumber numberWithLongLong:self.inReplyToStatusId];
    sts.latitude            = [NSNumber numberWithDouble:self.latitude];
    sts.longitude           = [NSNumber numberWithDouble:self.longitude];
    sts.originalPic         = self.originalPic;
    sts.retweetsCount       = [NSNumber numberWithInt:self.retweetsCount];
    sts.source              = self.source;
    sts.sourceUrl           = self.sourceUrl;
    sts.distance            = self.distance;
    sts.statusId            = [NSNumber numberWithLongLong:self.statusId];
    sts.statusKey           = self.statusKey;
    sts.text                = self.text;
    sts.thumbnailPic        = self.thumbnailPic;
    sts.timestamp           = self.timestamp;
    sts.truncated           = [NSNumber numberWithBool:self.truncated];
    sts.unread              = [NSNumber numberWithBool:self.unread];
    sts.index               = [NSNumber numberWithInt:theIndex];
    sts.isHomeLine          = [NSNumber numberWithBool:isHome];
    sts.homeLineCommentsStr = self.homeLineComments;
    
    sts.user = (UserCDItem *)[NSEntityDescription insertNewObjectForEntityForName:@"UserCDItem" inManagedObjectContext:[CoreDataManager getInstance].managedObjContext];
    sts.user                    = [self.user updateUserCDItem:sts.user];
    
    return sts;
}

- (Status*)updataStatusFromStatusCDItem:(StatusCDItem*)sts
{
    self.bmiddlePic         = sts.bmiddlePic;
    self.language           = sts.language;
    self.soundPath          = sts.soundPath;
    self.commentsCount      = sts.commentsCount.intValue;
    self.homeLineCommentCount= sts.homeLineCommentCount.intValue;
    self.likeCount          = sts.likeCount.intValue;
    self.createdAt          = sts.createdAt;
    self.favorited          = sts.favorited.boolValue;
    self.hasImage           = sts.hasImage.boolValue;
    self.hasReply           = sts.hasReply.boolValue;
    self.hasRetwitter       = sts.hasRetwitter.boolValue;
    self.haveRetwitterImage = sts.haveRetwitterImage.boolValue;
    self.inReplyToScreenName = sts.inReplyToScreenName;
    self.inReplyToStatusId  = sts.inReplyToStatusId.longLongValue;
    self.inReplyToUserId    = sts.inReplyToUserId.intValue;
    self.latitude           = sts.latitude.doubleValue;
    self.longitude          = sts.longitude.doubleValue;
    self.originalPic        = sts.originalPic;
    self.retweetsCount      = sts.retweetsCount.intValue;
    self.source             = sts.source;
    self.sourceUrl          = sts.sourceUrl;
    self.distance           = sts.distance;
    self.statusId           = sts.statusId.longLongValue;
    self.statusKey          = sts.statusKey;
    self.text               = sts.text;
    self.thumbnailPic       = sts.thumbnailPic;
//    self.timestamp          = sts.timestamp;
    self.truncated          = sts.truncated.boolValue;
    self.unread             = sts.unread.boolValue;
    self.homeLineComments   = sts.homeLineCommentsStr;
    if (sts.retweetedStatus) {
        self.retweetedStatus = [self updataStatusFromStatusCDItem:sts.retweetedStatus];
    }
    
    User *us = [[User alloc] init];
    self.user = [us updateUserFromUserCDItem:sts.user];
    
    return self;
}


- (Status*)initWithJsonDictionary:(NSDictionary*)dic {
	if (self = [super init]) {
		statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		statusKey = [[NSNumber alloc]initWithLongLong:statusId];
		createdAt = [dic getStringValueForKey:@"created_at" defaultValue:@"0"];
		text = [dic getStringValueForKey:@"text" defaultValue:@""];
		
		// parse source parameter
		NSString *src = [dic getStringValueForKey:@"source" defaultValue:@""];
		NSRange r = [src rangeOfString:@"<a href"];
		NSRange end;
		if (r.location != NSNotFound) {
			NSRange start = [src rangeOfString:@"<a href=\""];
			if (start.location != NSNotFound) {
				int l = [src length];
				NSRange fromRang = NSMakeRange(start.location + start.length, l-start.length-start.location);
				end   = [src rangeOfString:@"\"" options:NSCaseInsensitiveSearch 
											 range:fromRang];
				if (end.location != NSNotFound) {
					r.location = start.location + start.length;
					r.length = end.location - r.location;
					self.sourceUrl = [src substringWithRange:r];
				}
				else {
					self.sourceUrl = @"";
				}
			}
			else {
				self.sourceUrl = @"";
			}			
			start = [src rangeOfString:@"\">"];
			end   = [src rangeOfString:@"</a>"];
			if (start.location != NSNotFound && end.location != NSNotFound) {
				r.location = start.location + start.length;
				r.length = end.location - r.location;
				self.source = [src substringWithRange:r];
			}
			else {
				self.source = @"";
			}
		}
		else {
			self.source = src;
		}
		
		favorited = [dic getBoolValueForKey:@"favorited" defaultValue:NO];
		truncated = [dic getBoolValueForKey:@"truncated" defaultValue:NO];
		
		NSDictionary* geoDic = [dic objectForKey:@"geo"];
		if (geoDic && [geoDic isKindOfClass:[NSDictionary class]]) {
			NSArray *coordinates = [geoDic objectForKey:@"coordinates"];
			if (coordinates && coordinates.count == 2) {
				longitude = [[coordinates objectAtIndex:0] doubleValue];
				latitude = [[coordinates objectAtIndex:1] doubleValue];
			}
		}
		
		inReplyToStatusId = [dic getLongLongValueValueForKey:@"in_reply_to_status_id" defaultValue:-1];
		inReplyToUserId = [dic getIntValueForKey:@"in_reply_to_user_id" defaultValue:-1];
		inReplyToScreenName = [dic getStringValueForKey:@"in_reply_to_screen_name" defaultValue:@""];
		thumbnailPic = [dic getStringValueForKey:@"thumbnail_pic" defaultValue:@""];
		bmiddlePic = [dic getStringValueForKey:@"bmiddle_pic" defaultValue:@""];
		originalPic = [dic getStringValueForKey:@"original_pic" defaultValue:@""];
		
        commentsCount = [dic getIntValueForKey:@"comments_count" defaultValue:-1];
        retweetsCount = [dic getIntValueForKey:@"reposts_count" defaultValue:-1];
        
		NSDictionary* userDic = [dic objectForKey:@"user"];
		if (userDic) {
			user = [User userWithJsonDictionary:userDic];
		}
		
		NSDictionary* retweetedStatusDic = [dic objectForKey:@"retweeted_status"];
		if (retweetedStatusDic) {
			self.retweetedStatus = [Status statusWithJsonDictionary:retweetedStatusDic];
            
            //有转发的博文
            if (retweetedStatus && ![retweetedStatus isEqual:[NSNull null]])
            {
                hasRetwitter = YES;
                
                NSString *url = retweetedStatus.thumbnailPic;
                haveRetwitterImage = (url != nil && [url length] != 0 ? YES : NO);
            }
		}
        //无转发
        else 
        {
//            hasRetwitter = NO;
//            NSString *url = thumbnailPic;
//            hasImage = (url != nil && [url length] != 0 ? YES : NO);
        }
	}
	return self;
}

- (Status*)initWithJsonDictionaryFreebao:(NSDictionary *)dic {
	if (self = [super init]) {
        _isFakeWeibo = FALSE;
        _isPlayTransVoice = FALSE;
        _language = [dic getStringValueForKey:@"post_language" defaultValue:@"0"];
        NSDictionary *soundDic = [dic objectForKey:@"sound"];
        _soundPath = [soundDic getStringValueForKey:@"soundPath" defaultValue:@""];
        _soundLength = [soundDic getStringValueForKey:@"soundTime" defaultValue:@"0"];
		statusId = [dic getLongLongValueValueForKey:@"contentId" defaultValue:-1];
		statusKey = [[NSNumber alloc]initWithLongLong:statusId];
		createdAt = [dic getStringValueForKey:@"create_at" defaultValue:@""];
		text = [dic getStringValueForKey:@"text" defaultValue:@""];
        self.sourceUrl = [dic getStringValueForKey:@"sourceImage" defaultValue:@""];
        commentsCount = [dic getIntValueForKey:@"comment_count" defaultValue:0];
        likeCount = [dic getIntValueForKey:@"like_count" defaultValue:0];
        distance = [dic getStringValueForKey:@"distance" defaultValue:@"0"];
        int isLiked = [dic getIntValueForKey:@"liked" defaultValue:0];
        if (isLiked == 0) {
            favorited = FALSE;
        } else if (isLiked == 1) {
            favorited = TRUE;
        }
        NSArray *aa = [dic objectForKey:@"comments"];
        homeLineComments = aa;
		
		// parse source parameter
		NSString *src = [dic getStringValueForKey:@"platform" defaultValue:@""];
        
        NSString *tmpStr = [dic getStringValueForKey:@"original_pic" defaultValue:@"blank"];
//        NSLog(@"[TEST] %@",tmpStr);
        if (![[NSString stringWithFormat:@"%@", tmpStr] isEqualToString:@"blank"]) {
            hasImage = TRUE;
            thumbnailPic = [dic getStringValueForKey:@"original_pic" defaultValue:@""];
            bmiddlePic = [dic getStringValueForKey:@"original_pic" defaultValue:@""];
            originalPic = [dic getStringValueForKey:@"original_pic" defaultValue:@""];
        } else {
            NSString *tmpVO = [dic getStringValueForKey:@"postVO" defaultValue:@"blank"];
//            NSLog(@"[TEST] 111%@",tmpVO);
            if (![[NSString stringWithFormat:@"%@", tmpVO] isEqualToString:@"blank"]) {
                hasImage = TRUE;
                NSDictionary *tmpOri = [dic objectForKey:@"postVO"];
                NSString *tmpO = [tmpOri getStringValueForKey:@"original_pic" defaultValue:@"blank"];
                if(![[NSString stringWithFormat:@"%@", tmpO] isEqualToString:@"blank"]) {
                    hasImage = TRUE;
                } else {
                    hasImage = FALSE;
                }
            } else {
                hasImage = FALSE;
            }
        }
        self.source = src;

        longitude = [[dic getStringValueForKey:@"longgitude" defaultValue:@"0"] doubleValue];
        latitude = [[dic getStringValueForKey:@"latitude" defaultValue:@"0"] doubleValue];
        //			}
        //		}
		
		inReplyToStatusId = [dic getLongLongValueValueForKey:@"in_reply_to_status_id" defaultValue:-1];
		inReplyToUserId = [dic getIntValueForKey:@"in_reply_to_user_id" defaultValue:-1];
		inReplyToScreenName = [dic getStringValueForKey:@"in_reply_to_screen_name" defaultValue:@""];
        retweetsCount = [dic getIntValueForKey:@"zftimes" defaultValue:-1];

        user = [[User alloc] init];
        user.screenName = [dic getStringValueForKey:@"user_name" defaultValue:@""];
        user.userId = [[dic getStringValueForKey:@"user_id" defaultValue:@"0"] integerValue];
        user.profileImageUrl = [dic getStringValueForKey:@"user_face_path" defaultValue:@""];
		
		NSDictionary* retweetedStatusDic = [dic objectForKey:@"content"];
        if ([NSJSONSerialization isValidJSONObject:[dic objectForKey:@"content"]]) {
			self.retweetedStatus = [Status statusWithJsonDictionaryFreebao:retweetedStatusDic];

            //有转发的博文
            if (retweetedStatus && ![retweetedStatus isEqual:[NSNull null]])
            {
                hasRetwitter = YES;
                
                NSString *url = retweetedStatus.thumbnailPic;
                haveRetwitterImage = (url != nil && [url length] != 0 ? YES : NO);
            }
        }
        //无转发
        else
        {
        }
	}
	return self;
}

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic
{
	return [[Status alloc] initWithJsonDictionary:dic];
}

+ (Status*)statusWithJsonDictionaryFreebao:(NSDictionary *)dic
{
    return [[Status alloc] initWithJsonDictionaryFreebao:dic];
}


//- (NSString*)timestamp
//{
//	NSString *_timestamp;
//    // Calculate distance time string
//    //
//    time_t now;
//    time(&now);
//    
//    int distance = (int)difftime(now, createdAt);
//    if (distance < 0) distance = 0;
//    
//    if (distance < 60) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
//    }
//    else if (distance < 60 * 60) {  
//        distance = distance / 60;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
//    }  
//    else if (distance < 60 * 60 * 24) {
//        distance = distance / 60 / 60;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
//    }
//    else if (distance < 60 * 60 * 24 * 7) {
//        distance = distance / 60 / 60 / 24;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
//    }
//    else if (distance < 60 * 60 * 24 * 7 * 4) {
//        distance = distance / 60 / 60 / 24 / 7;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
//    }
//    else {
//        static NSDateFormatter *dateFormatter = nil;
//        if (dateFormatter == nil) {
//            dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        }
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
//        _timestamp = [dateFormatter stringFromDate:date];
//    }
//    return _timestamp;
//}


- (void)dealloc {
}






@end
