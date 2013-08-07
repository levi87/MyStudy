//
//  WeiBoHttpManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "WeiBoHttpManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Status.h"
#import "SBJson.h"
#import "Comment.h"
#import "StatusInfo.h"

@implementation WeiBoHttpManager
@synthesize requestQueue;
@synthesize delegate;
@synthesize authCode;
@synthesize authToken;
@synthesize userId;

#pragma mark - Init

-(void)dealloc
{
}

//初始化
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark - Methods
- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(RequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:dict];
}

- (void)setPostUserInfo:(ASIFormDataRequest *)request withRequestType:(RequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
    [request setUserInfo:dict];
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8));

            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

#pragma mark - Http Operate

-(void)didFreebaoLogin:(NSString *)username Password:(NSString *)password Token:(NSString *)token Platform:(NSString *)platform{

    NSURL *url = [NSURL URLWithString:kLoginUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:username    forKey:@"user.logname"];
    [item setPostValue:password      forKey:@"password"];
    [item setPostValue:token      forKey:@"token"];
    [item setPostValue:@"2"      forKey:@"user.loginplatform"];
    
    [self setPostUserInfo:item withRequestType:FreebaoLogin];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetUserInfoWithUserId:(NSString *)aUserId PassId:(NSString *)passId{
    NSURL *url = [NSURL URLWithString:kRequestUserInfoUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetUserInfo];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetHomeline:(NSString *)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestTimeLinesUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetHomeline];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetHomelineNew:(NSString *)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestTimeLinesUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetHomelineNew];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetCommentWithHomelineId:(NSString*)StatusId StatusType:(NSString *)statusType Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url;
    NSInteger statusT = [statusType integerValue];
    if (statusT == 0) {
        url = [NSURL URLWithString:kRequestCommentsToTimelineUrl];
    } else {
        url = [NSURL URLWithString:kCityInformationFindCommentsUrl];
    }
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:passId      forKey:@"passId"];
    if (statusT == 0) {
        [item setPostValue:StatusId     forKey:@"query.contentId"];
    } else {
        [item setPostValue:StatusId     forKey:@"comment.contentId"];
    }
    if (statusT == 0) {
        [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    } else {
        [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"comment.toPage"];
    }
    if (statusT == 0) {
        [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    } else {
        [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"comment.perPageSize"];
    }
    
    [self setPostUserInfo:item withRequestType:FreebaoGetComment];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetMentionsWithUserId:(NSString *)aUserId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestMyRepliesUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetMention];
    [requestQueue addOperation:item];
}

-(void)didFreebaoLikeWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:KLikeUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"like.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aContentId     forKey:@"like.contentid"];
    
    [self setPostUserInfo:item withRequestType:FreebaoLike];
    [requestQueue addOperation:item];
}

-(void)didFreebaounLikeWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:KDeletLikeUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"like.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aContentId     forKey:@"like.contentid"];
    
    [self setPostUserInfo:item withRequestType:FreebaoUnlike];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetLikersWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:KLikeUserUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"query.currentUserId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aContentId     forKey:@"query.contentid"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetLikers];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetTranslationWithBody:(NSString *)content Language:(NSString *)language PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kGetMessageTrans];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:content    forKey:@"body"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:language forKey:@"language"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetTranslate];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetTranslationVoiceWithBoay:(NSString *)content Language:(NSString *)language PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kGetMessageTransVoice];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:content    forKey:@"body"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:language forKey:@"language"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetTranslateVoice];
    [requestQueue addOperation:item];
}

- (void)didFreebaoAddWeiboCommentWithContentId:(NSString *)contentId CommentContent:(NSString *)content UserId:(NSString *)aUserId PassId:(NSString *)passId CommentId:(NSString *)aCommentId VoiceData:(NSData *)voiceData{
    NSURL *url = [NSURL URLWithString:kAddCommentUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:content    forKey:@"comment.commentBody"];
    [item setPostValue:contentId forKey:@"comment.contentId"];
    [item setPostValue:aCommentId forKey:@"comment.replyId"];
    if (voiceData != nil) {
        [item setData:voiceData forKey:@"soundFile"];
    }
    
    [self setPostUserInfo:item withRequestType:FreebaoAddComment];
    [requestQueue addOperation:item];
}

