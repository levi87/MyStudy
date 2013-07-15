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

@interface ConversationViewController : PullRefreshTableViewController<EGORefreshTableHeaderDelegate> {
@private
    NSMutableArray *headPhotos;
    UILabel *tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
}

- (void)doneLoadingTableViewData;

@end
