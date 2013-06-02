//
//  MetionsStatusesVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-21.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "MetionsStatusesVC.h"

@interface MetionsStatusesVC ()

@end

@implementation MetionsStatusesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"消息";
//    [self.navigationController.navigationBar setHidden:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    MessageUIView *titleView = [MessageUIView instanceTitleView];
    titleView.delegate = self;
    [self.navigationItem setTitleView:titleView];
//    [defaultNotifCenter addObserver:self selector:@selector(didGetMetionsStatus:)    name:MMSinaGotMetionsStatuses   object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetMetionsStatus:)    name:FB_GET_MENTION   object:nil];
}

- (void)viewDidUnload
{
//    [defaultNotifCenter removeObserver:self name:MMSinaGotMetionsStatuses object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_MENTION object:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.statuesArr != nil) {
        return;
    }
    
//    [manager getMetionsStatuses];
    [manager FBGetMentionsWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

- (void)returnValueToShow:(id)sender {
    UIButton *btn = sender;
    NSString *tmpStr = btn.restorationIdentifier;
    if ([tmpStr isEqualToString:@"atBtn"]) {
        NSLog(@"atButton");
    } else if ([tmpStr isEqualToString:@"mentionsBtn"]) {
        NSLog(@"mentionButton");
    } else if ([tmpStr isEqualToString:@"messageBtn"]) {
        NSLog(@"messageButton");
    } else if ([tmpStr isEqualToString:@"noticeBtn"]) {
        NSLog(@"noticeButton");
    }
}

-(void)didGetMetionsStatus:(NSNotification*)sender
{    
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    [statuesArr removeAllObjects];
    self.statuesArr = sender.object;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
    [self refreshVisibleCellsImages];
}

-(void)refresh {
    NSLog(@"[levi]mentions refresh....");
}

@end
