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
#import <QuartzCore/QuartzCore.h>

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define FONT @"HelveticaNeue"

#define HOME_PAGE 0
#define FAV_PAGE 1
#define FOLLOW_PAGE 2
#define FANS_PAGE 3
#define PHOTO_PAGE 4

#define FB_FAKE_WEIBO @"fb_fake_weibo"

#import "REPhotoThumbnailsCell.h"

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
//Photo
//@synthesize photoDatasource = _photoDatasource;
@synthesize groupByDate = _groupByDate;
@synthesize thumbnailViewClass = _thumbnailViewClass;
@synthesize ds = _ds;

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
    headImageView = [[EGOImageView alloc] init];
    headImageView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    headImageView.imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_FACE_PATH]];
    [self.userHeadImage addSubview:headImageView];
    self.userHeadImage.layer.masksToBounds =YES;
    self.userHeadImage.layer.cornerRadius = 40;

    [self initSegment];
    [self initFansView];
    [self initFollowView];
    [self initPhotoView];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    currentPage = 0;
    statusArray = [[NSMutableArray alloc] init];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestHomeLine:) name:FB_GET_HOMELINE_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestVoiceResult:) name:FB_GET_TRANSLATION_VOICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslateResult:)       name:FB_GET_TRANSLATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslateFailResult:)       name:FB_GET_TRANSLATION_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertFakeWeiobo:) name:FB_FAKE_WEIBO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccessRefresh) name:FB_POST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPoint:) name:FB_USER_LOCATION object:nil];
    [manager FBGetUserInfoWithUsetId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] init];
    NSLog(@"[levi]view didload");
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
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,9, 51, 26)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back_normal"] forState:UIControlStateNormal];
    UIView *TittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [TittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:TittleView];
    [self.navigationController.view addSubview:TittleLineView];
    [self.navigationController.view addSubview:backButton];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setTableHeaderView:self.profileHeaderView];
    [self.tableView setTableFooterView:headerView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestPhotoResult:) name:FB_GET_PHOTO_LIST object:nil];
}

-(void)postSuccessRefresh {
    NSLog(@"post success refresh...");
    [self handleData];
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (currentPage != HOME_PAGE) {
        return;
    }
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
    }
}

