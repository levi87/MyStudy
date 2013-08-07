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
    NSString *_voiceLength;
    NSString *_languageType;
    NSString *_contentId;
    NSString *_commentId;
    NSString *_commentDate;
    NSString *_commentUserId;
    BOOL _isPlayingVoice;
    BOOL _isPlayingSound;
}

@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *voiceUrl;
@property (nonatomic, retain) NSString *voiceLength;
@property (nonatomic, retain) NSString *languageType;
@property (nonatomic, retain) NSString *contentId;
@property (nonatomic, retain) NSString *commentId;
@property (nonatomic, retain) NSString *commentDate;
@property (nonatomic, retain) NSString *commentUserId;
@property (nonatomic) BOOL isPlayingVoice;
@property (nonatomic) BOOL isPlayingSound;
@end
