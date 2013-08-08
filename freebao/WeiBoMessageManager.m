//
//  WeiBoMessageManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"

static WeiBoMessageManager * instance=nil;

@implementation WeiBoMessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[WeiBoHttpManager alloc] initWithDelegate:self];
        [httpManager start];
    }
    return self;
}

+(WeiBoMessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[WeiBoMessageManager alloc] init];
        }
    }
    return instance;
}

#pragma mark - Http Methods

//Freebao 登陆
-(void)FBLogin:(NSString *)username Password:(NSString *)password Token:(NSString *)token {
    [httpManager didFreebaoLogin:username Password:password Token:token Platform:@"2"];
}

//Freebao 获取用户信息
-(void)FBGetUserInfoWithUsetId:(NSString *)userId PassId:(NSString *)passId{
    [httpManager didFreebaoGetUserInfoWithUserId:userId PassId:passId];
}

//Freebao 获取微博信息
-(void)FBGetHomeline:(NSString *)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetHomeline:userId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取微博信息new
-(void)FBGetHomelineNew:(NSString *)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetHomelineNew:userId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取微博评论
-(void)FBGetCommentWithHomelineId:(NSString*)StatusId StatusType:(NSString *)statusType Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetCommentWithHomelineId:StatusId StatusType:statusType Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取mentions
-(void)FBGetMentionsWithUserId:(NSString *)userId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetMentionsWithUserId:userId Page:page PageSize:pageSize PassId:passId];
}

//Freebao Like
-(void)FBAddLikeWithUserId:(NSString *)userId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    [httpManager didFreebaoLikeWithUserId:userId ContentId:aContentId PassId:passId];
}

//Freebao Unlike
-(void)FBUnLikeWithUserId:(NSString *)userId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    [httpManager didFreebaounLikeWithUserId:userId ContentId:aContentId PassId:passId];
}

//Freebao 获取Likers
-(void)FBGetLikersWithUserId:(NSString *)userUd ContentId:(NSString *)aContentId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetLikersWithUserId:userUd ContentId:aContentId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取Translate
-(void)FBGetTranslateWithBody:(NSString *)content Language:(NSString *)language PassId:(NSString *)passId {
    [httpManager didFreebaoGetTranslationWithBody:content Language:language PassId:passId];
}

//Freebao 获取Translate Voice
-(void)FBGetTranslateVoiceWithBody:(NSString *)content Language:(NSString *)language PassId:(NSString *)passId {
    [httpManager didFreebaoGetTranslationVoiceWithBoay:content Language:language PassId:passId];
}

//Freebao 增加Comment
-(void)FBAddAddWeiboCommentWithContentId:(NSString *)contentId CommentContent:(NSString *)content UserId:(NSString *)aUserId PassId:(NSString *)passId CommentId:(NSString *)aCommentId VoiceData:(NSData *)voiceData{
    [httpManager didFreebaoAddWeiboCommentWithContentId:contentId CommentContent:content UserId:aUserId PassId:passId CommentId:aCommentId VoiceData:voiceData];
}

//Freebao 获取会话列表
-(void)FBGetConversationListWithUserId:(NSString *)aUserId Page:(NSInteger)page PassId:(NSString *)passId {
    [httpManager didFreebaoGetConversationListWithUserId:aUserId Page:page PassId:passId];
}

//Freebao 设置会话语言
-(void)FBSetConversationLanguageWithUserId:(NSString *)aUserId ToUserId:(NSString *)toUserId Language:(NSString *)language PassId:(NSString *)passId {
    [httpManager didFreebaoConversationLanguageWithUserId:aUserId ToUserId:toUserId Language:language PassId:passId];
}

//Freebao 获取follow列表
-(void)FBFollowerListWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoFollowerListWithUserId:aUserId SomeBodyId:aSomeBodyId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取Fans列表
-(void)FBFansListWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoFansListWithUserId:aUserId SomeBodyId:aSomeBodyId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 发布分享
-(void)FBPostWithUserId:(NSString *)aUserId Boay:(NSString *)content AllowShare:(BOOL)isShare AllowComment:(BOOL)isComment CircleId:(NSString *)circleId Location:(NSString *)location Latitude:(NSString *)aLatitude Longgitude:(NSString *)aLonggitude FileType:(NSString *)fileType MediaFile:(NSData *)mediaData SoundFile:(NSData *)soundData PassId:(NSString *)passId {
    [httpManager didFreebaoPostWithUserId: aUserId Boay:content AllowShare:isShare
                             AllowComment:isComment CircleId:circleId Location:location Latitude:aLatitude Longgitude:aLonggitude FileType:fileType MediaFile:mediaData SoundFile:soundData PassId:passId];
}