-(void)handleData
{
    NSLog(@"hellof....");
    currentPage = 0;
    [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

- (void)onRequestHomeLine:(NSNotification*)notification {
    NSLog(@"new status...");
    NSMutableArray *tmpArray = notification.object;
    maxPage = [[notification.userInfo objectForKey:@"maxCount"] integerValue];
    if (currentPage == 0) {
        [statusArray removeAllObjects];
        statusArray = tmpArray;
        [self.refreshControl endRefreshing];
    } else {
        for (int i = 0; i < [tmpArray count]; i ++) {
            [statusArray addObject:[tmpArray objectAtIndex:i]];
        }
    }
    [self.tableView reloadData];
}

-(void)initPhotoView {
    _ds = [[NSMutableArray alloc] init];
    _groupByDate = YES;
//    photoArray = [NSMutableArray arrayWithArray:[self prepareDatasource]];
    NSLog(@"photo array count %d", [photoArray count]);
    self.title = @"Photos.";
    self.thumbnailViewClass = [ThumbnailView class];
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

-(void)onRequestPhotoResult:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
//    NSLog(@"Photo Array %@", tmpArray);
    NSMutableArray *tmpPhotoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        NSString *tmpTime = [tmpDic objectForKey:@"createtime"];
        tmpTime = [tmpTime substringToIndex:10];
        tmpTime = [tmpTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        NSLog(@"time Time %@", tmpTime);
        [tmpPhotoArray addObject:[Photo photoWithURLString:[tmpDic objectForKey:@"imagePath"]
                                                   date:[self dateFromString:tmpTime]]];
    };
    photoArray = tmpPhotoArray;
    [self reloadPhotoData];
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
        if (scrollView.contentOffset.y >= fmaxf(0.f, scrollView.contentSize.height - scrollView.frame.size.height) + 40.f) {
            NSLog(@"current page %d max page %d", maxPage, currentPage);
            if (currentPage + 1 >= maxPage) {
                return;
            }
            currentPage ++;
            if (manager == nil) {
                manager = [WeiBoMessageManager getInstance];
            }
            [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        }
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
            currentPage = 0;
            [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        } else if (index == 1) {
            NSLog(@"fav. page");
            currentView = FAV_PAGE;
        } else if (index == 2) {
            NSLog(@"follow");
            [statusArray removeAllObjects];
            [followersArray removeAllObjects];
            [likersArray removeAllObjects];
//            [photoArray removeAllObjects];
//            [self.tableView reloadData];
            currentView = FOLLOW_PAGE;
            if (manager == nil) {
                manager = [WeiBoMessageManager getInstance];
            }
            [manager FBFansListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPageFollow PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        } else if (index == 3) {
            NSLog(@"fans");
            [statusArray removeAllObjects];
            [likersArray removeAllObjects];
            [followersArray removeAllObjects];
//            [photoArray removeAllObjects];
//            [self.tableView reloadData];
            currentView = FANS_PAGE;
            if (manager == nil) {
                manager = [WeiBoMessageManager getInstance];
            }
            [manager FBFollowerListWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        } else if (index == 4) {
            NSLog(@"photo");
            [statusArray removeAllObjects];
            [followersArray removeAllObjects];
            [likersArray removeAllObjects];
//            [self.tableView reloadData];
            currentView = PHOTO_PAGE;
//            [self reloadPhotoData];
            [manager FBGetUserPhotosWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] SomeBodyId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        }
	}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentView == FANS_PAGE) {
        return [likersArray count];
    } else if (currentView == FOLLOW_PAGE) {
        return [followersArray count];
    } else if (currentView == PHOTO_PAGE) {
        REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
        return ceil([group.items count] / 4.0f);
    }
    return [statusArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentView == FANS_PAGE || currentView == FOLLOW_PAGE) {
        return 58;
    } else if (currentView == PHOTO_PAGE) {
        NSLog(@"photo...");
        return 80;
    }
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
        return 40 + tmpHeight + 50 + 30 + 330 + forwordHeight + commentsHeight;
    } else {
        return 40 + tmpHeight + 50 + 30 + forwordHeight + commentsHeight;
    }
}

- (void)handleSelection:(id)sender {
	NSLog(@"URBSegmentedControl: value changed");
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    backButton.hidden = YES;
    tittleLabel.text = @"Profile";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setProfileHeaderView:nil];
    [self setUserHeadImage:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_HOMELINE_NEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION_VOICE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_FAKE_WEIBO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_POST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_USER_LOCATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[levi]viewWillAppear...");
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [manager FBGetUserInfoWithUsetId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [manager FBGetHomeline:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
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
    } else if (currentView == PHOTO_PAGE) {
        static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
        REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailViewClass:_thumbnailViewClass];
        }
        
        REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:indexPath.section];
        
        int startIndex = indexPath.row * 4;
        int endIndex = startIndex + 4;
        if (endIndex > [group.items count])
            endIndex = [group.items count];
        
        [cell removeAllPhotos];
        for (int i = startIndex; i < endIndex; i++) {
            NSObject <REPhotoObjectProtocol> *photo = [group.items objectAtIndex:i];
            [cell addPhoto:photo];
        }
        [cell refresh];
        
        return cell;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    return [dateFormat dateFromString:string];
}

- (void)reloadPhotoData
{
    if (!_groupByDate) {
        REPhotoGroup *group = [[REPhotoGroup alloc] init];
        group.month = 1;
        group.year = 1900;
        [_ds removeAllObjects];
        NSLog(@"photo array count %d", [photoArray count]);
        for (NSObject *object in photoArray) {
            [group.items addObject:object];
        }
        [_ds addObject:group];
        NSLog(@"_ds count %d", [_ds count]);
        return;
    }
    NSArray *sorted = [photoArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject <REPhotoObjectProtocol> *photo1 = obj1;
        NSObject <REPhotoObjectProtocol> *photo2 = obj2;
        return ![photo1.date compare:photo2.date];
    }];
    [_ds removeAllObjects];
    for (NSObject *object in sorted) {
        NSObject <REPhotoObjectProtocol> *photo = (NSObject <REPhotoObjectProtocol> *)object;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.date];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in _ds) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month = month;
            group.year = year;
            [group.items addObject:photo];
            [_ds addObject:group];
        } else {
            [group.items addObject:photo];
        }
    }
    NSLog(@"~~~~~~~~~~photo reload... %d", [_ds count]);
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currentView == PHOTO_PAGE) {
        NSLog(@"section num  photo");
        NSLog(@"%d", [_ds count]);
        if ([_ds count] == 0) return 0;
        if (!_groupByDate) return 1;
        
        if ([self tableView:self.tableView numberOfRowsInSection:[_ds count] - 1] == 0) {
            NSLog(@"~~~~~~~~~~~~~~~~~~~");
            return [_ds count] - 1;
        }
        NSLog(@".................... %d", [_ds count]);
        return [_ds count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (currentView == PHOTO_PAGE) {
        NSLog(@"h  photo");
        return !_groupByDate ? 0 : 22;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (currentView == PHOTO_PAGE) {
        NSLog(@"tittle  photo");
        REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-1", group.year, group.month]];
        
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        NSString *resultString = [dateFormatter stringFromDate:date];
        return resultString;
    } else {
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (currentView == PHOTO_PAGE) {
        NSLog(@"tittle height footer  photo");
        return 5;
    } else {
        return 0;
    }
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
    tmpIndexPath = theCell.indexPath;
    _actionSheet = [[CustomActionSheet alloc] init];
    _actionSheet.delegate = self;
    [_actionSheet addButtonWithTitle:@"Favorite"];
    [_actionSheet addButtonWithTitle:@"Report"];
    if ([[NSString stringWithFormat:@"%@",theCell.statusInfo.userId] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]]]) {
        [_actionSheet addButtonWithTitle:@"Delete"];
    }
    [_actionSheet addButtonWithTitle:@"Cancel"];
    [_actionSheet showInView:self.view];
}

-(void)imageCellMoreDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image cell more tap");
    tmpIndexPath = theCell.indexPath;
    _actionSheet = [[CustomActionSheet alloc] init];
    _actionSheet.delegate = self;
    [_actionSheet addButtonWithTitle:@"Favorite"];
    [_actionSheet addButtonWithTitle:@"Report"];
    if ([[NSString stringWithFormat:@"%@",theCell.statusInfo.userId] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]]]) {
        [_actionSheet addButtonWithTitle:@"Delete"];
    }
    [_actionSheet addButtonWithTitle:@"Cancel"];
    [_actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    StatusInfo *tmpStatusInfo = [statusArray objectAtIndex:tmpIndexPath.row];
    switch (buttonIndex) {
        case 0:
            [manager FBAddFavouriteWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:tmpStatusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
            break;
        case 1:
            break;
        case 2:
            if (![[NSString stringWithFormat:@"%@",tmpStatusInfo.userId] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]]]) {
                return;
            }
            [statusArray removeObjectAtIndex:tmpIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:tmpIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [manager FBDeleteHomelineWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] ContentId:tmpStatusInfo.contentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
            break;
        default:
            break;
    }
}

