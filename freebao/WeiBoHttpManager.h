//
//  WeiBoHttpManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"
#import "POI.h"
#import <CoreLocation/CoreLocation.h>

#define USER_INFO_KEY_TYPE          @"requestType"

#define USER_OBJECT                 @"USER_OBJECT"
#define NeedToReLogin               @"NeedToReLogin"

#define MMSinaRequestFailed         @"MMSinaRequestFailed"

/*
 Freebao
 */
#define FB_PASS_ID                  @"passId"
#define FB_PASSWORD_KEY             @"passwordKey"
#define FB_USER_ID                  @"userId"
#define FB_REMEMBER                 @"remember"
#define FB_AUTOLOGIN                @"autologin"
#define FB_USER_NAME                @"username"
#define FB_USER_PASSWORD            @"password"
#define FB_USER_NICK_NAME           @"nickname"
#define FB_USER_FACE_PATH           @"facepath"
#define FB_LOGIN_STATUS             @"loginStatus"
#define FB_LOGIN                    @"login"
#define FB_LOGOFF                   @"logoff"

//FB_NOTIFICATION

#define FB_NOTIC_LOGIN_SUCCESS      @"fb_login_success"
#define FB_NOTIC_LOGIN_FAILED       @"fb_login_failed"

#define FB_NOTIC_REGISTER_SUCCESS      @"fb_register_success"
#define FB_NOTIC_REGISTER_FAILED       @"fb_register_failed"

//FB_HOMELINE
#define FB_GET_HOMELINE             @"fb_get_homeline"
#define FB_GET_HOMELINE_NEW         @"fb_get_homeline_new"
#define FB_GET_USERINFO             @"fb_get_userinfo"
#define FB_GET_UNREAD_COUNT         @"fb_get_unread_count"
#define FB_GET_COMMENT              @"fb_get_comment"
#define FB_GET_MENTION              @"fb_get_mention"
#define FB_ADD_LIKE                 @"fb_add_like"
#define FB_UN_LIKE                  @"fb_un_like"
#define FB_GET_LIKERS               @"fb_get_likers"
#define FB_GET_TRANSLATION          @"fb_get_translation"
#define FB_GET_TRANSLATION_FAIL     @"fb_get_translation_fail"
#define FB_GET_TRANSLATION_VOICE    @"fb_get_translation_voice"
#define FB_ADD_COMMENT              @"fb_add_comment"
#define FB_GET_CONVERSATION         @"fb_get_conversation"
#define FB_SET_CONVERSATION_LANGUAGE @"fb_set_conversation_language"
#define FB_GET_FOLLOWER_LIST        @"fb_get_follow_list"
#define FB_GET_FANS_LIST            @"fb_get_fans_list"
#define FB_GET_CIRCLE               @"fb_get_circle"
#define FB_GET_PHOTO_LIST           @"fb_get_photo_list"
#define FB_GET_PERSON_INFO          @"fb_get_person_info"
#define FB_UPLOAD_PHOTO_HEAD_IMAGE  @"fb_upload_head_image"
#define FB_UPLOAD_PHOTO_RERESH      @"fb_upload_photo_refresh"
#define FB_UPDATE_PERSONALDIC      @"update_Personal_Dic"


#define FB_POST_SUCCESS             @"fb_post_success"


/*
 Freebao
 */
#define kDefaultRequestPageSize         20
//测试环境
#define kHostUrl                        @"http://t.freebao.com/"
#define kRegisterUrl                    @"http://t.freebao.com"
#define CItMessageUrl                   @"t.freebao.com"
#define CityMessage                     @"@t.freebao.com"

//正式环境
//#define kHostUrl                        @"http://m.freebao.com/"
//#define kRegisterUrl                    @"http://m.freebao.com"
//#define CItMessageUrl                   @"m.freebao.com"
//#define CityMessage                     @"@m.freebao.com"

