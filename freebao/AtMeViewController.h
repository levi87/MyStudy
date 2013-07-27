//
//  AtMeViewController.h
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusViewContrillerBase.h"
#import "TwitterVC.h"
#import "LikersViewController.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "UserLocationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "URBSegmentedControl.h"
#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface AtMeViewController : StatusViewContrillerBase <AVAudioPlayerDelegate>
{
    NSString *userID;
    int _page;
    long long _maxID;
    BOOL _shouldAppendTheDataArr;
    UILabel *tittleLabel;
    UIButton *backButton;
    
    LikersViewController *likeVC;
    CommentViewController *commentVC;
    StatusCell *tmpStatusCell;
    StatusCell *tmpStatusCellL;
    
    UIView *TittleView;
    UIView *TittleLineView;
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain) NSTimer *timer;

@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