- (void)didFreebaoGetConversationListWithUserId:(NSString *)aUserId Page:(NSInteger)page PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestConversationListUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"query.sendUid"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    
    [self setPostUserInfo:item withRequestType:FreebaoGetConversationList];
    [requestQueue addOperation:item];
}

- (void)didFreebaoConversationLanguageWithUserId:(NSString *)aUserId ToUserId:(NSString *)toUserId Language:(NSString *)language PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kGetMessageTransSet];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"chatLanguage.fromId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:toUserId forKey:@"chatLanguage.toId"];
    [item setPostValue:language     forKey:@"chatLanguage.language"];
    
    [self setPostUserInfo:item withRequestType:FreebaoSetConversationLanguage];
    [requestQueue addOperation:item];
}

- (void)didFreebaoFollowerListWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestFriendsUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aSomeBodyId     forKey:@"query.sendUid"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoFollowerList];
    [requestQueue addOperation:item];
}

- (void)didFreebaoFansListWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestFollowersUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aSomeBodyId     forKey:@"query.receiveUid"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoFansList];
    [requestQueue addOperation:item];
}

- (void)didFreebaoPostWithUserId:(NSString *)aUserId Boay:(NSString *)content AllowShare:(BOOL)isShare AllowComment:(BOOL)isComment CircleId:(NSString *)circleId Location:(NSString *)location Latitude:(NSString *)aLatitude Longgitude:(NSString *)aLonggitude FileType:(NSString *)fileType MediaFile:(NSData *)mediaData SoundFile:(NSData *)soundData PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kPostUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"content.contentuid"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:content     forKey:@"content.contentbody"];
    [item setPostValue:[NSNumber numberWithBool:isShare]     forKey:@"content.allowShare"];
    [item setPostValue:[NSNumber numberWithBool:isComment]     forKey:@"content.allowComment"];
    [item setPostValue:[NSNumber numberWithInteger:[circleId integerValue]] forKey:@"content.teamIds"];
    [item setPostValue:location forKey:@"content.location"];//地点
    [item setPostValue:aLatitude forKey:@"content.longgitude"];//经度
    [item setPostValue:aLonggitude forKey:@"content.latitude"];//维度
    
    if (mediaData != nil) {
        [item setPostValue:[NSNumber numberWithInt:[fileType integerValue]] forKey:@"content.filetype"];
        [item setData:mediaData forKey:@"mediaFile"];
    }
    
    if (soundData != nil) {
        [item setData:soundData forKey:@"soundFile"];
    }
    
    [self setPostUserInfo:item withRequestType:FreebaoPost];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetCircleWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestCirclesUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    
    [self setPostUserInfo:item withRequestType:FreebaoCircle];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetUserPhotosWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId Page:(NSInteger)page PageSize:(NSInteger)pageSize PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kGetUserPicListUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aSomeBodyId     forKey:@"query.sendUid"];
    [item setPostValue:[NSNumber numberWithInteger:page+1]     forKey:@"query.toPage"];
    [item setPostValue:[NSNumber numberWithInteger:pageSize]       forKey:@"query.perPageSize"];
    
    [self setPostUserInfo:item withRequestType:FreebaoPhotoList];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetPersonInfoWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kRequestUserProfile];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    
    [self setPostUserInfo:item withRequestType:FreebaoPersonInfo];
    [requestQueue addOperation:item];
}

-(void)didFreebaoGetPersonPhotoWithUserId:(NSString *)aUserId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kgetfaceUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    
    [self setPostUserInfo:item withRequestType:FreebaoPersonPhoto];
    [requestQueue addOperation:item];
}

