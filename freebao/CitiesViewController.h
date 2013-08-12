//
//  CitiesViewController.h
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitiesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_contactsArray;
    NSArray *_keys;
    
    UIView *tittleView;
    UIView *tittleLineView;
}

@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@end
