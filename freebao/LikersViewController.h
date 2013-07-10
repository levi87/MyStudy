//
//  LikersViewController.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikersCell.h"
#import "AppDelegate.h"
#import "BlankCell.h"
#import "WeiBoMessageManager.h"
#import "LikerInfo.h"

@class WeiBoMessageManager;
@interface LikersViewController : UITableViewController {
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *likersArray;
}

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;

@end