-(void)didFreebaoAddPersonPhotoWithUserId:(NSString *)aUserId PhotoFile:(NSData *)photoData PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kaddfaceUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    if (photoData != nil) {
        [item setData:photoData      forKey:@"faceFile"];
    }
    
    [self setPostUserInfo:item withRequestType:FreebaoPersonPhotoUpload];
    [requestQueue addOperation:item];
}

-(void)didFreebaoDeletePersonPhotoWithUserId:(NSString *)aUserId PhotoUrl:(NSString *)photoUrl PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kdeleteface];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userface.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:photoUrl      forKey:@"userface.facepath"];
    
    [self setPostUserInfo:item withRequestType:FreebaoPersonPhotoDelete];
    [requestQueue addOperation:item];
}

-(void)didFreebaoFollowFriendWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId CircleId:(NSString *)circleId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:KFollowUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aSomeBodyId     forKey:@"friend.receiveUid"];
    [item setPostValue:[NSNumber numberWithInteger:[circleId integerValue]] forKey:@"friend.teamId"];
    
    [self setPostUserInfo:item withRequestType:FreebaoFollowFriend];
    [requestQueue addOperation:item];
}

-(void)didFreebaounFollowFriendWithUserId:(NSString *)aUserId SomeBodyId:(NSString *)aSomeBodyId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:KFollowUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aSomeBodyId     forKey:@"friend.receiveUid"];;
    
    [self setPostUserInfo:item withRequestType:FreebaounFollowFriend];
    [requestQueue addOperation:item];
}

-(void)didFreebaoUpdatePersonInfoWithUserId:(NSString *)aUserId PassId:(NSString *)passId NickName:(NSString *)nickName Biography:(NSString *)biography City:(NSString *)city Email:(NSString *)email Gender:(NSString *)gender Height:(NSString *)height Weight:(NSString *)weight Birthday:(NSString *)birthday BloodType:(NSString *)bloodType Profession:(NSString *)profession Tourism:(NSString *)tourism Intersets:(NSString *)interests CountryVisited:(NSString *)countryVisited {
    NSURL *url = [NSURL URLWithString:KUpdateUserInfoUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"user.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:nickName     forKey:@"user.nickname"];
    [item setPostValue:biography     forKey:@"user.biography"];
    [item setPostValue:city     forKey:@"user.userInfo.city"];
    [item setPostValue:email forKey:@"user.email"];
    [item setPostValue:gender forKey:@"user.userInfo.gender"];
    [item setPostValue:height forKey:@"user.userInfo.height"];
    [item setPostValue:weight forKey:@"user.userInfo.wight"];
    [item setPostValue:birthday forKey:@"birthday"];
    [item setPostValue:bloodType forKey:@"user.userInfo.bloodtype"];
    [item setPostValue:profession forKey:@"user.userInfo.profession"];
    [item setPostValue:tourism forKey:@"user.userInfo.tourism"];
    [item setPostValue:interests forKey:@"user.userInfo.interests"];
    [item setPostValue:countryVisited forKey:@"user.userInfo.country_visited"];
    
    [self setPostUserInfo:item withRequestType:FreebaoUpdatePersonInfo];
    [requestQueue addOperation:item];
}

-(void)didFreebaoUpdatePersonHeaderImageWithUserId:(NSString *)aUserId FacePath:(NSString *)facePath PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kUpdateUserHeaderImageUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"user.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:facePath     forKey:@"user.facePath"];;
    
    [self setPostUserInfo:item withRequestType:FreebaoUpdatePersonHeadImage];
    [requestQueue addOperation:item];
}

-(void)didFreebaoDeleteMyCommentWithUserId:(NSString *)aUserId CommentId:(NSString *)commentId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:Kdeleatecomment];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"comment.userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:commentId     forKey:@"comment.commentId"];;
    
    [self setPostUserInfo:item withRequestType:FreebaoDeleteComment];
    [requestQueue addOperation:item];
}

-(void)didFreebaoAddFavouriteWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kAddFavouriteTimeline];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aContentId     forKey:@"favorite.contentId"];;
    
    [self setPostUserInfo:item withRequestType:FreebaoAddfavorite];
    [requestQueue addOperation:item];
}

