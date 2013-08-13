//
//  CityUserViewController.h
//  freebao
//
//  Created by freebao on 13-8-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityUserInfo.h"
#import "WeiBoMessageManager.h"
#import "CityUserCell.h"

@class WeiBoMessageManager;
@interface CityUserViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    WeiBoMessageManager *manager;
    NSString *_aCityName;
    
    NSMutableArray *headPhotosPeople;
    NSMutableArray *peopleArray;
    
    UILabel *_tittleLabel;
    UIView *tittleView;
    UIView *tittleLineView;
    
    BOOL _isRefreshPeople;
    int currentPage;
    int maxPage;
    UILabel *tittleLabel;
}

@property (nonatomic, retain) NSString *aCityName;
@property BOOL isRefreshPeople;
@property (weak, nonatomic) IBOutlet UITableView *cityUserTableView;

@end
