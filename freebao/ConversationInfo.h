//
//  ConversationInfo.h
//  freebao
//
//  Created by freebao on 13-7-19.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationInfo : NSObject {
    NSString *_fromUserName;
    NSString *_fromUid;
    NSString *_date;
    NSString *_fromUserFace;
    NSString *_content;
}

@property (nonatomic, retain) NSString *fromUserName;
@property (nonatomic, retain) NSString *fromUid;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *fromUserFace;
@property (nonatomic, retain) NSString *content;

@end
