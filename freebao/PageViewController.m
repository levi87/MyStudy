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

@interface PageViewController ()
-(void)getDataFromCD;

@end

@implementation PageViewController
@synthesize userID;
@synthesize timer;
@synthesize avPlay = _avPlay;

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

    [self initSegment];
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
	}];
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

//上拉
-(void)refresh
{
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
@end
