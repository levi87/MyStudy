//
//  MessageViewController.h
//  freebao
//
//  Created by levi on 13-6-1.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MetionsStatusesVC.h"

@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *sliderBar;
@property (weak, nonatomic) IBOutlet UIView *titleView;
- (IBAction)navigationTabClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *CommonUseView;

@end
