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

#define SINA_V2_DOMAIN              @"https://api.weibo.com/2"
#define SINA_API_AUTHORIZE          @"https://api.weibo.com/oauth2/authorize"
#define SINA_API_ACCESS_TOKEN       @"https://api.weibo.com/oauth2/access_token"

#define SINA_APP_KEY                @"3601604349"
#define SINA_APP_SECRET             @"7894dfdd1fc2ce7cc6e9e9ca620082fb"

#define USER_INFO_KEY_TYPE          @"requestType"

#define USER_STORE_ACCESS_TOKEN     @"SinaAccessToken"
#define USER_STORE_EXPIRATION_DATE  @"SinaExpirationDate"
#define USER_STORE_USER_ID          @"SinaUserID"
#define USER_STORE_USER_NAME        @"SinaUserName"
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

//FB_NOTIFICATION

#define FB_NOTIC_LOGIN_SUCCESS      @"fb_success"
#define FB_NOTIC_LOGIN_FAILED       @"fb_failed"

//FB_HOMELINE
#define FB_GET_HOMELINE             @"fb_get_homeline"
#define FB_GET_USERINFO             @"fb_get_userinfo"
#define FB_GET_UNREAD_COUNT         @"fb_get_unread_count"

/*
 Freebao
 */
#define kDefaultRequestPageSize         20
//测试环境 （你妹）
#define kHostUrl                        @"http://t.freebao.com/"
#define kRegisterUrl                    @"http://t.freebao.com"
#define CItMessageUrl                   @"t.freebao.com"
#define CityMessage                     @"@t.freebao.com"

//正式环境
//#define kHostUrl                        @"http://m.freebao.com/"
//#define kRegisterUrl                    @"http://m.freebao.com"
//#define CItMessageUrl                   @"m.freebao.com"
//#define CityMessage                     @"@m.freebao.com"

#define kqqloginUrl                     kHostUrl@"oauth/loginQQ.html"
#define kqqBindUrl                     kHostUrl@"oauth/bangDingQQUser.html"
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
#define kRequestTimeLinesUrl            kHostUrl@"content/findFriendsContent.html"
#define kRequestRecommendedUsers        kHostUrl@"clientUser/recommendFriendList.html"
#define kRequestFriendsUrl              kHostUrl@"friend/followList.html"
#define KFollowUrl                      kHostUrl@"friend/followFriend.html"
#define kCancelFollowUrl                kHostUrl@"friend/cancleFollowFriend.html"
#define kRequestFollowersUrl            kHostUrl@"friend/fansList.html"
#define kRequestFavouriteTimelines      kHostUrl@"favorite/findMyFavorites.html"
#define kAddFavouriteTimeline           kHostUrl@"favorite/addFavorite.html"
#define kDeleteFavouriteTimeline        kHostUrl@"favorite/deleteFavorite.html"
#define kRequestUserInfoUrl             kHostUrl@"userInfo/getUserInfo.html"
#define KUpdateUserInfoUrl              kHostUrl@"userInfo/updateBasicInfo.html"
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
}RequestType;

@class ASINetworkQueue;
@class Status;
@class User;


//Delegate
@protocol WeiBoHttpDelegate <NSObject>

@optional
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray*)statusArr;

//获取登陆用户的UID
-(void)didGetUserID:(NSString*)userID;

//获取任意一个用户的信息
-(void)didGetUserInfo:(User*)user;

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSDictionary *)commentInfo;

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray*)arr;

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray*)userArr;

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSDictionary*)dic;

//获取用户粉丝列表
-(void)didGetFollowedUsersList:(NSDictionary*)dic;

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray*)statusArr;

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary*)resultDic;

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary*)resultDic;

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID;

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue;

//发布微博
-(void)didGetPostResult:(Status*)sts;

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray*)statusArr;

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr;

//转发一条微博
-(void)didRepost:(Status*)sts;

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray*)statusArr;

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray*)statusArr;

//返回最近一天内的热门话题
-(void)didGetHotTrendDaily:(NSArray*)trendsArr;

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary*)dic;

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)didGetMetionsStatused:(NSArray*)statusArr;

//获取附近地点
-(void)didgetPois:(NSArray*)poisArr;

//搜索某一话题下的微博
-(void)didGetTopicSearchResult:(NSArray*)statusArr;

//获取某人的话题列表
-(void)didGetuserTopics:(NSArray*)trendsArr;

//回复一条评论
-(void)didReplyAComment:(BOOL)isOK;

//对一条微博进行评论
-(void)didCommentAStatus:(BOOL)isOK;

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

//留给webview用
-(NSURL*)getOauthCodeUrl;

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page;

//获取登陆用户的UID
-(void)getUserID;

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid;
-(void)getUserInfoWithScreenName:(NSString*)sn;

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID maxID:(NSString*)max_id page:(int)page;

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort;
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort;

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort;
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort;

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid inTableView:(NSString*)tableName;

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName;

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid inTableView:(NSString*)tableName;

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName;

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName;

//关注某话题
-(void)followTrend:(NSString*)trendName;

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID;

//发布文字微博
-(void)postWithText:(NSString*)text;

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//转发一条微博
//isComment(int):是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment;

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count;

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count;

//返回最近一天内的热门话题
-(void)getHOtTrendsDaily;

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid;

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses;

//获取附近地点
-(void)getPoisWithCoodinate:(CLLocationCoordinate2D)coodinate queryStr:(NSString*)queryStr;

//搜索某一话题下的微博
-(void)searchTopic:(NSString *)queryStr count:(int)count page:(int)page;

//获取某人的话题列表
-(void)getTopicsOfUser:(User*)user;

//回复一条评论
-(void)replyACommentWeiboId:(NSString *)weiboID commentID:(NSString*)commentID content:(NSString*)content;

//对一条微博进行评论
-(void)commentAStatus:(NSString*)weiboID content:(NSString*)content;

//Freebao登陆
-(void)didFreebaoLogin:(NSString*)username Password:(NSString*)password Token:(NSString*)token Platform:(NSString*)platform;

@end
