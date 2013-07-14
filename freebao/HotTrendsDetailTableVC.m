//
//  HotTrendsDetailTableVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-10.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "HotTrendsDetailTableVC.h"

@implementation HotTrendsDetailTableVC
@synthesize qureyString;

-(void)dealloc
{
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"热门话题";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)didGetTopicSearchResult:(NSNotification*)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    [statuesArr removeAllObjects];
    self.statuesArr = sender.object;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshVisibleCellsImages];
}

@end
