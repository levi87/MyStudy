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

//Freebao Get Conversation
-(void)FBGetConversationListWithUserId:(NSString*)aUserId Page:(NSInteger)page PassId:(NSString*)passId;

//Freebao set Conversation Language
-(void)FBSetConversationLanguageWithUserId:(NSString*)aUserId ToUserId:(NSString*)toUserId Language:(NSString*)language PassId:(NSString*)passId;

//Freebao get follower list
-(void)FBFollowerListWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao get fans list
-(void)FBFansListWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao post
-(void)FBPostWithUserId:(NSString *)aUserId Boay:(NSString *)content AllowShare:(BOOL)isShare AllowComment:(BOOL)isComment CircleId:(NSString *)circleId Location:(NSString *)location Latitude:(NSString *)aLatitude Longgitude:(NSString *)aLonggitude FileType:(NSString *)fileType MediaFile:(NSData *)mediaData SoundFile:(NSData *)soundData PassId:(NSString *)passId;

//Freebao Circle
-(void)FBGetCircleWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao Photo
-(void)FBGetUserPhotosWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;
@end