//推送
#define kpushUrl                         kHostUrl@"apple/setToken.html"
#define kyaoqingUrel                    kHostUrl@"invite/sendCommon.html"
#define khostHelpUrl                     kHostUrl@"helpComment/"
#define kkkkkk                          kHostUrl@"help/"
//头像信息
#define kgetfaceUrl                      kHostUrl@"userInfo/getUserFaces.html"
//删除头像
#define kdeleteface                      kHostUrl@"userInfo/deleteFace.html"
//增加头像
#define kaddfaceUrl                      kHostUrl@"userInfo/uploadFace.html"
//查找音乐微博
#define kfindMussicUrl                   kHostUrl@"index/findMusic.html"
//查找声音weibo
#define kfindVoiceUrl                   kHostUrl@"index/findSound.html"
//查找Pic微博
#define kfindPicUrl                     kHostUrl@"index/findPicture.html"
//查找FBgirls微博
#define kfindGirlsUrl                   kHostUrl@"index/findFbGirls.html"
//注册
#define kRegUrl                         kHostUrl@"login/registUser.html"
//声音播放次数
#define kPlayTimesUrl                   kHostUrl@"sound/playSound.html"
//忘记密码
#define kForgotEmailUrl                 @"http://www.freebao.com/indexAjax/processSendEmail.html"
//获取离线消息
#define kGetDownMessageUrl              kHostUrl"message/findOffLineMessage.html"
// message翻译    translatorAjax/getMesageTransText.html
#define kGetMessageTrans                kHostUrl"translatorAjax/getMesageTransText.html"
#define kGetMessageTransVoice                kHostUrl"translatorAjax/getTextVoice.html"

// message翻译设置请求    translatorAjax/addChatLanguage.html
#define kGetMessageTransSet                kHostUrl"chatLanguage/addChatLanguage.html"
// message翻译取消请求    translatorAjax/cancleChatLanguage.html
#define kGetMessageTransCancle                kHostUrl"chatLanguage/cancleChatLanguage.html"
//获取聊天城市
#define kGetChatCityUrl                 kHostUrl"instance/findCitys.html"
//获取城市用户列表
#define kGetChatCityUserUrl                 kHostUrl"instance/findLocaUserByCity.html"
//验证邮箱是否存在
#define kIfEmaldressUrl                 kHostUrl"login/checkLogName.html"
//获取相册
#define kGetUserPicListUrl               kHostUrl"content/findUserPic.html"


//删除评论
#define Kdeleatecomment                      kHostUrl@"comment/deleteComment.html"
//删除帮助评论
#define Kdeleatehelpcomment                   kHostUrl@"helpComment/deleteHelpComment.html"
//帮助广场

#define KLikeUrl                        kHostUrl@"likeAjax/addLike.html"//喜欢like
#define KDeletLikeUrl                   kHostUrl@"likeAjax/deleteLike.html"//取消
#define KLikeUserUrl                    kHostUrl@"likeAjax/getLikeUsers.html"//like用户
#define KContentUrl                     kHostUrl@"translatorAjax/getContentTransText.html"//翻译

#define KContentHelpUrl                 kHostUrl@"translatorAjax/getHelpTransText.html"
//帮助翻译 http://t.freebao.com/translatorAjax/getHelpTransText.html
#define KHelplistUrl                    kHostUrl@"help/listHelp.html"   //帮助大厅
#define KCreatehelpUrl                  kHostUrl@"help/createHelp.html"//发布帮助
#define KSharehelpUrl                   kHostUrl@"help/shareHelp.html"//转发
#define KFindhelpUrl                    kHostUrl@"help/listHelp.html"//查询
#define KcatchtokeUrl                   khostHelpUrl@"findComment.html"//查询帮助评论列表
#define KaddHelpCommentUrl              khostHelpUrl@"addHelpComment.html"//添加帮助评论
#define KDeletehelpUrl                  kkkkkk@"deleteHelp.html"//删除帮助
#define kLoginUrl                       kHostUrl@"login/login.html"
#define kLogoutUrl                      kHostUrl@"login/logout.html"
#define kRequestCirclesUrl              kHostUrl@"team/findUserTeams.html"
#define kRequestTimeLinesUrl            kHostUrl@"content/findFriendsPost.html"
#define kRequestConversationListUrl     kHostUrl@"message/findChatRecordList.html"
#define kRequestRecommendedUsers        kHostUrl@"clientUser/recommendFriendList.html"
#define kRequestFriendsUrl              kHostUrl@"friend/followList.html"
#define KFollowUrl                      kHostUrl@"friend/followFriend.html"
#define kCancelFollowUrl                kHostUrl@"friend/cancleFollowFriend.html"
#define kRequestFollowersUrl            kHostUrl@"friend/fansList.html"
#define kRequestFavouriteTimelines      kHostUrl@"favorite/findMyFavorites.html"
#define kAddFavouriteTimeline           kHostUrl@"favorite/addFavorite.html"
#define kDeleteFavouriteTimeline        kHostUrl@"favorite/deleteFavorite.html"
#define kRequestUserInfoUrl             kHostUrl@"userInfo/getUserInfo.html"
#define kRequestUserProfile             kHostUrl@"userInfo//profile.html"
#define KUpdateUserInfoUrl              kHostUrl@"userInfo/updateBasicInfo.html"
#define kUpdateUserHeaderImageUrl       kHostUrl@"userInfo/updateFace.html"
#define kPostUrl                        kHostUrl@"content/createContent.html"
#define kRepostUrl                      kHostUrl@"content/shareContentToTeam.html"
#define kAddCommentUrl                  kHostUrl@"comment/addComment.html"
#define kRequestFriendTimeLinesUrl      kHostUrl@"content/findFriendContent.html"
#define kRequestCommentsToTimelineUrl   kHostUrl@"comment/commentList.html"
#define kRequestCommentsUrl             kHostUrl@"comment/myCommentList.html"    // 获取对我的评论列表
#define kRequestTimelineUrl             kHostUrl@"content/findContentById.html"
#define kDeleteTimelineUrl              kHostUrl@"content/deleteContent.html"
#define kRequestMyRepliesUrl            kHostUrl@"clientContent/findReplyedMe.html"   // 是回复我的列表


