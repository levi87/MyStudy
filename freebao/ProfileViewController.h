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
#import "PersonInfo.h"
#import "NSDictionaryAdditions.h"

@class WeiBoMessageManager;
@class EGOImageView;
@interface ProfileViewController : UITableViewController {
    WeiBoMessageManager *manager;
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
    
    NSMutableArray *headImageArray;
    EGOImageView *headImageView;
    NSMutableArray *itemsArray;
}
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *userAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *headViewButton;
@property (weak, nonatomic) IBOutlet UIScrollView *headerImagesScrollView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addAction:(id)sender;
@end