-(void)didFreebaoDeleteHomelineWithUserId:(NSString *)aUserId ContentId:(NSString *)aContentId PassId:(NSString *)passId {
    NSURL *url = [NSURL URLWithString:kDeleteTimelineUrl];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:aUserId    forKey:@"userId"];
    [item setPostValue:passId      forKey:@"passId"];
    [item setPostValue:aContentId     forKey:@"content.contentid"];;
    
    [self setPostUserInfo:item withRequestType:FreebaoDeleteHomeline];
    [requestQueue addOperation:item];
}

#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![requestQueue isSuspended];
}

- (void)start
{
	if( [requestQueue isSuspended] )
		[requestQueue go];
}

- (void)pause
{
	[requestQueue setSuspended:YES];
}

- (void)resume
{
	[requestQueue setSuspended:NO];
}

- (void)cancel
{
	[requestQueue cancelAllOperations];
}

#pragma mark - ASINetworkQueueDelegate
//失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed:%@,%@,",request.responseString,[request.error localizedDescription]);
    
    NSNotification *notification = [NSNotification notificationWithName:MMSinaRequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *userInformation = [request userInfo];
    RequestType requestType = [[userInformation objectForKey:USER_INFO_KEY_TYPE] intValue];
//    NSString * responseString = [request responseString];
//    NSLog(@"responseString = %@",responseString);

    id returnObject = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        NSString *errorString = [returnObject  objectForKey:@"error"];
        if (errorString != nil && ([errorString isEqualToString:@"auth faild!"] || 
                                   [errorString isEqualToString:@"expired_token"] || 
                                   [errorString isEqualToString:@"invalid_access_token"])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NeedToReLogin object:nil];
            NSLog(@"detected auth faild!");
        }
    }
    
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    else {
        return;
    }
    
    //Freebao登陆
    if (requestType == FreebaoLogin) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSMutableDictionary *tmp = [[tmpDic objectForKey:@"resultMap"] objectForKey:@"userInfo"];
            NSString *passId = [tmp objectForKey:@"passId"];
            NSString *passwordKey = [tmp objectForKey:@"passwordKey"];
            NSString *usrId = [tmp objectForKey:@"userId"];
            NSLog(@"[levi] %@ %@ %@", passId, passwordKey, usrId);
            [[NSUserDefaults standardUserDefaults] setObject:passId forKey:FB_PASS_ID];
            [[NSUserDefaults standardUserDefaults] setObject:passwordKey forKey:FB_PASSWORD_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:usrId forKey:FB_USER_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_NOTIC_LOGIN_SUCCESS object:tmp];
        } else {
            NSLog(@"[levi] login failed...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_NOTIC_LOGIN_FAILED object:nil];
        }
        return;
    }
    //Freebao获取用户信息
    if (requestType == FreebaoGetUserInfo) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSMutableDictionary *tmp = [[tmpDic objectForKey:@"resultMap"] objectForKey:@"user"];
            NSString *nickName = [tmp objectForKey:@"url"];
            NSString *facePath = [tmp objectForKey:@"facePath"];
            NSLog(@"[levi] request UserInfo Success...");
            [[NSUserDefaults standardUserDefaults] setObject:facePath forKey:FB_USER_FACE_PATH];
            [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:FB_USER_NICK_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSLog(@"[levi] request UserInfo failed...");
        }
        return;
    }
    
    if (requestType == FreebaoGetHomeline) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request HomeLine Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            
            NSArray *contents = [resultMap objectForKey:@"posts"];
            
            NSMutableArray *timeline = [NSMutableArray array];
            for (NSInteger index=0; index<[contents count]; index++) {
                NSDictionary *statusInfo = [contents objectAtIndex:index];
                Status *status = [Status statusWithJsonDictionaryFreebao:statusInfo];
                [timeline addObject:status];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_HOMELINE object:timeline];
            NSLog(@"[levi] status array count : %d",[timeline count]);
        } else {
            NSLog(@"[levi] request HomeLine failed...");
        }
        return;
    }
    
    if (requestType == FreebaoGetHomelineNew) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request new HomeLine Success... %@", tmpDic);
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSDictionary *maxCount = [NSDictionary dictionaryWithObjectsAndKeys:[[resultMap objectForKey:@"currentPageInfo"] objectForKey:@"totalPage"],@"maxCount", nil];
            
            NSArray *contents = [resultMap objectForKey:@"posts"];
            NSLog(@"post new %@",contents);
            
            NSMutableArray *timeline = [NSMutableArray array];
            for (NSInteger index=0; index<[contents count]; index++) {
                NSDictionary *tmpDic = [contents objectAtIndex:index];
                StatusInfo *statusInfo = [[StatusInfo alloc] init];
                statusInfo.isFakeWeibo = NO;
                statusInfo.originalPicUrl = [tmpDic getStringValueForKey:@"original_pic" defaultValue:@"0"];
                statusInfo.commentCount = [tmpDic getStringValueForKey:@"comment_count" defaultValue:@"0"];
                statusInfo.contentId = [tmpDic getStringValueForKey:@"contentId" defaultValue:@"0"];
                statusInfo.createAt = [tmpDic getStringValueForKey:@"create_at" defaultValue:@"0"];
                statusInfo.distance = [tmpDic getStringValueForKey:@"distance" defaultValue:@"0"];
                statusInfo.likeCount = [tmpDic getStringValueForKey:@"like_count" defaultValue:@"0"];
                statusInfo.liked = [tmpDic getStringValueForKey:@"liked" defaultValue:@"0"];
                statusInfo.postLanguage = [tmpDic getStringValueForKey:@"post_language" defaultValue:@"0"];
                statusInfo.content = [tmpDic getStringValueForKey:@"text" defaultValue:@"0"];
                statusInfo.userFacePath = [tmpDic getStringValueForKey:@"user_face_path" defaultValue:@"0"];
                statusInfo.userId = [tmpDic getStringValueForKey:@"user_id" defaultValue:@"0"];
                statusInfo.userName = [tmpDic getStringValueForKey:@"user_name" defaultValue:@"0"];
                statusInfo.rePostDic = [tmpDic objectForKey:@"postVO"];
                statusInfo.commentArray = [tmpDic objectForKey:@"comments"];
                statusInfo.isPlayingVoice = NO;
                statusInfo.isPlayingSound = NO;
                [timeline addObject:statusInfo];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_HOMELINE_NEW object:timeline userInfo:maxCount];
            NSLog(@"[levi] new status array count : %d",[timeline count]);
        } else {
            NSLog(@"[levi] new request HomeLine failed...");
        }
        return;
    }
    
    if (requestType == FreebaoGetComment) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Comments Success...");
            NSLog(@"[levi] result %@", tmpDic);