#define kSearchFanUsersUrl              kHostUrl@"clientUser/searchFansByNickname.html"
#define kSearchFollowUsersUrl           kHostUrl@"clientUser/searchFollowsByNickname.html"
#define kSearchIdUsersUrl               kHostUrl@"clientUser/searchUserById.html"
#define kSearchUsersUrl                 kHostUrl@"clientUser/searchUserList.html"
#define kSearchTimelinesUrl             kHostUrl@"content/searchContentList.html"
#define kRequestSentMessagesUrl         kHostUrl@"message/listSendMessages.html"
#define kRequestReceivedMessagesUrl     kHostUrl@"message/listReceiveMessages.html"
#define kDeleteSentMessageUrl           kHostUrl@"message/deleteSendMessage.html"
#define kDeleteReceivedMessageUrl       kHostUrl@"message/deleteReceiveMessage.html"
#define kSendMessageUrl                 kHostUrl@"message/addMessage.html"

#define kRequestStarsUrl                kHostUrl@"index/hotPeoples.html"
#define kRequestRandomStatusesUrl       kHostUrl@"index/viewContent.html"
#define kRequestHotStatusesUrl          kHostUrl@"index/hotContents.html"

#define kRequestCirclesWithUsersUrl     kHostUrl@"team/teamManager.html"
#define kAddCircleUrl                   kHostUrl@"team/addTeam.html"
#define kDeleteCircleUrl                kHostUrl@"team/deleteTeam.html"
#define kUpdateCircleUrl                kHostUrl@"team/updateTeam.html"
#define kRequestCircleUsersUrl          kHostUrl@"team/findFriendsByTeamId.html"
#define kRequestAllCirclesUsersUrl      kHostUrl@"team/findAllFriends.html"
#define kRequestUsersCircleMeUrl        kHostUrl@"team/findAllFans.html"
#define kMoveCircleUserUrl              kHostUrl@"friend/moveFriend.html"

// 同城相关
#define kFindGroupUrl                   kHostUrl@"instance/findGroup.html"
#define kJoinGroupUrl                   kHostUrl@"instance/joinGroup.html"
#define kQuitGroupUrl                   kHostUrl@"instance/exitInsGroup.html"
#define kRequestGroupUsersUrl           kHostUrl@"instance/getInsUsers.html"
#define kSendGroupMessageUrl            kHostUrl@"instance/sendInsMessage.html"
#define kRequestGroupMessagesUrl        kHostUrl@"instance/getInsMessage.html"

// 分类资讯
#define kCityInformationListUrl         kHostUrl@"cityInfo/findCityInfo.html"
#define kCityInformationPostUrl         kHostUrl@"cityInfo/addCityInfo.html"
#define kCityInformationRepostUrl       kHostUrl@"cityInfo/shareCityInfoToTeam.html"
#define kCityInformationDeleteUrl       kHostUrl@"cityInfo/deleteCityInfo.html"

#define kCityInformationFindCommentsUrl kHostUrl@"cityInfoComment/findCityInfoComments.html"
#define kCityInformationAddCommentUrl   kHostUrl@"cityInfoComment/addComment.html"

//举报
#define kReportContentUrl               kHostUrl@"report/reportContent.html"
#define kReportPersonUrl                kHostUrl@"report/reportPerson.html"

//notice
#define kMessageNoticeUrl               kHostUrl@"notify/findUnreadCount.html"

