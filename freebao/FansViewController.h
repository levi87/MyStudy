//
//  FansViewController.h
//  freebao
//
//  Created by freebao on 13-7-24.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "FansCell.h"
#import "FansInfo.h"
#import "ChatViewController.h"

@class WeiBoMessageManager;
@interface FansViewController : UITableViewController {
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
    NSMutableArray *likersArray;
    int currentPage;
    int maxPage;
    ChatViewController *commChatV;
}

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;

@end
