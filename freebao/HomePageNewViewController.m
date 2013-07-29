//
//  HomePageNewViewController.m
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "HomePageNewViewController.h"
#import "EGOCache.h"
#import "NSDictionaryAdditions.h"

#import "StatusNewCell.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#define COMMENT_VOICE @"fb_comment_voice"

#define HIDE_KEYBOARD @"fb_hide_keyboard"

@interface HomePageNewViewController ()

@end

@implementation HomePageNewViewController
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

-(void)didGetComments:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    [statusArray removeAllObjects];
    headPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        CommentInfo *tmpInfo = [[CommentInfo alloc] init];
        tmpInfo.nickName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.content = [tmpDic objectForKey:@"commentBody"];
        tmpInfo.contentId = [tmpDic objectForKey:@"contentId"];
        tmpInfo.commentId = [tmpDic objectForKey:@"commentId"];
        tmpInfo.commentDate = [tmpDic objectForKey:@"historyInfo"];
        tmpInfo.voiceUrl = [tmpDic getStringValueForKey:@"soundPath" defaultValue:@"0"];
        tmpInfo.voiceLength = [tmpDic getStringValueForKey:@"soundTime" defaultValue:@"0"];
        NSLog(@"voiceUrl %@", tmpInfo.voiceUrl);
        [statusArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.homeTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isRefresh = FALSE;
    isFirst = TRUE;
    statusArray = [[NSMutableArray alloc] init];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestHomeLine:) name:FB_GET_HOMELINE_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetComments:) name:FB_GET_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddComments:) name:FB_ADD_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVoice:) name:COMMENT_VOICE object:nil];
//    [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.homeTableView setTableHeaderView:headerView];
}

- (void)onRequestHomeLine:(NSNotification*)notification {
    NSLog(@"new status...");
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
    return [statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasImage = YES;
    if (hasImage) {
        static NSString *CellIdentifier = @"StatusImageCell";
        StatusNewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StatusNewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellValue:(CommentInfo*)[statusArray objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        //    cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
        // Configure the cell...
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"StatusCell";
        StatusNewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StatusNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellValue:(CommentInfo*)[statusArray objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        //    cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
        // Configure the cell...
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tmpHeight;
    CommentInfo *tmpInfo = [statusArray objectAtIndex:indexPath.row];
    tmpHeight = [StatusNewCell getJSHeight:tmpInfo.content jsViewWith:230.0];
    NSLog(@"tmpHeight %f", tmpHeight);
    return 23 + tmpHeight + 25 + 30 + 330;
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

- (void)viewDidUnload {
    [self setHomeTableView:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_HOMELINE_NEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_ADD_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMMENT_VOICE object:nil];
}
@end