//            NSDictionary *currentPageInfo = [[tmpDic objectForKey:@"resultMap"] objectForKey:@"currentPageInfo"];
            NSArray         *arrComment = [[tmpDic objectForKey:@"resultMap"] objectForKey:@"contentCommentsList"];
//            NSNumber        *count      = [currentPageInfo objectForKey:@"returnCount"];
            if (arrComment == nil || [arrComment isEqual:[NSNull null]]) {
                return;
            }
            
//            NSMutableArray  *commentArr = [[NSMutableArray alloc]initWithCapacity:0];
//            for (id item in arrComment) {
//                Comment *comm = [Comment commentWithJsonDictionaryFreebao:item];
//                [commentArr addObject:comm];
//            }
//            NSDictionary *commentDic = [NSDictionary dictionaryWithObjectsAndKeys:commentArr,@"commentArrary",count,@"count", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_COMMENT object:arrComment];
        } else {
            NSLog(@"[levi] request Comments failed...");
        }
        return;
    }

    if (requestType == FreebaoGetMention) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Mentions Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            
            NSArray *contents = [resultMap objectForKey:@"messageList"];
            if (contents == nil)    // 有些时候返回的格式是contents
            {
                contents = [resultMap objectForKey:@"contents"];
            }
            
            NSMutableArray *mentions = [NSMutableArray array];
            for (NSInteger index=0; index<[contents count]; index++) {
                NSDictionary *statusInfo = [contents objectAtIndex:index];
                Status *status = [Status statusWithJsonDictionaryFreebao:statusInfo];
                //传给L_Status
//                if (status != nil) {
//                    NSLog(@"[levi]status Id %lld, status Time %@, status image %@, status body %@, status platform %@, status name %@,status user url %@",
//                          status.statusId,
//                          status.createdAt,
//                          status.sourceUrl,
//                          status.text,
//                          status.source,
//                          status.user.screenName,
//                          status.user.profileImageUrl);
//                }
                [mentions addObject:status];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_MENTION object:mentions];
        } else {
            NSLog(@"[levi] request Mentions failed...");
        }
        return;
    }
    if (requestType == FreebaoLike) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Like Success...");
