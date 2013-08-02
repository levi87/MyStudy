//
//  StatusInfo.h
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusInfo : NSObject {
    NSString *_originalPicUrl;
    NSString *_commentCount;
    NSString *_createAt;
    NSString *_distance;
    NSString *_likeCount;
    NSString *_liked;
    NSString *_postLanguage;
    NSString *_content;
    NSString *_userFacePath;
    NSString *_userId;
    NSString *_userName;
    NSDictionary *_soundDic;
    NSDictionary *_rePostDic;
    NSMutableArray *_commentArray;
    NSString *_contentId;
    
    BOOL _isPlayingVoice;
    BOOL _isPlayingSound;
}

@property (nonatomic) NSString *originalPicUrl;
@property (nonatomic) NSString *commentCount;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *distance;
@property (nonatomic) NSString *likeCount;
@property (nonatomic) NSString *liked;
@property (nonatomic) NSString *postLanguage;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *userFacePath;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSDictionary *soundDic;
@property (nonatomic) NSDictionary *rePostDic;
@property (nonatomic) NSMutableArray *commentArray;
@property (nonatomic) NSString *contentId;

@property (nonatomic) BOOL isPlayingVoice;
@property (nonatomic) BOOL isPlayingSound;

@end
