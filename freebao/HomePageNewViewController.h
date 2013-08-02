//
//  HomePageNewViewController.h
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "CommentInfo.h"
#import "StatusNewCell.h"
#import "StatusNewImageCell.h"
#import "StatusInfo.h"

@class WeiBoMessageManager;
@interface HomePageNewViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,StatusNewCellDelegate,StatusNewImageCellDelegate> {
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *statusArray;
}

@property (strong, nonatomic) IBOutlet UITableView *homeTableView;

@property NSString *cellContentId;
@property BOOL isRefresh;
@end
