//
//  FollowersViewController.h
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "FollowerCell.h"

@class WeiBoMessageManager;
@interface FollowersViewController : UITableViewController {
    WeiBoMessageManager *manager;
    NSString *_cellContentIdFollow;
    BOOL _isRefreshFollow;
    BOOL isFirstFollow;
    
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIView *tittleView;
    UIView *tittleLineView;
@private
    NSMutableArray *headPhotosFollow;
    NSMutableArray *followersArray;
    int currentPageFollow;
    int maxPageFollow;
}

@property NSString *cellContentIdFollow;
@property BOOL isRefreshFollow;

-(void)clearCache;

@end
