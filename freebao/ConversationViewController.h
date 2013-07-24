//
//  ConversationViewController.h
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BlankCell.h"
#import "ConversationCell.h"

#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"

#import "ChatViewController.h"
#import "WeiBoMessageManager.h"
#import "ConversationInfo.h"
#import "FansViewController.h"

@class WeiBoMessageManager;
@interface ConversationViewController : PullRefreshTableViewController<EGORefreshTableHeaderDelegate> {
    WeiBoMessageManager *manager;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *conversationArray;
    UILabel *tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
}

- (void)doneLoadingTableViewData;

@end
