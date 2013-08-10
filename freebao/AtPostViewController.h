//
//  AtPostViewController.h
//  freebao
//
//  Created by freebao on 13-8-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "FansCell.h"
#import "FansInfo.h"

@class WeiBoMessageManager;
@interface AtPostViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
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
}

@property NSString *cellContentId;
@property BOOL isRefresh;
@property (weak, nonatomic) IBOutlet UITableView *atTableView;

-(void)clearCache;
- (IBAction)backAction:(id)sender;

@end
