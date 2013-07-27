//
//  PageViewController.m
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PageViewController.h"
#import "ZJTHelpler.h"
#import "ZJTStatusBarAlertWindow.h"
#import "CoreDataManager.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define FONT @"HelveticaNeue-Light"

#define HOME_PAGE 0
#define FAV_PAGE 1
#define FOLLOW_PAGE 2
#define FANS_PAGE 3
#define PHOTO_PAGE 4

@interface PageViewController ()
-(void)getDataFromCD;

@end

@implementation PageViewController
@synthesize userID;
@synthesize timer;
@synthesize avPlay = _avPlay;
//Fans
@synthesize cellContentId = _cellContentId;
@synthesize isRefresh = _isRefresh;
//Follow
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentView = HOME_PAGE;

    [self initSegment];
    [self initFansView];
    [self initFollowView];
    NSLog(@"[levi]view didload");
    refreshFooterView.hidden = NO;
    _page = 1;
    _maxID = -1;
    _shouldAppendTheDataArr = NO;
    //    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:@"发微博" style:UIBarButtonItemStylePlain target:self action:@selector(twitter)];
    //    self.navigationItem.rightBarButtonItem = retwitterBtn;
    UIView *TittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [TittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"Profile";
    [tittleLabel setFont:[UIFont fontWithName:FONT size:15]];
    tittleLabel.textColor = [UIColor whiteColor];
    [TittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 80, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction)];
    tap.numberOfTapsRequired = 1;
    [imgV addGestureRecognizer:tap];
    [backButton addSubview:imgV];
    UIView *TittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [TittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:TittleView];
    [self.navigationController.view addSubview:TittleLineView];
    [self.navigationController.view addSubview:backButton];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:self.profileHeaderView];
    [self.tableView setTableFooterView:headerView];
    
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:FB_GET_HOMELINE          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:FB_GET_USERINFO          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUnreadCount:) name:FB_GET_UNREAD_COUNT       object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(onRequestVoiceResult:) name:FB_GET_TRANSLATION_VOICE object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(onRequestResult:)       name:FB_GET_TRANSLATION object:nil];
    
    [defaultNotifCenter addObserver:self selector:@selector(appWillResign:)            name:UIApplicationWillResignActiveNotification             object:nil];
}

-(void)initFansView {
    _isRefresh = FALSE;
    currentPage = 0;
    isFirst = TRUE;
    likersArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfFansRequest:) name:FB_GET_FOLLOWER_LIST object:nil];
    
    headPhotos = [[NSMutableArray alloc] init];
}

-(void)initFollowView{
    _isRefreshFollow = FALSE;
    currentPageFollow = 0;
    isFirstFollow = TRUE;
    followersArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfFollowersRequest:) name:FB_GET_FANS_LIST object:nil];
    headPhotosFollow = [[NSMutableArray alloc] init];
}

