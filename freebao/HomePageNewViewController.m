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
    [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.homeTableView setTableHeaderView:headerView];
}

- (void)onRequestHomeLine:(NSNotification*)notification {
    NSLog(@"new status...");
    NSMutableArray *tmpArray = notification.object;
    statusArray = tmpArray;
    [self.homeTableView reloadData];
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
    StatusInfo *tmpSI = [statusArray objectAtIndex:indexPath.row];
    NSString *hasImage = tmpSI.originalPicUrl;
//    NSLog(@"has image %@", hasImage);
    if (![hasImage isEqualToString:@"0"]) {
        static NSString *CellIdentifier = @"StatusImageCell";
        StatusNewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StatusNewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setCellValue:(StatusInfo*)[statusArray objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        cell.indexPath = indexPath;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"StatusCell";
        StatusNewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StatusNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setCellValue:(StatusInfo*)[statusArray objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        cell.indexPath = indexPath;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tmpHeight;
    CGFloat forwordHeight;
    CGFloat commentsHeight;
    StatusInfo *tmpInfo = [statusArray objectAtIndex:indexPath.row];
    tmpHeight = [StatusNewCell getJSHeight:tmpInfo.content jsViewWith:300.0];
//    NSLog(@"tmpHeight %f", tmpHeight);
    if (tmpInfo.rePostDic != nil) {
        NSDictionary *forwordDic = tmpInfo.rePostDic;
        NSString *nickName = [forwordDic getStringValueForKey:@"user_name" defaultValue:@""];
    forwordHeight = [StatusNewCell getJSHeight:[NSString stringWithFormat:@"@%@ %@", nickName, [forwordDic getStringValueForKey:@"text" defaultValue:@""]] jsViewWith:300.0];
    } else {
        forwordHeight = 0.0;
    }
    NSInteger cCount = [tmpInfo.commentCount integerValue];
    NSLog(@"comment count %d  row %d", cCount, indexPath.row);
    if (cCount == 0) {
        commentsHeight = 0.0;
    } else if (cCount == 1) {
        commentsHeight = 35.0;
    } else if (cCount == 2) {
        commentsHeight = 60.0;
    } else if (cCount >= 3) {
        commentsHeight = 100.0;
    }
    NSString *hasImage = tmpInfo.originalPicUrl;
    if (![hasImage isEqualToString:@"0"]) {
        return 25 + tmpHeight + 50 + 30 + 330 + forwordHeight + commentsHeight;
    } else {
        return 25 + tmpHeight + 50 + 30 + forwordHeight + commentsHeight;
    }
}

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
}

-(void)cellAddLikeDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"cell like tap");
    NSInteger isLiked = [theCell.statusInfo.liked integerValue];
    if (isLiked == 1) {
        [manager FBAddLikeWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:theCell.statusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    } else {
        [manager FBUnLikeWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:theCell.statusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
}

-(void)imageCellAddLikeDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image cell like tap");
    NSInteger isLiked = [theCell.statusInfo.liked integerValue];
    if (isLiked == 1) {
        [manager FBAddLikeWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:theCell.statusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    } else {
        [manager FBUnLikeWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:theCell.statusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
}

-(void)cellMoreDidTaped:(StatusNewCell *)theCell {
    NSLog(@"cell more tap");
    CustomActionSheet *as = [[CustomActionSheet alloc] init];
    [as addButtonWithTitle:@"收藏"];
    [as addButtonWithTitle:@"举报"];
    [as addButtonWithTitle:@"删除"];
    [as showInView:self.view];
}

-(void)imageCellMoreDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image cell more tap");
    CustomActionSheet *as = [[CustomActionSheet alloc] init];
    [as addButtonWithTitle:@"收藏"];
    [as addButtonWithTitle:@"举报"];
    [as addButtonWithTitle:@"删除"];
    [as showInView:self.view];
}

-(void)cellLikerDidTaped:(StatusNewCell *)theCell {
    NSLog(@"liker tap");
    if (likeVC == nil) {
        likeVC = [[LikersViewController alloc] init];
    } else {
        [likeVC setIsRefresh:YES];
    }
    likeVC.cellContentId = theCell.statusInfo.contentId;
//    tittleLabel.text = @"Likers";
//    backButton.hidden = NO;
    [self.navigationController pushViewController:likeVC animated:YES];
}

-(void)imageCellLikerDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image liker tap");
    if (likeVC == nil) {
        likeVC = [[LikersViewController alloc] init];
    } else {
        [likeVC setIsRefresh:YES];
    }
    likeVC.cellContentId = theCell.statusInfo.contentId;
//    tittleLabel.text = @"Likers";
//    backButton.hidden = NO;   
    [self.navigationController pushViewController:likeVC animated:YES];
}

-(void)cellCommentDidTaped:(StatusNewCell *)theCell {
    NSLog(@"comment tap");
}

-(void)imageCellCommentDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image commnet tap");
}
@end