-(void)cellLikerDidTaped:(StatusNewCell *)theCell {
    NSLog(@"liker tap");
    if (likeVC == nil) {
        likeVC = [[LikersViewController alloc] init];
    } else {
        [likeVC setIsRefresh:YES];
    }
    likeVC.cellContentId = theCell.statusInfo.contentId;
    tittleLabel.text = @"Likers";
    backButton.hidden = NO;
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
    tittleLabel.text = @"Likers";
    backButton.hidden = NO;
    [self.navigationController pushViewController:likeVC animated:YES];
}

-(void)cellCommentDidTaped:(StatusNewCell *)theCell {
    NSLog(@"comment tap");
    if (commentVC == nil) {
        commentVC = [[CommentViewController alloc] init];
    } else {
        [commentVC setIsRefresh:YES];
    }
    commentVC.cellContentId = theCell.statusInfo.contentId;
    tittleLabel.text = @"Comments";
    backButton.hidden = NO;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)imageCellCommentDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image commnet tap");
    if (commentVC == nil) {
        commentVC = [[CommentViewController alloc] init];
    } else {
        [commentVC setIsRefresh:YES];
    }
    commentVC.cellContentId = theCell.statusInfo.contentId;
    tittleLabel.text = @"Comments";
    backButton.hidden = NO;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)cellDistanceDidTaped:(StatusNewCell *)theCell {
    NSLog(@"distance tap.");
    if (KAppDelegate.commMap == nil) {
        KAppDelegate.commMap = [[UserLocationViewController alloc] init];
    }
    CLLocationCoordinate2D userCoordinate;
    //    NSLog(@"[levi] x %f y %f", theCell.tmpPoint.x, theCell.tmpPoint.y);
    NSLog(@"distance %@", theCell.statusInfo.geo);
    if (theCell.statusInfo.geo != nil) {
        NSDictionary *tmpDistance = theCell.statusInfo.geo;
        userCoordinate.longitude = [[tmpDistance getStringValueForKey:@"longitude" defaultValue:@"0.0"] floatValue];
        userCoordinate.latitude = [[tmpDistance getStringValueForKey:@"latitude" defaultValue:@"0.0"] floatValue];
    } else {
        userCoordinate.latitude = 0.0;
        userCoordinate.longitude = 0.0;
    }
    [KAppDelegate.commMap setUserCoordinate:userCoordinate];
    [self presentModalViewController:KAppDelegate.commMap animated:YES];
}

