//
//  MoreViewController.h
//  freebao
//
//  Created by freebao on 13-7-11.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreTableViewCell.h"
#import "ProfileViewController.h"
#import "MyPageViewController.h"
#import "PageViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "SearchViewController.h"
#import "PeopleUMayKnowViewController.h"

@interface MoreViewController : UITableViewController {
    UILabel *tittleLabel;
    UIButton *backButton;
    UIView *tittleView;
    UIView *tittleLineView;
}

@end
