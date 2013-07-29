//
//  ProfileViewController.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"
#import "WeiBoMessageManager.h"

@class WeiBoMessageManager;
@interface ProfileViewController : UITableViewController {
    WeiBoMessageManager *manager;
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
    
    NSMutableArray *headImageArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *headerImagesScrollView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addAction:(id)sender;
@end