-(void)imageCellDistanceDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image distance tap");
    if (KAppDelegate.commMap == nil) {
        KAppDelegate.commMap = [[UserLocationViewController alloc] init];
    }
    CLLocationCoordinate2D userCoordinate;
    //    NSLog(@"[levi] x %f y %f", theCell.tmpPoint.x, theCell.tmpPoint.y);
    NSLog(@"distance %@", theCell.statusInfo.geo);
    if (theCell.statusInfo.geo != nil) {
        NSDictionary *tmpDistance = theCell.statusInfo.geo;
        userCoordinate.longitude = [[tmpDistance getStringValueForKey:@"longgitude" defaultValue:@"0.0"] floatValue];
        userCoordinate.latitude = [[tmpDistance getStringValueForKey:@"latitude" defaultValue:@"0.0"] floatValue];
    } else {
        userCoordinate.latitude = 0.0;
        userCoordinate.longitude = 0.0;
    }
    [KAppDelegate.commMap setUserCoordinate:userCoordinate];
    [self presentModalViewController:KAppDelegate.commMap animated:YES];
}

-(void)cellTransVoiceDidTaped:(StatusNewCell *)theCell {
    NSLog(@"trans voice tap");
    tmpIndexPath = theCell.indexPath;
    if (_avPlay.playing) {
        [_avPlay stop];
        if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            NSLog(@"statusNewCell");
            StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        } else {
            NSLog(@"statusNewImageCell");
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        }
        return;
    }
    [manager FBGetTranslateVoiceWithBody:theCell.statusInfo.content Language:theCell.statusInfo.postLanguage PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)imageCellTransVoiceDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image trans voice tap");
    tmpIndexPath = theCell.indexPath;
    if (_avPlay.playing) {
        [_avPlay stop];
        if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            NSLog(@"statusNewCell");
            StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        } else {
            NSLog(@"statusNewImageCell");
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        }
        return;
    }
    [manager FBGetTranslateVoiceWithBody:theCell.statusInfo.content Language:theCell.statusInfo.postLanguage PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSString *volumeA = [NSString stringWithFormat:@"%0.1f", player.volume];
    if ([volumeA isEqualToString:@"1.0"]) {
        [self stopVoiceAnimating];
    } else if ([volumeA isEqualToString:@"0.9"]) {
        [self stopSoundAnimating];
    }
}

-(void)stopVoiceAnimating {
    StatusInfo *tmpStatusInfo = [statusArray objectAtIndex:tmpIndexPath.row];
    tmpStatusInfo.isPlayingVoice = NO;
    [statusArray replaceObjectAtIndex:tmpIndexPath.row withObject:tmpStatusInfo];
    if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        NSLog(@"statusNewCell");
        StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.transVoiceImageView stopAnimating];
    } else {
        NSLog(@"statusNewImageCell");
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.transVoiceImageView stopAnimating];
    }
}

-(void)stopSoundAnimating {
    StatusInfo *tmpStatusInfo = [statusArray objectAtIndex:tmpIndexPath.row];
    tmpStatusInfo.isPlayingSound = NO;
    [statusArray replaceObjectAtIndex:tmpIndexPath.row withObject:tmpStatusInfo];
    StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
    [tmpCell.voiceImage stopAnimating];
}

-(void)onRequestVoiceResult:(NSNotification*)notification {
    NSString *voiceUrl = notification.object;
    //    NSLog(@"[levi] voice url %@",voiceUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *tmpVoiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:tmpVoiceData error:nil];
            [player setVolume:1.0];
            _avPlay = player;
            _avPlay.delegate = self;
            [_avPlay play];
        });
    });
}

-(void)cellLanguageDidTaped:(StatusNewCell *)theCell {
    NSLog(@"language select...");
    tmpIndexPath = theCell.indexPath;
    [self languageMenuAction];
}

