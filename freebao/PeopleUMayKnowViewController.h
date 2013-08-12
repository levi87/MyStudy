//
//  PeopleUMayKnowViewController.h
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleMayKnowCell.h"

#import "WeiBoMessageManager.h"
@class WeiBoMessageManager;
@interface PeopleUMayKnowViewController : UITableViewController {
    WeiBoMessageManager *manager;
    NSString *_cellContentIdPeople;
    BOOL _isRefreshPeople;
    BOOL isFirstPeople;
    
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIView *tittleView;
    UIView *tittleLineView;
@private
    NSMutableArray *headPhotosPeople;
    NSMutableArray *peopleArray;
    int currentPagePeople;
    int maxPagePeople;
}

@property NSString *cellContentIdPeople;
@property BOOL isRefreshPeople;

-(void)clearCache;

@end
