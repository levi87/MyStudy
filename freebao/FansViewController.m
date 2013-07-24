//
//  FansViewController.m
//  freebao
//
//  Created by freebao on 13-7-24.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "FansViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface FansViewController ()

@end

@implementation FansViewController
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
    [self.tableView setTableHeaderView:headerView];
    
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tittleLabel.textAlignment = UITextAlignmentCenter;
    [_tittleLabel setBackgroundColor:[UIColor clearColor]];
    _tittleLabel.text = @"Test";
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
        NSLog(@"current page %d max page %d", maxPage, currentPage);
        if (maxPage > currentPage + 1) {
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
