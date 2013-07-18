//
//  WeiBoMessageManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoHttpManager.h"
#import "ZJTStatusBarAlertWindow.h"

@interface WeiBoMessageManager : NSObject <WeiBoHttpDelegate>
{
    WeiBoHttpManager *httpManager;
}
@property (nonatomic,retain)WeiBoHttpManager *httpManager;

+(WeiBoMessageManager*)getInstance;

//Freebao登陆
-(void)FBLogin:(NSString*)username Password:(NSString*)password Token:(NSString*)token;

//Freebao获取用户信息
-(void)FBGetUserInfoWithUsetId:(NSString*)userId PassId:(NSString*)passId;

//Freebao获取微博
-(void)FBGetHomeline:(NSString*)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao获取微博评论
-(void)FBGetCommentWithHomelineId:(NSString*)StatusId StatusType:(NSString*)statusType Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao获取mentions
-(void)FBGetMentionsWithUserId:(NSString*)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao Like
-(void)FBAddLikeWithUserId:(NSString*)userId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao unLike
-(void)FBUnLikeWithUserId:(NSString*)userId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao Likers
-(void)FBGetLikersWithUserId:(NSString*)userUd ContentId:(NSString*)aContentId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao Translate
-(void)FBGetTranslateWithBody:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao Translate Voice
-(void)FBGetTranslateVoiceWithBody:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao Add Comment
-(void)FBAddAddWeiboCommentWithContentId:(NSString*)contentId CommentContent:(NSString*)content UserId:(NSString*)aUserId PassId:(NSString*)passId CommentId:(NSString*)aCommentId;
@end