-(void)resultOfFansRequest:(NSNotification*)notification {
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (currentView == FANS_PAGE) {
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
    } else if (currentView == FOLLOW_PAGE) {
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
    } else if (currentView == HOME_PAGE) {
        if (!decelerate)
        {
            [self refreshVisibleCellsImages];
        }
        
        if (scrollView.contentOffset.y < 200)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        else
            [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)initSegment {
    // items to be used for each segment (same as UISegmentControl) for all instances
	NSArray *titles = [NSArray arrayWithObjects:[@"Post" uppercaseString], [@"Far." uppercaseString], [@"Follow" uppercaseString], [@"Fans" uppercaseString], [@"Photo" uppercaseString], nil];
	
	//
	// Basic horizontal segmented control
	//
	URBSegmentedControl *control = [[URBSegmentedControl alloc] initWithItems:titles];
	control.frame = CGRectMake(-1, 367.0, 322.0, 80.0);
	control.segmentBackgroundColor = [UIColor blueColor];
	[control setSegmentBackgroundColor:[UIColor whiteColor] atIndex:2];
	[self.profileHeaderView addSubview:control];
	
	// UIKit method of handling value changes
	[control addTarget:self action:@selector(handleSelection:) forControlEvents:UIControlEventValueChanged];
	// block-based value change handler
	[control setControlEventBlock:^(NSInteger index, URBSegmentedControl *segmentedControl) {
		NSLog(@"URBSegmentedControl: control block - index=%i", index);
        //        int count = [KAppDelegate.tabBarVC.arrayViewcontrollers count];
        //        NSLog(@"[count] count...%d", count);
        if (index == 0) {
            NSLog(@"home page");
            currentView = HOME_PAGE;
        } else if (index == 1) {
            NSLog(@"fav. page");
            currentView = FAV_PAGE;
        } else if (index == 2) {
            NSLog(@"follow");
            [statuesArr removeAllObjects];
            [followersArray removeAllObjects];
            [likersArray removeAllObjects];
            [self.tableView reloadData];
            currentView = FOLLOW_PAGE;
            if (manager == nil) {
                manager = [WeiBoMessageManager getInstance];
            }
            [manager FBFansListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPageFollow PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        } else if (index == 3) {
            NSLog(@"fans");
            [statuesArr removeAllObjects];
            [likersArray removeAllObjects];
            [followersArray removeAllObjects];
            [self.tableView reloadData];
            currentView = FANS_PAGE;
            if (manager == nil) {
                manager = [WeiBoMessageManager getInstance];
            }
            [manager FBFollowerListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        } else if (index == 4) {
            NSLog(@"photo");
            currentView = PHOTO_PAGE;
        }
	}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentView == FANS_PAGE) {
        return [likersArray count];
    } else if (currentView == FOLLOW_PAGE) {
        return [followersArray count];
    }
    return [statuesArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentView == FANS_PAGE || currentView == FOLLOW_PAGE) {
        return 58;
    }
    NSInteger  row = indexPath.row;
    
    if (row >= [statuesArr count]) {
        return 1;
    }
    
    Status *status          = [statuesArr objectAtIndex:row];
    Status *retwitterStatus = status.retweetedStatus;
    NSString *url = status.retweetedStatus.thumbnailPic;
    NSString *url2 = status.thumbnailPic;
    
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    [cell updateCellTextWith:status];
    
    CGFloat height = 0.0f;
    
    //有转发的博文
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]])
    {
        height = [cell setTFHeightWithImage:NO
                         haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO Status:status];//计算cell的高度
    }
    
    //无转发的博文
    else
    {
        height = [cell setTFHeightWithImage:url2 != nil && [url2 length] != 0 ? YES : NO
                         haveRetwitterImage:NO Status:status];//计算cell的高度
    }
    //    [cell setCommentPosition:cell.frame.size.height];
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    NSInteger  row = indexPath.row;
    if (row >= [statuesArr count]) {
        //        NSLog(@"didSelectRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return ;
    }
    
    ZJTDetailStatusVC *detailVC = [[ZJTDetailStatusVC alloc] initWithNibName:@"ZJTDetailStatusVC" bundle:nil];
    Status *status  = [statuesArr objectAtIndex:row];
    detailVC.status = status;
    
    detailVC.avatarImage = status.user.avatarImage;
    detailVC.contentImage = status.statusImage;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)handleSelection:(id)sender {
	NSLog(@"URBSegmentedControl: value changed");
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    tittleLabel.text = @"Profile";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setProfileHeaderView:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_HOMELINE object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_USERINFO object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_UNREAD_COUNT object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_TRANSLATION_VOICE object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_TRANSLATION object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_FANS_LIST object:nil];
    [defaultNotifCenter removeObserver:self name:FB_GET_FOLLOWER_LIST object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[levi]viewWillAppear...");
    [super viewWillAppear:animated];
    if (shouldLoad)
    {
        shouldLoad = NO;
        //        [manager getUserID];
        //        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
        //        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [manager FBGetUserInfoWithUsetId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [manager FBGetHomeline:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)getDataFromCD
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"homePageMaxID"];
    if (number) {
        _maxID = number.longLongValue;
    }
    
    dispatch_queue_t readQueue = dispatch_queue_create("read from db", NULL);
    dispatch_async(readQueue, ^(void){
        if (!statuesArr || statuesArr.count == 0) {
            statuesArr = [[NSMutableArray alloc] initWithCapacity:70];
            NSArray *arr = [[CoreDataManager getInstance] readStatusesFromCD];
            if (arr && arr.count != 0) {
                for (int i = 0; i < arr.count; i++)
                {
                    StatusCDItem *s = [arr objectAtIndex:i];
                    Status *sts = [[Status alloc]init];
                    [sts updataStatusFromStatusCDItem:s];
                    if (i == 0) {
                        sts.isRefresh = @"YES";
                    }
                    [statuesArr insertObject:sts atIndex:s.index.intValue];
                }
            }
        }
        [[CoreDataManager getInstance] cleanEntityRecords:@"StatusCDItem"];
        [[CoreDataManager getInstance] cleanEntityRecords:@"UserCDItem"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    //    UIFont * font=[UIFont  systemFontOfSize:15];
    //    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    //    CGFloat height = size.height + 44;
    CGFloat height = [StatusCell getJSHeight:contentText jsViewWith:with];
    return height;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    static NSString *cellID = @"StatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentView == FANS_PAGE) {
        static NSString *CellIdentifier = @"FansCell";
        FansCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellValue:(FansInfo*)[likersArray objectAtIndex:indexPath.row]];
        [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
        return cell;
    } else if (currentView == FOLLOW_PAGE) {
        static NSString *CellIdentifier = @"FollowCell";
        FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FollowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setCellValue:(FollowerInfo*)[followersArray objectAtIndex:indexPath.row]];
        [cell setHeadPhoto:[headPhotosFollow objectAtIndex:indexPath.row]];
        
        // Configure the cell...
        
        return cell;
    }
    NSInteger  row = indexPath.row;
    
    //    if (row == 0 || row == [statuesArr count]) {
    //        static NSString *CellIdentifier = @"BlankCell";
    //        BlankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //        if (cell == nil) {
    //            cell = [[BlankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //        }
    //        return cell;
    //    }
    
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    //    [cell setCellLayout];
    
    if (row >= [statuesArr count]) {
        return cell;
    }
    
    Status *status = [statuesArr objectAtIndex:row];
    status.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    [cell updateCellTextWith:status];
    if (self.table.dragging == NO && self.table.decelerating == NO)
    {
        if (status.user.avatarImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
        }
        
        if (status.statusImage == nil)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:row];
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:row];
        }
    }
    cell.avatarImage.image = status.user.avatarImage;
    //    cell.contentImage.image = status.statusImage;
    cell.mainImageView.image = status.statusImage;
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell) {
        [[SHKActivityIndicator currentIndicator] hide];
        //        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    //    [cell setCommentPosition:cell.frame.size.height];
    return cell;
}

