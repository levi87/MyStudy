//
//  HomeLineViewController.h
//  freebao
//
//  Created by levi on 13-5-31.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusViewContrillerBase.h"
#import "TwitterVC.h"
#import "OAuthWebView.h"

@interface HomeLineViewController : StatusViewContrillerBase
{
    NSString *userID;
    int _page;
    long long _maxID;
    BOOL _shouldAppendTheDataArr;
}
@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain) NSTimer *timer;
@end
