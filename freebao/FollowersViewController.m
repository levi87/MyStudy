//
//  FollowersViewController.m
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "FollowersViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#import "AppDelegate.h"

#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface FollowersViewController ()

@end

@implementation FollowersViewController
@synthesize cellContentIdFollow = _cellContentIdFollow;
@synthesize isRefreshFollow = _isRefreshFollow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isRefreshFollow = FALSE;
    currentPageFollow = 0;
    isFirstFollow = TRUE;
    followersArray = [[NSMutableArray alloc] init];
    NSLog(@"likeruser.........");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBFansListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPageFollow PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapHeadIcon:) name:TAP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfFollowersRequest:) name:FB_GET_FANS_LIST object:nil];
    
    headPhotosFollow = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tittleLabel.textAlignment = UITextAlignmentCenter;
    [_tittleLabel setBackgroundColor:[UIColor clearColor]];
    _tittleLabel.text = @"Followers";
    _tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: _tittleLabel];
    _tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 80, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction)];
    tap.numberOfTapsRequired = 1;
    [imgV addGestureRecognizer:tap];
    [backButton addSubview:imgV];
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    [self.navigationController.view addSubview:backButton];
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    tittleView.hidden = YES;
    tittleLineView.hidden = YES;
    backButton.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y >= fmaxf(0.f, scrollView.contentSize.height - scrollView.frame.size.height) + 40.f) {
        NSLog(@"current page %d max page %d", maxPageFollow, currentPageFollow);
        if (currentPageFollow + 1 >= maxPageFollow) {
            return;
        }
        currentPageFollow ++;
        if (manager == nil) {
            manager = [WeiBoMessageManager getInstance];
        }
        [manager FBFansListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPageFollow PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)resultOfFollowersRequest:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
//    NSLog(@"tmpArray Array %@", tmpArray);
//    NSLog(@"[levi] %@", [notification.userInfo objectForKey:@"maxCount"]);
    maxPageFollow = [[notification.userInfo objectForKey:@"maxCount"] integerValue];
    if (currentPageFollow == 0) {
        [followersArray removeAllObjects];
        headPhotosFollow = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        FollowerInfo *tmpInfo = [[FollowerInfo alloc] init];
        tmpInfo.userName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.userId = [tmpDic objectForKey:@"userId"];
        tmpInfo.userFacePath = [tmpDic objectForKey:@"facePath"];
        [followersArray addObject:tmpInfo];
        [headPhotosFollow addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.tableView reloadData];
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
    return [followersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:(FollowerInfo*)[followersArray objectAtIndex:indexPath.row]];
    [cell setHeadPhoto:[headPhotosFollow objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
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