#define kMinImageQuality                1
#define kMidImageQuality                2
#define kMaxImageQuality                3

typedef enum {
    SinaGetOauthCode = 0,           //authorize_code
    SinaGetOauthToken,              //access_token
    SinaGetRefreshToken,            //refresh_token
    SinaGetPublicTimeline,          //获取最新的公共微博
    SinaGetUserID,                  //获取登陆用户的UID
    SinaGetUserInfo,                //获取任意一个用户的信息
    SinaGetBilateralIdList,         //获取用户双向关注的用户ID列表，即互粉UID列表
    SinaGetBilateralIdListAll,      
    SinaGetBilateralUserList,       //获取用户的双向关注user列表，即互粉列表
    SinaGetBilateralUserListAll,
    SinaFollowByUserID,             //关注一个用户 by User ID
    SinaFollowByUserName,           //关注一个用户 by User Name
    SinaUnfollowByUserID,           //取消关注一个用户 by User ID
    SinaUnfollowByUserName,         //取消关注一个用户 by User Name
    SinaGetTrendStatues,            //获取某话题下的微博消息
    SinaFollowTrend,                //关注某话题
    SinaUnfollowTrend,              //取消对某话题的关注
    SinaPostText,                   //发布文字微博
    SinaPostTextAndImage,           //发布文字图片微博
    SinaGetHomeLine,                //获取当前登录用户及其所关注用户的最新微博
    SinaGetComment,                 //根据微博消息ID返回某条微博消息的评论列表
    SinaGetUserStatus,              //获取某个用户最新发表的微博列表
    SinaRepost,                     //转发一条微博
    SinaGetFollowingUserList,       //获取用户的关注列表
    SinaGetFollowedUserList,        //获取用户粉丝列表
    SinaGetHotRepostDaily,          //按天返回热门微博转发榜的微博列表
    SinaGetHotCommentDaily,         //按天返回热门微博评论榜的微博列表
    SinaGetHotTrendDaily,
    SinaGetUnreadCount,             //获取某个用户的各种消息未读数
    SINAGetMetionsStatuses,         //获取最新的提到登录用户的微博列表，即@我的微博
    SinaGetPois,                    //获取附近地点
    SinaSearchTopic,                //搜索某一话题下的微博
    SinaGetUserTopics,              //获取某人的话题列表
    SinaReplyAComment,              //回复一条评论
    SinaCommentAStatus,             //对一条微博进行评论
    
    FreebaoLogin,
    FreebaoRegister,
    FreebaoGetUserInfo,
    FreebaoGetHomeline,
    FreebaoGetHomelineNew,
    FreebaoGetComment,
    FreebaoGetMention,
    FreebaoLike,
    FreebaoUnlike,
    FreebaoGetLikers,
    FreebaoGetTranslate,
    FreebaoGetTranslateVoice,
    FreebaoAddComment,
    FreebaoGetConversationList,
    FreebaoSetConversationLanguage,
    FreebaoFollowerList,
    FreebaoFansList,
    FreebaoPost,
    FreebaoCircle,
    FreebaoPhotoList,
    FreebaoPersonInfo,
    FreebaoPersonPhoto,
    FreebaoPersonPhotoUpload,
    FreebaoPersonPhotoDelete,
    FreebaoFollowFriend,
    FreebaounFollowFriend,
    FreebaoUpdatePersonInfo,
    FreebaoUpdatePersonHeadImage,
    FreebaoDeleteComment,
    FreebaoAddfavorite,
    FreebaoDeleteHomeline,
}RequestType;


@class ASINetworkQueue;
@class Status;
@class User;


//Delegate
@protocol WeiBoHttpDelegate <NSObject>

@end

@interface WeiBoHttpManager : NSObject
{
    ASINetworkQueue *requestQueue;
    id<WeiBoHttpDelegate> delegate;
    
    NSString *authCode;
    NSString *authToken;
    NSString *userId;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,retain) id<WeiBoHttpDelegate> delegate;
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *authToken;
@property (nonatomic,copy) NSString *userId;

- (id)initWithDelegate:(id)theDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;

//Freebao登陆
-(void)didFreebaoLogin:(NSString*)username Password:(NSString*)password Token:(NSString*)token Platform:(NSString*)platform;

//Freebao 注册
-(void)didFreebaoRegister:(NSString *)username Password:(NSString *)password;

