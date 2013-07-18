//
//  CommentInfo.h
//  freebao
//
//  Created by freebao on 13-7-11.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject {
    NSString *_nickName;
    NSString *_content;
    NSString *_voiceUrl;
    NSString *_languageType;
}

@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *voiceUrl;
@property (nonatomic, retain) NSString *languageType;
@end