//上拉
-(void)refresh
{
    if (currentView == FANS_PAGE || currentView == FOLLOW_PAGE) {
        return;
    }
    //    [manager getHomeLine:-1 maxID:_maxID count:-1 page:_page baseApp:-1 feature:-1];
    NSLog(@"[levi]refresh page %d", _page);
    [manager FBGetHomeline:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:_page PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    _shouldAppendTheDataArr = YES;
}

-(void)appWillResign:(id)sender
{
    for (int i = 0; i < statuesArr.count; i++) {
        NSLog(@"i = %d",i);
        [[CoreDataManager getInstance] insertStatusesToCD:[statuesArr objectAtIndex:i] index:i isHomeLine:YES];
    }
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    if (statuesArr == nil || _shouldAppendTheDataArr == NO || _maxID < 0) {
        self.statuesArr = sender.object;
        Status *sts = [statuesArr objectAtIndex:0];
        _maxID = sts.statusId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxID] forKey:@"homePageMaxID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _page = 1;
    }
    else {
        [statuesArr addObjectsFromArray:sender.object];
    }
    _page++;
    refreshFooterView.hidden = NO;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
    [self refreshVisibleCellsImages];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    NSLog(@"[levi] didtrigger...");
    if (currentView == FANS_PAGE || currentView == FOLLOW_PAGE) {
        return;
    }
    _reloading = YES;
    //	[manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    [manager FBGetHomeline:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    _shouldAppendTheDataArr = NO;
}

-(void)didGetUnreadCount:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *num = [dic objectForKey:@"status"];
    
    NSLog(@"num = %@",num);
    if ([num intValue] == 0) {
        return;
    }
    
    [[ZJTStatusBarAlertWindow getInstance] showWithString:[NSString stringWithFormat:@"有%@条新微博",num]];
    [[ZJTStatusBarAlertWindow getInstance] performSelector:@selector(hide) withObject:nil afterDelay:10];
}


