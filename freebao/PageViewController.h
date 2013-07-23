//
//  PageViewController.h
//  freebao
//
//  Created by freebao on 13-7-23.
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
#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface PageViewController : StatusViewContrillerBase <AVAudioPlayerDelegate>
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
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain) NSTimer *timer;

@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