-(void)imageCellLanguageDidTaped:(StatusNewImageCell *)theCell {
    NSLog(@"image language select...");
    tmpIndexPath = theCell.indexPath;
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
    if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        if ([tmpKxM.title isEqualToString:@"中文"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
            tmpCell.statusInfo.postLanguage = @"zh_CN";
        } else if ([tmpKxM.title isEqualToString:@"English"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
            tmpCell.statusInfo.postLanguage = @"en_US";
        } else if ([tmpKxM.title isEqualToString:@"日本語"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
            tmpCell.statusInfo.postLanguage = @"ja_JP";
        } else if ([tmpKxM.title isEqualToString:@"한국어"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
            tmpCell.statusInfo.postLanguage = @"ko_KR";
        } else if ([tmpKxM.title isEqualToString:@"España"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
            tmpCell.statusInfo.postLanguage = @"es_ES";
        } else if ([tmpKxM.title isEqualToString:@"Français"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
            tmpCell.statusInfo.postLanguage = @"fr_FR";
        } else if ([tmpKxM.title isEqualToString:@"Deutsch"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_d"]];
            tmpCell.statusInfo.postLanguage = @"";
        } else if ([tmpKxM.title isEqualToString:@"русский"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
            tmpCell.statusInfo.postLanguage = @"ru_RU";
        }
        [self getTranslate:tmpCell.statusInfo.content Language:tmpCell.statusInfo.postLanguage];
    } else {
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        if ([tmpKxM.title isEqualToString:@"中文"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
            tmpCell.statusInfo.postLanguage = @"zh_CN";
        } else if ([tmpKxM.title isEqualToString:@"English"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
            tmpCell.statusInfo.postLanguage = @"en_US";
        } else if ([tmpKxM.title isEqualToString:@"日本語"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
            tmpCell.statusInfo.postLanguage = @"ja_JP";
        } else if ([tmpKxM.title isEqualToString:@"한국어"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
            tmpCell.statusInfo.postLanguage = @"ko_KR";
        } else if ([tmpKxM.title isEqualToString:@"España"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
            tmpCell.statusInfo.postLanguage = @"es_ES";
        } else if ([tmpKxM.title isEqualToString:@"Français"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
            tmpCell.statusInfo.postLanguage = @"fr_FR";
        } else if ([tmpKxM.title isEqualToString:@"Deutsch"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_d"]];
            tmpCell.statusInfo.postLanguage = @"";
        } else if ([tmpKxM.title isEqualToString:@"русский"]) {
            [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
            tmpCell.statusInfo.postLanguage = @"ru_RU";
        }
        [self getTranslate:tmpCell.statusInfo.content Language:tmpCell.statusInfo.postLanguage];
    }
}

-(void)getTranslate:(NSString *)content Language:(NSString*)language{
    [SVProgressHUD showWithStatus:@"request translate..." maskType:SVProgressHUDMaskTypeGradient];
    [manager FBGetTranslateWithBody:content Language:language PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)onTranslateFailResult:(NSNotification*)notification {
    [SVProgressHUD dismiss];
}

-(void)onTranslateResult:(NSNotification*)notification {
    NSLog(@"[levi] translate result %@", notification.object);
    NSString *transResult = notification.object;
    CGFloat transHeght = [StatusNewCell getJSHeight:transResult jsViewWith:300];
    for (int i = tmpIndexPath.row + 1; i < [statusArray count]; i ++) {
        if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            tmpCell.frame = CGRectMake(tmpCell.frame.origin.x, tmpCell.frame.origin.y + transHeght, tmpCell.frame.size.width, tmpCell.frame.size.height);
        } else {
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            tmpCell.frame = CGRectMake(tmpCell.frame.origin.x, tmpCell.frame.origin.y + transHeght, tmpCell.frame.size.width, tmpCell.frame.size.height);
        }
    }
    if ([[self.tableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        StatusNewCell *tmpCell = (StatusNewCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell showTranslateTextView:transResult StatusInfo:[statusArray objectAtIndex:tmpIndexPath.row]];
        CGRect frame = tmpCell.frame;
        frame.size.height += transHeght + 10;
        tmpCell.frame = frame;
    } else {
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell showTranslateTextView:transResult StatusInfo:[statusArray objectAtIndex:tmpIndexPath.row]];
        CGRect frame = tmpCell.frame;
        frame.size.height += transHeght + 10;
        tmpCell.frame = frame;
    }
    [SVProgressHUD dismiss];
    //    CGFloat transHeight = [StatusCell getJSHeight:transResult jsViewWith:tmpStatusCellL.contentTF.frame.size.width];
    //    for (int i = tmpStatusCellL.cellIndexPath.row + 1; i < [statuesArr count]; i ++) {
    //        StatusCell *tmpCell = (StatusCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    //        tmpCell.frame = CGRectMake(tmpStatusCellL.frame.origin.x, tmpStatusCellL.frame.origin.y + transHeight, tmpStatusCellL.frame.size.width, tmpStatusCellL.frame.size.height);
    //        //        [tmpCell adjustMainImagePosition:100];
    //    }
    //    tmpStatusCellL.frame = CGRectMake(tmpStatusCellL.frame.origin.x, tmpStatusCellL.frame.origin.y, tmpStatusCellL.frame.size.width, tmpStatusCellL.frame.size.height + transHeight);
    //    [tmpStatusCellL showTranslateTV:100 Content:transResult];
}

- (void)addPoint:(NSNotification*)notfication {
    NSArray *footmarkArray = notfication.object;
    NSLog(@"foot mark%@", footmarkArray);
    if ([footmarkArray count] == 0) {
        return;
    }
    CLLocationCoordinate2D tmpCoordinate;
    for (int i = 0; i < [footmarkArray count]; i ++) {
        NSDictionary *tmpDic = [footmarkArray objectAtIndex:i];
        MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
        tmpCoordinate.latitude = [[tmpDic objectForKey:@"latitude"] floatValue];
        tmpCoordinate.longitude = [[tmpDic objectForKey:@"longgitude"] floatValue];
        ann.coordinate = tmpCoordinate;
        [self.mapView addAnnotation:ann];
    }
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.03;
    region.span.longitudeDelta = 0.03;
    region.center = tmpCoordinate;
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}

- (void)insertFakeWeiobo:(NSNotification*)notfication {
    NSLog(@"inser Fake weibo");
    StatusInfo *tmpStatus = (StatusInfo*)notfication.object;
    NSDictionary *tmpDic = notfication.userInfo;
    [statusArray insertObject:tmpStatus atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self performSelector:@selector(submitFakeWeibo:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:tmpStatus,@"status", tmpDic, @"userinfo", nil] afterDelay:1];
}

-(void)submitFakeWeibo:(NSDictionary *)dictionary {
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    StatusInfo *status = (StatusInfo*)[dictionary objectForKey:@"status"];
    NSDictionary *userInfo = [dictionary objectForKey:@"userinfo"];
    NSString *postFileType = @"0";
    NSData *mediaData = nil;
    NSData *soundData = nil;
    NSString *latitude = @"0";
    NSString *longitude = @"0";
    NSLog(@"userinfo %@", userInfo);
    if ([[userInfo objectForKey:@"hasPhoto"] integerValue] == 1) {
        postFileType = @"1";
        mediaData = [NSData dataWithContentsOfFile:[userInfo objectForKey:@"PhotoPath"]];
    }
    if ([userInfo objectForKey:@"hasVoice"]) {
        soundData = [NSData dataWithContentsOfFile:[userInfo objectForKey:@"VoicePath"]];
    }
    if ([userInfo objectForKey:@"hasLocation"]) {
        latitude = [userInfo getStringValueForKey:@"latitude" defaultValue:@"0"];
        longitude = [userInfo getStringValueForKey:@"longitude" defaultValue:@"0"];
    }
    NSLog(@"%@ %@", latitude,longitude);
    [manager FBPostWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Boay:status.content AllowShare:YES AllowComment:YES CircleId:[userInfo objectForKey:@"defaultCircle"] Location:@"0" Latitude:latitude Longgitude:longitude FileType:postFileType MediaFile:mediaData SoundFile:soundData PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)imageCellSoundDidTaped:(StatusNewImageCell *)theCell {
    NSDictionary *tmp = theCell.statusInfo.soundDic;
    NSLog(@"sound path %@", [tmp objectForKey:@"soundPath"]);
    tmpIndexPath = theCell.indexPath;
    if (_avPlay.isPlaying) {
        [_avPlay stop];
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.voiceImage stopAnimating];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *tmpVoiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"soundPath"]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:tmpVoiceData error:nil];
            [player setVolume:0.9];
            _avPlay = player;
            _avPlay.delegate = self;
            [_avPlay play];
        });
    });
}
@end