-(void)cellLikerDidTaped:(StatusCell *)theCell {
    if (likeVC == nil) {
        likeVC = [[LikersViewController alloc] init];
    } else {
        [likeVC setIsRefresh:YES];
    }
    Status *tmpS = [statuesArr objectAtIndex:theCell.cellIndexPath.row];
    likeVC.cellContentId = [NSString stringWithFormat:@"%lld", tmpS.statusId];
    tittleLabel.text = @"Likers";
    backButton.hidden = NO;
    [self.navigationController pushViewController:likeVC animated:YES];
}

-(void)cellCommentDidTaped:(StatusCell *)theCell {
    if (commentVC == nil) {
        commentVC = [[CommentViewController alloc] init];
    } else {
        [commentVC setIsRefresh:YES];
    }
    Status *tmpS = [statuesArr objectAtIndex:theCell.cellIndexPath.row];
    commentVC.cellContentId = [NSString stringWithFormat:@"%lld", tmpS.statusId];
    tittleLabel.text = @"Comments";
    backButton.hidden = NO;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)cellShowUserLocationTaped:(StatusCell *)theCell {
    if (KAppDelegate.commMap == nil) {
        KAppDelegate.commMap = [[UserLocationViewController alloc] init];
    }
    CLLocationCoordinate2D userCoordinate;
    NSLog(@"[levi] x %f y %f", theCell.tmpPoint.x, theCell.tmpPoint.y);
    userCoordinate.latitude = theCell.tmpPoint.x;
    userCoordinate.longitude = theCell.tmpPoint.y;
    [KAppDelegate.commMap setUserCoordinate:userCoordinate];
    [self presentModalViewController:KAppDelegate.commMap animated:YES];
}

-(void)cellPlayTranslateVoiceTaped:(StatusCell *)theCell {
    if (self.avPlay.playing) {
        [self.avPlay stop];
        Status *tmpStatus = [statuesArr objectAtIndex:tmpStatusCell.cellIndexPath.row];
        tmpStatus.isPlayTransVoice = NO;
        [statuesArr replaceObjectAtIndex:tmpStatusCell.cellIndexPath.row withObject:tmpStatus];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpStatusCell.cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [manager FBGetTranslateVoiceWithBody:theCell.contentTF.text Language:theCell.languageStr PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    tmpStatusCell = theCell;
    Status *tmpStatus = [statuesArr objectAtIndex:theCell.cellIndexPath.row];
    tmpStatus.isPlayTransVoice = YES;
    [statuesArr replaceObjectAtIndex:theCell.cellIndexPath.row withObject:tmpStatus];
    [theCell.playTranslateVoiceImageView startAnimating];
}

-(void)onRequestVoiceResult:(NSNotification*)notification {
    NSString *voiceUrl = notification.object;
    //    NSLog(@"[levi] voice url %@",voiceUrl);
    NSData *tmpVoiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:tmpVoiceData error:nil];
    self.avPlay = player;
    self.avPlay.delegate = self;
    [self.avPlay play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"[levi] play completed...");
    Status *tmpStatus = [statuesArr objectAtIndex:tmpStatusCell.cellIndexPath.row];
    tmpStatus.isPlayTransVoice = NO;
    [statuesArr replaceObjectAtIndex:tmpStatusCell.cellIndexPath.row withObject:tmpStatus];
    //    [tmpStatusCell.playTranslateVoiceImageView stopAnimating];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpStatusCell.cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)cellPlaySoundTaped:(StatusCell *)theCell {
    NSData *tmpVoiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theCell.soundPath]];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:tmpVoiceData error:nil];
    self.avPlay = player;
    [theCell.voiceImage startAnimating];
    [self.avPlay play];
}

-(void)cellLanguageSelectTaped:(StatusCell *)theCell {
    NSLog(@"select language...");
    tmpStatusCellL = theCell;
    [self languageMenuAction];
}

