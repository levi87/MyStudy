//
//  AtPostViewController.m
//  freebao
//
//  Created by freebao on 13-8-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "AtPostViewController.h"

#define FB_SET_AT_NAME @"fb_set_at_name"

@interface AtPostViewController ()

@end

@implementation AtPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isRefresh = FALSE;
    currentPage = 0;
    isFirst = TRUE;
    likersArray = [[NSMutableArray alloc] init];
    NSLog(@"likeruser.........");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBFollowerListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapHeadIcon:) name:TAP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfRequest:) name:FB_GET_FOLLOWER_LIST object:nil];
    
    headPhotos = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.atTableView setTableHeaderView:headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAtTableView:nil];
    [super viewDidUnload];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y >= fmaxf(0.f, scrollView.contentSize.height - scrollView.frame.size.height) + 40.f) {
        NSLog(@"current page %d max page %d", maxPage, currentPage);
        if (currentPage + 1 >= maxPage) {
            return;
        }
        currentPage ++;
        if (manager == nil) {
            manager = [WeiBoMessageManager getInstance];
        }
        [manager FBFollowerListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)resultOfRequest:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    NSLog(@"[levi] %@", [notification.userInfo objectForKey:@"maxCount"]);
    maxPage = [[notification.userInfo objectForKey:@"maxCount"] integerValue];
    if (currentPage == 0) {
        [likersArray removeAllObjects];
        headPhotos = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        FansInfo *tmpInfo = [[FansInfo alloc] init];
        tmpInfo.userName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.userId = [tmpDic objectForKey:@"userId"];
        tmpInfo.userFacePath = [tmpDic objectForKey:@"facePath"];
        [likersArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.atTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [likersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:(FansInfo*)[likersArray objectAtIndex:indexPath.row]];
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"at some......");
    FansInfo *tmpFaninfo = [likersArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:FB_SET_AT_NAME object:tmpFaninfo.userName];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
