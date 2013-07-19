//
//  LikersViewController.m
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "LikersViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#define TAP_NOTIFICATION @"tap_notification"

@interface LikersViewController ()

@end

@implementation LikersViewController
@synthesize cellContentId = _cellContentId;
@synthesize isRefresh = _isRefresh;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tapHeadIcon:(NSNotification*)notification {
    NSLog(@"[levi] tapHeadIcon");
}

-(void)resultOfRequest:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    [likersArray removeAllObjects];
    headPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        LikerInfo *tmpInfo = [[LikerInfo alloc] init];
        tmpInfo.nickName = [tmpDic objectForKey:@"url"];
        tmpInfo.sex = [tmpDic objectForKey:@"userGender"];
        tmpInfo.age = [tmpDic objectForKey:@"age"];
        tmpInfo.city = [tmpDic objectForKey:@"city"];
        [likersArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.tableView reloadData];
}

-(void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isRefresh = FALSE;
    isFirst = TRUE;
//    UIView *TittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [TittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
//    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    tittleLabel.textAlignment = UITextAlignmentCenter;
//    [tittleLabel setBackgroundColor:[UIColor clearColor]];
//    tittleLabel.text = @"Likers";
//    tittleLabel.textColor = [UIColor whiteColor];
//    [TittleView addSubview: tittleLabel];
//    tittleLabel.center = CGPointMake(160, 22);
//    UIView *TittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
//    [TittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
//    [self.navigationController.view addSubview:TittleView];
//    [self.navigationController.view addSubview:TittleLineView];
    likersArray = [[NSMutableArray alloc] init];
    NSLog(@"likeruser.........");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetLikersWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:_cellContentId Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapHeadIcon:) name:TAP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfRequest:) name:FB_GET_LIKERS object:nil];

    headPhotos = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
}

- (void)clearCache {
//    [[EGOCache currentCache] clearCache];
//	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"LikersCell";
    LikersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LikersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:(LikerInfo*)[likersArray objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)viewWillAppear:(BOOL)animated {
//    [KAppDelegate.tabBarVC.tabbar setHide:YES];
    if (_isRefresh) {
        [manager FBGetLikersWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:_cellContentId Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
