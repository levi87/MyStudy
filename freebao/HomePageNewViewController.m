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

#define FB_FAKE_WEIBO @"fb_fake_weibo"

@interface HomePageNewViewController ()

@end

@implementation HomePageNewViewController
@synthesize cellContentId = _cellContentId;
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
    [manager FBGetUserInfoWithUsetId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [manager FBGetHomelineNew:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] init];
    
    UIView *tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"Freebao";
    [tittleLabel setFont:[UIFont fontWithName:FONT size:15]];
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 80, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction)];
    tap.numberOfTapsRequired = 1;
    [imgV addGestureRecognizer:tap];
    [backButton addSubview:imgV];
    UIView *tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    [self.navigationController.view addSubview:backButton];
    backButton.hidden = YES;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.homeTableView setTableHeaderView:headerView];
}

-(void)postSuccessRefresh {
    NSLog(@"post success refresh...");
    [self handleData];
}

-(void)refreshView:(UIRefreshControl *)refresh
{
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR object:nil];
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    backButton.hidden = YES;
    tittleLabel.text = @"Freebao";
    [self.navigationController popViewControllerAnimated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION_VOICE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_TRANSLATION_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_FAKE_WEIBO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_POST_SUCCESS object:nil];
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
            [self.homeTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:tmpIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            NSLog(@"statusNewCell");
            StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        } else {
            NSLog(@"statusNewImageCell");
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
        if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            NSLog(@"statusNewCell");
            StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
            [tmpCell.transVoiceImageView stopAnimating];
        } else {
            NSLog(@"statusNewImageCell");
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
    if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        NSLog(@"statusNewCell");
        StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.transVoiceImageView stopAnimating];
    } else {
        NSLog(@"statusNewImageCell");
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.transVoiceImageView stopAnimating];
    }
}

-(void)stopSoundAnimating {
    StatusInfo *tmpStatusInfo = [statusArray objectAtIndex:tmpIndexPath.row];
    tmpStatusInfo.isPlayingSound = NO;
    [statusArray replaceObjectAtIndex:tmpIndexPath.row withObject:tmpStatusInfo];
    StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
    if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
        if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
            StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            tmpCell.frame = CGRectMake(tmpCell.frame.origin.x, tmpCell.frame.origin.y + transHeght, tmpCell.frame.size.width, tmpCell.frame.size.height);
        } else {
            StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            tmpCell.frame = CGRectMake(tmpCell.frame.origin.x, tmpCell.frame.origin.y + transHeght, tmpCell.frame.size.width, tmpCell.frame.size.height);
        }
    }
    if ([[self.homeTableView cellForRowAtIndexPath:tmpIndexPath] isKindOfClass:[StatusNewCell class]]) {
        StatusNewCell *tmpCell = (StatusNewCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell showTranslateTextView:transResult StatusInfo:[statusArray objectAtIndex:tmpIndexPath.row]];
        CGRect frame = tmpCell.frame;
        frame.size.height += transHeght + 10;
        tmpCell.frame = frame;
    } else {
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
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
        StatusNewImageCell *tmpCell = (StatusNewImageCell*)[self.homeTableView cellForRowAtIndexPath:tmpIndexPath];
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
