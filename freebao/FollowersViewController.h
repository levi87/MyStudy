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
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
    
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIView *tittleView;
    UIView *tittleLineView;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *followersArray;
    int currentPage;
    int maxPage;
}

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;

@end
