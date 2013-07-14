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

@end