//Freebao获取用户信息
-(void)didFreebaoGetUserInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao获取微博信息
-(void)didFreebaoGetHomeline:(NSString*)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao获取微博信息new
-(void)didFreebaoGetHomelineNew:(NSString*)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao获取微博评论
-(void)didFreebaoGetCommentWithHomelineId:(NSString*)StatusId StatusType:(NSString *)statusType Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId;

//Freebao获取Mentions
-(void)didFreebaoGetMentionsWithUserId:(NSString*)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao Like
-(void)didFreebaoLikeWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao unLike
-(void)didFreebaounLikeWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao 获取Likers
-(void)didFreebaoGetLikersWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao 获取翻译
-(void)didFreebaoGetTranslationWithBody:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao 获取语音翻译
-(void)didFreebaoGetTranslationVoiceWithBoay:(NSString*)content Language:(NSString*)language PassId:(NSString*)passId;

//Freebao 回复微博
-(void)didFreebaoAddWeiboCommentWithContentId:(NSString*)contentId CommentContent:(NSString*)content UserId:(NSString*)aUserId PassId:(NSString*)passId CommentId:(NSString*)aCommentId VoiceData:(NSData*)voiceData;

//Freebao 获取会话列表
-(void)didFreebaoGetConversationListWithUserId:(NSString*)aUserId Page:(NSInteger)page PassId:(NSString*)passId;

//Freebao 设置会话语言
-(void)didFreebaoConversationLanguageWithUserId:(NSString*)aUserId ToUserId:(NSString*)toUserId Language:(NSString*)language PassId:(NSString*)passId;

//Freebao 获取Follower列表
-(void)didFreebaoFollowerListWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao 获取我的Fans列表
-(void)didFreebaoFansListWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao 发布分享
-(void)didFreebaoPostWithUserId:(NSString*)aUserId Boay:(NSString*)content AllowShare:(BOOL)isShare AllowComment:(BOOL)isComment CircleId:(NSString*)circleId Location:(NSString*)location Latitude:(NSString*)aLatitude Longgitude:(NSString*)aLonggitude FileType:(NSString*)fileType MediaFile:(NSData*)mediaData SoundFile:(NSData*)soundData PassId:(NSString*)passId;

//Freebao 获取圈子
-(void)didFreebaoGetCircleWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao 获取用户照片
-(void)didFreebaoGetUserPhotosWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString*)passId;

//Freebao 获取个人资料
-(void)didFreebaoGetPersonInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao 获取头像照片
-(void)didFreebaoGetPersonPhotoWithUserId:(NSString*)aUserId PassId:(NSString*)passId;

//Freebao 上传头像信息
-(void)didFreebaoAddPersonPhotoWithUserId:(NSString*)aUserId PhotoFile:(NSData*)photoData PassId:(NSString*)passId;

//Freebao 删除头像信息
-(void)didFreebaoDeletePersonPhotoWithUserId:(NSString*)aUserId PhotoUrl:(NSString*)photoUrl PassId:(NSString*)passId;

//Freebao 关注好友
-(void)didFreebaoFollowFriendWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId CircleId:(NSString*)circleId PassId:(NSString*)passId;

//Freebao 取消关注好友
-(void)didFreebaounFollowFriendWithUserId:(NSString*)aUserId SomeBodyId:(NSString*)aSomeBodyId PassId:(NSString*)passId;

//Freebao 更新个人资料
-(void)didFreebaoUpdatePersonInfoWithUserId:(NSString*)aUserId PassId:(NSString*)passId NickName:(NSString*)nickName Biography:(NSString*)biography City:(NSString*)city Email:(NSString*)email Gender:(NSString*)gender Height:(NSString*)height Weight:(NSString*)weight Birthday:(NSString*)birthday BloodType:(NSString*)bloodType Profession:(NSString*)profession Tourism:(NSString*)tourism Intersets:(NSString*)interests CountryVisited:(NSString*)countryVisited;

//Freebao 更新个人头像
-(void)didFreebaoUpdatePersonHeaderImageWithUserId:(NSString*)aUserId FacePath:(NSString*)facePath PassId:(NSString*)passId;

//Freebao 删除自己评论
-(void)didFreebaoDeleteMyCommentWithUserId:(NSString*)aUserId CommentId:(NSString*)commentId PassId:(NSString*)passId;

//Freebao 收藏分享
-(void)didFreebaoAddFavouriteWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;

//Freebao 删除分享
-(void)didFreebaoDeleteHomelineWithUserId:(NSString*)aUserId ContentId:(NSString*)aContentId PassId:(NSString*)passId;
@end
