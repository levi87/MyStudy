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

//Freebao登陆
-(void)FBRegister:(NSString *)username Password:(NSString *)password;

//Freebao获取用户信息
-(void)FBGetUserInfoWithUsetId:(NSString*)userId PassId:(NSString*)passId;

//Freebao获取微博
-(void)FBGetHomeline:(NSString*)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao获取微博new
-(void)FBGetHomelineNew:(NSString*)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

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

//Freebao Translate comment
-(void)FBGetTranslateWithBodyComment:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao Translate Voice
-(void)FBGetTranslateVoiceWithBody:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao Add Comment
-(void)FBAddAddWeiboCommentWithContentId:(NSString*)contentId CommentContent:(NSString*)content UserId:(NSString*)aUserId PassId:(NSString*)passId CommentId:(NSString*)aCommentId VoiceData:(NSData*)voiceData;

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

//Freebao Person Info
-(void)FBGetPersonInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao Person Photo
-(void)FBGetPersonPhotoWithUserId:(NSString *)aUserId PassId:(NSString *)passId;

//Freebao Person Photo upload
-(void)FBAddPersonPhotoWithUserId:(NSString*)aUserId PhotoFile:(NSData*)photoData PassId:(NSString*)passId;

//Freebao Person Photo delete
-(void)FBDeletePersonPhotoWithUserId:(NSString*)aUserId PhotoUrl:(NSString*)photoUrl PassId:(NSString*)passId;

//Freebao Follow Friend
-(void)FBFollowFriendWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId CircleId:(NSString*)circleId PassId:(NSString*)passId;

//Freebao unFollow Friend
-(void)FBunFollowFriendWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId PassId:(NSString*)passId;

//Freebao update person info
-(void)FBUpdatePersonInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId NickName:(NSString*)nickName Biography:(NSString*)biography City:(NSString*)city Email:(NSString*)email Gender:(NSString*)gender Height:(NSString*)height Weight:(NSString*)weight Birthday:(NSString*)birthday BloodType:(NSString*)bloodType Profession:(NSString*)profession Tourism:(NSString*)tourism Intersets:(NSString*)interests CountryVisited:(NSString*)countryVisited;

//Freebao update person head image
-(void)FBUpdatePersonHeaderImageWithUserId:(NSString*)aUserId FacePath:(NSString*)facePath PassId:(NSString*)passId;

//Freebao delete comment
-(void)FBDeleteMyCommentWithUserId:(NSString *)aUserId CommentId:(NSString *)commentId PassId:(NSString *)passId;

//Freebao add favorite
-(void)FBAddFavouriteWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;
//Freebao delete homeline
-(void)FBDeleteHomelineWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao report
-(void)FBReportShareWithUserId:(NSString*)aUserId ReportType:(NSString*)type ContentId:(NSString*)aContentId PassId:(NSString*)passId;
@end
