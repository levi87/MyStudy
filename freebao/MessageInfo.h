//
//  MessageInfo.h
//  freebao
//
//  Created by freebao on 13-7-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject {
    NSString *_rowId;
    NSString *_fromId;
    NSString *_isSelf;
    NSString *_nickName;
    NSString *_date;
    NSString *_facePath;
    NSString *_voiceTime;
    NSString *_fail;
    NSString *_body;
    NSString *_language;
    NSString *_postType;
    NSData   *_data;
}

@property (nonatomic, retain) NSString *rowId;
@property (nonatomic, retain) NSString *fromId;
@property (nonatomic, retain) NSString *isSelf;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *facePath;
@property (nonatomic, retain) NSString *voiceTime;
@property (nonatomic, retain) NSString *fail;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *postType;
@property (nonatomic, retain) NSData   *data;

@end
