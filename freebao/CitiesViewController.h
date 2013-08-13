//
//  CitiesViewController.h
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "CityUserViewController.h"
@class WeiBoMessageManager;
@interface CitiesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    WeiBoMessageManager *manager;
    NSMutableArray *_contactsArray;
    NSArray *_keys;
    
    UIView *tittleView;
    UIView *tittleLineView;
    NSMutableArray *_dataArr;
    CityUserViewController *commCityUserView;
}

@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@end