//Freebao 获取圈子
-(void)FBGetCircleWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    [httpManager didFreebaoGetCircleWithUserId:aUserId PassId:passId];
}

//Freebao 获取用户Photo
-(void)FBGetUserPhotosWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    [httpManager didFreebaoGetUserPhotosWithUserId:aUserId SomeBodyId:aSomeBodyId Page:page PageSize:pageSize PassId:passId];
}

//Freebao 获取个人资料
-(void)FBGetPersonInfoWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    [httpManager didFreebaoGetPersonInfoWithUserId:aUserId PassId:passId];
}

//Freebao 获取个人头像
-(void)FBGetPersonPhotoWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    [httpManager didFreebaoGetPersonPhotoWithUserId:aUserId PassId:passId];
}

//Freebao 上传个人头像
-(void)FBAddPersonPhotoWithUserId:(NSString *)aUserId PhotoFile:(NSData *)photoData PassId:(NSString *)passId {
    [httpManager didFreebaoAddPersonPhotoWithUserId:aUserId PhotoFile:photoData PassId:passId];
}

//Freebao 删除个人头像
-(void)FBDeletePersonPhotoWithUserId:(NSString *)aUserId PhotoUrl:(NSString *)photoUrl PassId:(NSString *)passId {
    [httpManager didFreebaoDeletePersonPhotoWithUserId:aUserId PhotoUrl:photoUrl PassId:passId];
}

//Freebao follow Friend
-(void)FBFollowFriendWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId CircleId:(NSString *)circleId PassId:(NSString *)passId {
    [httpManager didFreebaoFollowFriendWithUserId:aUserId SomeBodyId:aSomeBodyId CircleId:circleId PassId:passId];
}

//Freebao unFollow Friend
-(void)FBunFollowFriendWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId PassId:(NSString *)passId {
    [httpManager didFreebaounFollowFriendWithUserId:aUserId SomeBodyId:aSomeBodyId PassId:passId];
}

//Freebao 更新个人资料
-(void)FBUpdatePersonInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId NickName:(NSString*)nickName Biography:(NSString*)biography City:(NSString*)city Email:(NSString*)email Gender:(NSString*)gender Height:(NSString*)height Weight:(NSString*)weight Birthday:(NSString*)birthday BloodType:(NSString*)bloodType Profession:(NSString*)profession Tourism:(NSString*)tourism Intersets:(NSString*)interests CountryVisited:(NSString*)countryVisited {
    [httpManager didFreebaoUpdatePersonInfoWithUserId:aUserId PassId:passId NickName:nickName Biography:biography City:city Email:email Gender:gender Height:height Weight:weight Birthday:birthday BloodType:bloodType Profession:profession Tourism:tourism Intersets:interests CountryVisited:countryVisited];
}

//Freebao 更新个人头像
-(void)FBUpdatePersonHeaderImageWithUserId:(NSString *)aUserId FacePath:(NSString *)facePath PassId:(NSString *)passId {
    [httpManager didFreebaoUpdatePersonHeaderImageWithUserId:aUserId FacePath:facePath PassId:passId];
}

//Freebao 删除评论
-(void)FBDeleteMyCommentWithUserId:(NSString *)aUserId CommentId:(NSString *)commentId PassId:(NSString *)passId {
    [httpManager didFreebaoDeleteMyCommentWithUserId:aUserId CommentId:commentId PassId:passId];
}

//Freebao 收藏分享
-(void)FBAddFavouriteWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    [httpManager didFreebaoAddFavouriteWithUserId:aUserId ContentId:aContentId PassId:passId];
}

//Freebao 删除分享
-(void)FBDeleteHomelineWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    [httpManager didFreebaoDeleteHomelineWithUserId:aUserId ContentId:aContentId PassId:passId];
}

//Freebao 举报微博
-(void)FBReportShareWithUserId:(NSString *)aUserId ReportType:(NSString *)type ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    [httpManager didFreebaoReportShareWithUserId:aUserId ReportType:type ContentId:aContentId PassId:passId];
}
@end