- (void)languageMenuAction {
    NSArray *menuItems =
    @[
    
    [KxMenuItem menuItem:@"中文"
                   image:[UIImage imageNamed:@"icon_chat_flag_cn"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"English"
                   image:[UIImage imageNamed:@"icon_chat_flag_e"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"日本語"
                   image:[UIImage imageNamed:@"icon_chat_flag_j"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"한국어"
                   image:[UIImage imageNamed:@"icon_chat_flag_k"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"España"
                   image:[UIImage imageNamed:@"icon_chat_flag_x"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"Français"
                   image:[UIImage imageNamed:@"icon_chat_flag_f"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"Deutsch"
                   image:[UIImage imageNamed:@"icon_chat_flag_d"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:@"русский"
                   image:[UIImage imageNamed:@"icon_chat_flag_p"]
                  target:self
                  action:@selector(pushMenuItem:)],
    ];
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(250, 24, 20, 10)
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *tmpKxM = sender;
    NSLog(@"tittle %@", tmpKxM.title);
    if ([tmpKxM.title isEqualToString:@"中文"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
        tmpStatusCellL.languageStr = @"zh_CN";
    } else if ([tmpKxM.title isEqualToString:@"English"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
        tmpStatusCellL.languageStr = @"en_US";
    } else if ([tmpKxM.title isEqualToString:@"日本語"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
        tmpStatusCellL.languageStr = @"ja_JP";
    } else if ([tmpKxM.title isEqualToString:@"한국어"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
        tmpStatusCellL.languageStr = @"ko_KR";
    } else if ([tmpKxM.title isEqualToString:@"España"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
        tmpStatusCellL.languageStr = @"es_ES";
    } else if ([tmpKxM.title isEqualToString:@"Français"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
        tmpStatusCellL.languageStr = @"fr_FR";
    } else if ([tmpKxM.title isEqualToString:@"Deutsch"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_d"]];
        tmpStatusCellL.languageStr = @"";
    } else if ([tmpKxM.title isEqualToString:@"русский"]) {
        [tmpStatusCellL.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
        tmpStatusCellL.languageStr = @"ru_RU";
    }
    [self cellExpandForTranslate:tmpStatusCellL Height:1];
}

-(void)onRequestResult:(NSNotification*)notification {
    NSLog(@"[levi] translate result %@", notification.object);
    NSString *transResult = notification.object;
    NSLog(@"[nnn] %@", tmpStatusCellL.contentTF);
    [SVProgressHUD dismiss];
    CGFloat transHeight = [StatusCell getJSHeight:transResult jsViewWith:tmpStatusCellL.contentTF.frame.size.width];
    for (int i = tmpStatusCellL.cellIndexPath.row + 1; i < [statuesArr count]; i ++) {
        StatusCell *tmpCell = (StatusCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        tmpCell.frame = CGRectMake(tmpStatusCellL.frame.origin.x, tmpStatusCellL.frame.origin.y + transHeight, tmpStatusCellL.frame.size.width, tmpStatusCellL.frame.size.height);
        //        [tmpCell adjustMainImagePosition:100];
    }
    tmpStatusCellL.frame = CGRectMake(tmpStatusCellL.frame.origin.x, tmpStatusCellL.frame.origin.y, tmpStatusCellL.frame.size.width, tmpStatusCellL.frame.size.height + transHeight);
    [tmpStatusCellL showTranslateTV:100 Content:transResult];
}

-(void)cellExpandForTranslate:(StatusCell *)theCell Height:(NSInteger)height{
    tmpStatusCellL = theCell;
    NSLog(@"[levi] tap have image icon... %d", theCell.cellIndexPath.row);
    [SVProgressHUD showWithStatus:@"request translate..." maskType:SVProgressHUDMaskTypeGradient];
    [manager FBGetTranslateWithBody:theCell.contentTF.text Language:theCell.languageStr PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)cellMoreDoTaped:(StatusCell *)theCell {
    CustomActionSheet *as = [[CustomActionSheet alloc] init];
    [as addButtonWithTitle:@"举报"];
    [as addButtonWithTitle:@"删除"];
    [as showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}
**/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (currentView == HOME_PAGE) {
        if (scrollView.contentOffset.y < 200) {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        else
            [super scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (currentView == HOME_PAGE) {
        [self refreshVisibleCellsImages];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}
@end
