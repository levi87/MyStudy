//
//  PeopleUMayKnowViewController.m
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PeopleUMayKnowViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#import "AppDelegate.h"

#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface PeopleUMayKnowViewController ()

@end

@implementation PeopleUMayKnowViewController
@synthesize cellContentIdPeople = _cellContentIdPeople;
@synthesize isRefreshPeople = _isRefreshPeople;

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

-(void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_PEOPLE_YOU_MAY_KNOW object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isRefreshPeople = FALSE;
    currentPagePeople = 0;
    isFirstPeople = TRUE;
    peopleArray = [[NSMutableArray alloc] init];
    NSLog(@"likeruser.........");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBYouMayKnowWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PageSize:@"20" PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapHeadIcon:) name:TAP_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfFollowersRequest:) name:FB_PEOPLE_YOU_MAY_KNOW object:nil];
    
    headPhotosPeople = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tittleLabel.textAlignment = UITextAlignmentCenter;
    [_tittleLabel setBackgroundColor:[UIColor clearColor]];
    _tittleLabel.text = @"People you may know";
    _tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: _tittleLabel];
    _tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,9, 51, 26)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back_normal"] forState:UIControlStateNormal];
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
        NSLog(@"current page %d max page %d", maxPagePeople, currentPagePeople);
        if (currentPagePeople + 1 >= maxPagePeople) {
            return;
        }
        currentPagePeople ++;
        if (manager == nil) {
            manager = [WeiBoMessageManager getInstance];
        }
        [manager FBYouMayKnowWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PageSize:@"20" PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)resultOfFollowersRequest:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    //    NSLog(@"tmpArray Array %@", tmpArray);
    //    NSLog(@"[levi] %@", [notification.userInfo objectForKey:@"maxCount"]);
        [peopleArray removeAllObjects];
        headPhotosPeople = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        PeopleMayKnowInfo *tmpInfo = [[PeopleMayKnowInfo alloc] init];
        tmpInfo.userName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.userId = [tmpDic objectForKey:@"userId"];
        tmpInfo.userFacePath = [tmpDic objectForKey:@"facePath"];
        [peopleArray addObject:tmpInfo];
        [headPhotosPeople addObject:[tmpDic objectForKey:@"facePath"]];
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
    return [peopleArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PeopleMayKnowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PeopleMayKnowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:(PeopleMayKnowInfo*)[peopleArray objectAtIndex:indexPath.row]];
    [cell setHeadPhoto:[headPhotosPeople objectAtIndex:indexPath.row]];
    
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
