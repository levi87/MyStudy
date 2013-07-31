//
//  ConversationViewController.m
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ConversationViewController.h"
#import "HomePageNewViewController.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define RECEIVE_REFRESH_VIEW @"fb_receive_msg"

#define  SHOW_LANGUAGE_MENU @"fb_language_menu"

#import "AppDelegate.h"

#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tittleView.hidden = NO;
    tittleLineView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
    
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"Chats";
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    UIButton *newConversationButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 50, 20)];
    newConversationButton.titleLabel.text = @" + ";
    newConversationButton.backgroundColor = [UIColor whiteColor];
    [newConversationButton addTarget:self action:@selector(createNewConversation) forControlEvents:UIControlEventTouchUpInside];
    [tittleView addSubview:newConversationButton];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:headerView];
    conversationArray = [[NSMutableArray alloc] init];

    headPhotos = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfRequest:) name:FB_GET_CONVERSATION object:nil];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetConversationListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)createNewConversation {
    NSLog(@"[levi] create...");
//    FansViewController *fanVC = [[FansViewController alloc] init];
//    [self.navigationController pushViewController:fanVC animated:YES];
    HomePageNewViewController *homeP = [[HomePageNewViewController alloc] init];
    [self.navigationController pushViewController:homeP animated:YES];
}

-(void)resultOfRequest:(NSNotification*)notification {
    [self stopRefresh];
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"Conversation Array %@", tmpArray);
    [conversationArray removeAllObjects];
    headPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        ConversationInfo *tmpInfo = [[ConversationInfo alloc] init];
        tmpInfo.fromUserName = [tmpDic getStringValueForKey:@"chat_user_name" defaultValue:@""];
        tmpInfo.fromUid = [tmpDic getStringValueForKey:@"chat_user_id" defaultValue:@"0"];
        tmpInfo.fromUserFace = [tmpDic getStringValueForKey:@"chat_user_face" defaultValue:@""];
        tmpInfo.date = [tmpDic getStringValueForKey:@"create_at" defaultValue:@""];
        tmpInfo.content = [tmpDic getStringValueForKey:@"text" defaultValue:@""];
        [conversationArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic getStringValueForKey:@"chat_user_face" defaultValue:@""]];
    }
    [self.tableView reloadData];
}

//- (void)backButtonAction {
//    NSLog(@"[levi]back...");
//    backButton.hidden = YES;
//    languageButton.hidden = YES;
//    tittleLabel.text = @"Chats";
//    [[NSNotificationCenter defaultCenter] removeObserver:KAppDelegate.commChat.self name:RECEIVE_REFRESH_VIEW object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)languageMenuAction {
//    NSLog(@"[levi]");
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LANGUAGE_MENU object:nil];
//}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
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
    return [conversationArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConversationCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:[conversationArray objectAtIndex:indexPath.row]];
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    
    return cell;
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
    if (KAppDelegate.commChat == nil) {
        KAppDelegate.commChat = [[ChatViewController alloc] init];
    } else {
        KAppDelegate.commChat.isFirst = FALSE;
        KAppDelegate.commChat.isReload = TRUE;
    }
    ConversationInfo *tmpConversation = [conversationArray objectAtIndex:indexPath.row];
    [KAppDelegate.commChat setToUserId:tmpConversation.fromUid];
    [KAppDelegate.commChat.tittleLabel setText:tmpConversation.fromUserName];
    tittleView.hidden = YES;
    tittleLineView.hidden = YES;
    //        if (commentVC == nil) {
    //            commentVC = [[CommentsViewController alloc] init];
    //        }
    //        tittleLabel.text = @"Test";
    //        backButton.hidden = NO;
    //        languageButton.hidden = NO;
    [self.navigationController pushViewController:KAppDelegate.commChat animated:YES];
}

#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	refreshFooterView.hidden = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
//        [self refreshVisibleCellsImages];
    }
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
    {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)stopRefresh {
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
    NSLog(@"[levi] is loading data.......");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetConversationListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