//            [[NSNotificationCenter defaultCenter] postNotificationName:FB_ADD_LIKE object:nil];
        } else {
            NSLog(@"[levi] request Like failed...");
        }
        return;
    }
    if (requestType == FreebaoUnlike) {
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request UnLike Success...");
//            [[NSNotificationCenter defaultCenter] postNotificationName:FB_UN_LIKE object:nil];
        } else {
            NSLog(@"[levi] request UnLike failed...");
        }
        return;
    }
    if (requestType == FreebaoGetLikers) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] get Likers List... %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Likers Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSArray *resultArray = [resultMap objectForKey:@"likeUsers"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_LIKERS object:resultArray];
        } else {
            NSLog(@"[levi] request Likers failed...");
        }
        return;
    }
    if (requestType == FreebaoGetTranslate) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] get Translate... %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Translate Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            
            NSString *contents = [resultMap objectForKey:@"response"];
//            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
//            NSArray *resultArray = [resultMap objectForKey:@"likeUsers"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_TRANSLATION object:contents];
        } else {
            NSLog(@"[levi] request Translate failed...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_TRANSLATION_FAIL object:nil];
        }
        return;
    }
    if (requestType == FreebaoGetTranslateVoice) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] get Translate... %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Translate Voice Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            
            NSString *voiceUrl = [resultMap objectForKey:@"voice"];
            //            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            //            NSArray *resultArray = [resultMap objectForKey:@"likeUsers"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_TRANSLATION_VOICE object:voiceUrl];
        } else {
            NSLog(@"[levi] request Translate Voice failed...");
        }
        return;
    }
    if (requestType == FreebaoAddComment) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] add comment %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request add comment Success...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_ADD_COMMENT object:nil];
        } else {
            NSLog(@"[levi] request add comment failed...");
        }
        return;
    }
    if (requestType == FreebaoGetConversationList) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] Get Conversation List %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Get Conversation List Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSArray *resultArray = [resultMap objectForKey:@"chats"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_CONVERSATION object:resultArray];
        } else {
            NSLog(@"[levi] request Get Conversation Listfailed...");
        }
        return;
    }
    if (requestType == FreebaoSetConversationLanguage) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] Set Conversation Language %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] request Set Conversation Language Success...");
        } else {
            NSLog(@"[levi] request Set Conversation Language failed...");
        }
        return;
    }
    if (requestType == FreebaoFollowerList) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] follow list %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] follow list Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSDictionary *maxCount = [NSDictionary dictionaryWithObjectsAndKeys:[[resultMap objectForKey:@"currentPageInfo"] objectForKey:@"totalPage"],@"maxCount", nil];
            NSArray *resultArray = [resultMap objectForKey:@"followList"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_FOLLOWER_LIST object:resultArray userInfo:maxCount];
        } else {
            NSLog(@"[levi] follow list failed...");
        }
        return;
    }
    if (requestType == FreebaoFansList) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] fans list %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] fans list Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSDictionary *maxCount = [NSDictionary dictionaryWithObjectsAndKeys:[[resultMap objectForKey:@"currentPageInfo"] objectForKey:@"totalPage"],@"maxCount", nil];
            NSArray *resultArray = [resultMap objectForKey:@"fansList"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_FANS_LIST object:resultArray userInfo:maxCount];
        } else {
            NSLog(@"[levi] fans list failed...");
        }
        return;
    }
    if (requestType == FreebaoPost) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] post dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] post Success...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_POST_SUCCESS object:nil];
        } else {
            NSLog(@"[levi] post failed...");
        }
        return;
    }
    if (requestType == FreebaoCircle) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] circle dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] get circle Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSArray *resultArray = [resultMap objectForKey:@"teams"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_CIRCLE object:resultArray];
        } else {
            NSLog(@"[levi] get circle failed...");
        }
        return;
    }
    if (requestType == FreebaoPhotoList) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] photo dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] get phtoto Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSArray *resultArray = [resultMap objectForKey:@"userPic"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_PHOTO_LIST object:resultArray];
        } else {
            NSLog(@"[levi] get photo failed...");
        }
        return;
    }
    if (requestType == FreebaoPersonInfo) {
        NSMutableDictionary *tmpDic = returnObject;
//        NSLog(@"[levi] person info dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] get Person Info Success...");
            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            NSDictionary *resultUser = [resultMap objectForKey:@"user"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_PERSON_INFO object:resultUser];
        } else {
            NSLog(@"[levi] get Person Info failed...");
        }
        return;
    }
    if (requestType == FreebaoPersonPhoto) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] person photo dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] get Person photo Success...");
            //            NSDictionary *resultMap = [tmpDic objectForKey:@"resultMap"];
            //            NSArray *resultArray = [resultMap objectForKey:@"userPic"];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:FB_GET_PHOTO_LIST object:resultArray];
        } else {
            NSLog(@"[levi] get Person photo failed...");
        }
        return;
    }
    if (requestType == FreebaoPersonPhotoUpload) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] person photo upload dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] upload Person photo Success...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_UPLOAD_PHOTO_HEAD_IMAGE object:nil];
        } else {
            NSLog(@"[levi] upload Person photo failed...");
        }
        return;
    }
    if (requestType == FreebaoPersonPhotoDelete) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] person photo delete dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] delete Person photo Success...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_UPLOAD_PHOTO_RERESH object:nil];
        } else {
            NSLog(@"[levi] delete Person photo failed...");
        }
        return;
    }
    if (requestType == FreebaoFollowFriend) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] follow friend dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] follow friend Success...");
        } else {
            NSLog(@"[levi] follow friend failed...");
        }
        return;
    }
    if (requestType == FreebaounFollowFriend) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] unfollow friend dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] unfollow friend Success...");
        } else {
            NSLog(@"[levi] unfollow friend failed...");
        }
        return;
    }
    if (requestType == FreebaoUpdatePersonInfo) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] update person info dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] update person info Success...");
        } else {
            NSLog(@"[levi] update person info failed...");
        }
        return;
    }
    if (requestType == FreebaoUpdatePersonHeadImage) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] update person headImage dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] update person headImage Success...");
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_UPLOAD_PHOTO_RERESH object:nil];
        } else {
            NSLog(@"[levi] update person headImage failed...");
        }
        return;
    }
    if (requestType == FreebaoDeleteComment) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] delete comment dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] delete comment Success...");
        } else {
            NSLog(@"[levi] delete comment failed...");
        }
        return;
    }
    if (requestType == FreebaoAddfavorite) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] add favorite dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] add favorite Success...");
        } else {
            NSLog(@"[levi] add favorite failed...");
        }
        return;
    }
    if (requestType == FreebaoDeleteHomeline) {
        NSMutableDictionary *tmpDic = returnObject;
        NSLog(@"[levi] delete homeline dic %@", tmpDic);
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            NSLog(@"[levi] delete homeline Success...");
        } else {
            NSLog(@"[levi] delete homeline failed...");
        }
        return;
    }
}

//跳转
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"request will redirect");
}


@end
