//
//  CommentViewController.m
//  freebao
//
//  Created by freebao on 13-7-18.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CommentViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#define HIDE_KEYBOARD @"fb_hide_keyboard"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize cellContentId = _cellContentId;
@synthesize isRefresh = _isRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didGetComments:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    [commentsArray removeAllObjects];
    headPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        CommentInfo *tmpInfo = [[CommentInfo alloc] init];
        tmpInfo.nickName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.content = [tmpDic objectForKey:@"commentBody"];
        [commentsArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.commentTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isRefresh = FALSE;
    isFirst = TRUE;
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view];
    bar.delegate=self;
    
    commentsArray = [[NSMutableArray alloc] init];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetComments:) name:FB_GET_COMMENT object:nil];
    [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] initWithObjects:
                  @"http://farm4.static.flickr.com/3483/4017988903_84858e0e6e_s.jpg",
                  @"http://farm3.static.flickr.com/2436/4015786038_7b530f9cce_s.jpg",
                  @"http://farm3.static.flickr.com/2643/4025878602_85f7cd1724_s.jpg",
                  @"http://farm3.static.flickr.com/2494/4011329502_09e6d03b4d_s.jpg",
                  @"http://farm4.static.flickr.com/3103/4027083130_b187516f48_s.jpg",
                  @"http://farm3.static.flickr.com/2557/4007449481_59d7a8d848_s.jpg",
                  @"http://farm4.static.flickr.com/3479/4021202695_381ff2e9bc_s.jpg",
                  @"http://farm3.static.flickr.com/2598/4010566163_1426fa3389_s.jpg",
                  @"http://farm3.static.flickr.com/2589/4015601052_ba81c7544b_s.jpg",
                  @"http://farm3.static.flickr.com/2551/4025950491_20a7615b69_s.jpg",
                  @"http://farm3.static.flickr.com/2534/4009711388_66ae983c7e_s.jpg",
                  @"http://farm3.static.flickr.com/2469/4008746903_e90b09241d_s.jpg",
                  @"http://farm3.static.flickr.com/2432/4025384253_0e521644dd_s.jpg",
                  @"http://farm3.static.flickr.com/2585/4023151655_d63ecd4025_s.jpg",
                  @"http://farm3.static.flickr.com/2421/4019640142_7ee56e4b1c_s.jpg",
                  @"http://farm4.static.flickr.com/3511/4016743839_69370584f3_s.jpg",
                  @"http://farm3.static.flickr.com/2547/4016748951_f52700aeaa_s.jpg",
                  @"http://farm4.static.flickr.com/3639/4014434499_b832e04061_s.jpg",
                  @"http://farm3.static.flickr.com/2190/4018090737_846760e3da_s.jpg",
                  @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg",
                  @"http://farm4.static.flickr.com/3511/4008358164_a5def010c7_s.jpg",
                  @"http://farm3.static.flickr.com/2792/4023230831_34b3dfc1ea_s.jpg",
                  @"http://farm3.static.flickr.com/2438/4021904945_c3706a652a_s.jpg",
                  @"http://farm3.static.flickr.com/2655/4012063376_5e120a4428_s.jpg",
                  @"http://farm3.static.flickr.com/2637/4009152189_9fd9034b60_s.jpg",
                  @"http://farm3.static.flickr.com/2673/4017117612_ae364923b0_s.jpg",
                  @"http://farm3.static.flickr.com/2495/4020233997_453672b620_s.jpg",
                  @"http://farm3.static.flickr.com/2586/4014510731_47e9a9b73d_s.jpg",
                  @"http://farm3.static.flickr.com/2739/4025489621_65264987f8_s.jpg",
                  @"http://farm3.static.flickr.com/2577/4016420951_def68019dd_s.jpg",
                  @"http://farm3.static.flickr.com/2500/4026353518_15268c4488_s.jpg",
                  @"http://farm3.static.flickr.com/2453/4008435378_8e16c06970_s.jpg",
                  @"http://farm3.static.flickr.com/2745/4026003536_31da429e13_s.jpg",
                  @"http://farm3.static.flickr.com/2674/4019640830_31e067d771_s.jpg",
                  @"http://farm3.static.flickr.com/2671/4017291336_b39b72224c_s.jpg",
                  @"http://farm3.static.flickr.com/2665/4015357692_6d31ab729b_s.jpg",
                  @"http://farm3.static.flickr.com/2475/4009936307_9a6039aec7_s.jpg",
                  @"http://farm3.static.flickr.com/2436/4019681008_a5da6093d0_s.jpg",
                  @"http://farm3.static.flickr.com/2475/4012817856_0e97e6718b_s.jpg",
                  @"http://farm3.static.flickr.com/2458/4011407242_0073aa2d22_s.jpg",
                  @"http://farm4.static.flickr.com/3509/4017070907_cea45a8d3a_s.jpg",
                  @"http://farm4.static.flickr.com/3488/4020067072_7c60a7a60a_s.jpg",
                  @"http://farm4.static.flickr.com/3503/4011136126_80c3b02986_s.jpg",
                  @"http://farm3.static.flickr.com/2751/4021887851_c5626ff59a_s.jpg",
                  @"http://farm3.static.flickr.com/2700/4020348292_856262abc7_s.jpg",
                  @"http://farm3.static.flickr.com/2620/4010967777_005fdd1867_s.jpg",
                  @"http://farm4.static.flickr.com/3517/4011690509_4ce02b32cf_s.jpg",
                  @"http://farm3.static.flickr.com/2454/4012955142_7177f21bf4_s.jpg",
                  @"http://farm3.static.flickr.com/2538/4014440923_a2b9824628_s.jpg",
                  @"http://farm3.static.flickr.com/2635/4010051525_74df73bbd7_s.jpg",
                  @"http://farm3.static.flickr.com/2752/4020781123_baaa208689_s.jpg",
                  @"http://farm3.static.flickr.com/2622/4014471899_05043a20e3_s.jpg",
                  @"http://farm3.static.flickr.com/2780/4022823482_26e5530c84_s.jpg",
                  @"http://farm4.static.flickr.com/3515/4016721686_c828925456_s.jpg",
                  @"http://farm3.static.flickr.com/2575/4022946879_977e8df918_s.jpg",
                  @"http://farm3.static.flickr.com/2648/4018130671_8390158767_s.jpg",
                  @"http://farm3.static.flickr.com/2493/4022863018_6197f81c8d_s.jpg",
                  @"http://farm4.static.flickr.com/3216/4018267822_e90308c44c_s.jpg",
                  @"http://farm3.static.flickr.com/2530/4009339944_4d9eb769fc_s.jpg",
                  @"http://farm3.static.flickr.com/2577/4026000780_e615efd67c_s.jpg",
                  @"http://farm4.static.flickr.com/3499/4018569395_a4483387b0_s.jpg",
                  @"http://farm4.static.flickr.com/3509/4019095546_c0f110bc1c_s.jpg",
                  @"http://farm3.static.flickr.com/2579/4022669316_42065ea829_s.jpg",
                  @"http://farm3.static.flickr.com/2560/4009382268_7d8812fe98_s.jpg",
                  @"http://farm3.static.flickr.com/2645/4025740346_03e948466f_s.jpg",
                  @"http://farm3.static.flickr.com/2800/4021259282_122075711c_s.jpg",
                  @"http://farm3.static.flickr.com/2430/4019625100_b23147c748_s.jpg",
                  @"http://farm3.static.flickr.com/2527/4026734100_e52fc21603_s.jpg",
                  @"http://farm3.static.flickr.com/2635/4020892994_e6101d0f0e_s.jpg",
                  @"http://farm3.static.flickr.com/2672/4008379269_157e86729e_s.jpg",
                  @"http://farm3.static.flickr.com/2620/4009289798_bdcf26500a_s.jpg",
                  @"http://farm3.static.flickr.com/2455/4024701539_9ee5b7fac6_s.jpg",
                  @"http://farm3.static.flickr.com/2588/4010668107_97207ceb22_s.jpg",
                  @"http://farm3.static.flickr.com/2459/4023575284_cd01deba10_s.jpg",
                  @"http://farm3.static.flickr.com/2613/4019518861_5fbd679d61_s.jpg",
                  @"http://farm3.static.flickr.com/2429/4027017756_f9e6102700_s.jpg",
                  @"http://farm3.static.flickr.com/2487/4020209639_81a3a2bbc2_s.jpg",
                  @"http://farm3.static.flickr.com/2670/4013657757_12c694c4ee_s.jpg",
                  @"http://farm3.static.flickr.com/2804/4019095448_049ef023e3_s.jpg",
                  @"http://farm3.static.flickr.com/2197/4011866354_0948246520_s.jpg",
                  @"http://farm3.static.flickr.com/2557/4010652749_1d0c35fabd_s.jpg",
                  @"http://farm3.static.flickr.com/2543/4010847393_9844b1a37f_s.jpg",
                  @"http://farm3.static.flickr.com/2724/4021388365_7c739b9b16_s.jpg",
                  @"http://farm4.static.flickr.com/3484/4018164769_2e68f895dc_s.jpg",
                  @"http://farm3.static.flickr.com/2643/4020492457_84c4140077_s.jpg",
                  @"http://farm3.static.flickr.com/2670/4011966914_e1849fda91_s.jpg",
                  @"http://farm3.static.flickr.com/2653/4015298872_d4ef36c14a_s.jpg",
                  @"http://farm3.static.flickr.com/2710/4024844149_40dca40cd2_s.jpg",
                  @"http://farm3.static.flickr.com/2546/4012296861_146d4805df_s.jpg", nil];
}

- (void)clearCache {
    //    [[EGOCache currentCache] clearCache];
    //	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCommentTableView:nil];
    [super viewDidUnload];
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
    return [commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentsCell";
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell initUILayout];
    if (indexPath.row == 0) {
//        NSLog(@"[set Cell Layout]..... %d", indexPath.row);
//        isFirst = FALSE;
        [cell setCellLayout];
    }
    [cell setCellValue:(CommentInfo*)[commentsArray objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    cell.delegate = self;
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tmpHeight;
    CommentInfo *tmpInfo = [commentsArray objectAtIndex:indexPath.row];
    tmpHeight = [CommentsCell getJSHeight:tmpInfo.content jsViewWith:230.0];
    NSLog(@"tmpHeight %f", tmpHeight);
    if (indexPath.row == 0) {
        return 67 + tmpHeight;
    }
    return 23 + tmpHeight;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (commentsArray != nil) {
        [commentsArray removeAllObjects];
    }
    [self.commentTableView reloadData];
//    [self hideKeyboardAndFaceV];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_KEYBOARD object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    //    [KAppDelegate.tabBarVC.tabbar setHide:YES];
    if (_isRefresh) {
        [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(CommentsCell *)swipeTableViewCell {
    
}

-(void)swipeTableViewCell:(CommentsCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    
}

-(void)swipeTableViewCellWillResetState:(CommentsCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        NSLog(@"[levi]...mmmmmmm");
        //        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        //        if ([[[self.array objectAtIndex:indexPath.row] objectForKey:@"isFavourite"] boolValue]) {
        //            [[self.array objectAtIndex:indexPath.row] setObject:@NO forKey:@"isFavourite"];
        //        } else {
        //            [[self.array objectAtIndex:indexPath.row] setObject:@YES forKey:@"isFavourite"];
        //        }
        //        [(RMPersonTableViewCell*)swipeTableViewCell setFavourite:[[[self.array objectAtIndex:indexPath.row] objectForKey:@"isFavourite"] boolValue] animated:YES];
    } else if (point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        swipeTableViewCell.shouldAnimateCellReset = YES;
        NSLog(@"[levi]...nnnnnn");
        CustomActionSheet *as = [[CustomActionSheet alloc] init];
        [as addButtonWithTitle:@"举报"];
        [as addButtonWithTitle:@"删除"];
        [as showInView:self.view];
        //        [[(RMPersonTableViewCell*)swipeTableViewCell checkmarkGreyImageView] removeFromSuperview];
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             //                             swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                             swipeTableViewCell.contentView.frame = CGRectMake(0, 0, swipeTableViewCell.contentView.frame.size.width, swipeTableViewCell.contentView.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             //                             [swipeTableViewCell.contentView setHidden:YES];
                             //                             NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
                             //                             [self.array removeObjectAtIndex:indexPath.row];
                             //                             [self.tableView beginUpdates];
                             //                             [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                             //                             [self.tableView endUpdates];
                         }
         ];
    }
}

-(void)swipeTableViewCellDidResetState:(CommentsCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && -point.x > CGRectGetHeight(swipeTableViewCell.frame)) {
        NSLog(@"[levi]...ppooooo");
        //        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        //        [self.array removeObjectAtIndex:indexPath.row];
        //        [self.tableView beginUpdates];
        //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //        [self.tableView endUpdates];
    }
}

-(void)hideKeyboardAndFaceV {
    [UIView animateWithDuration:0.2 animations:^{
        [self.commentTableView setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 45)];
    }completion:^(BOOL finished){
        if (finished) {
            //            [self scrollToBottomAnimated:YES];
        }
    }];
}

-(void)showKeyboard:(CGRect)frame {
    NSLog(@"show");
    NSLog(@"[levi]toolbar frame y %f", frame.origin.y);
    //    [bubbleTable setContentOffset:CGPointMake(bubbleTable.contentOffset.x, bubbleTable.contentOffset.y - (415 - frame.origin.y) ) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [self.commentTableView setFrame:CGRectMake(0, 0, 320, frame.origin.y)];
    }completion:^(BOOL finished){
        if (finished) {
            [self scrollToBottomAnimated:YES];
        }
    }];
}

-(void)expandButtonAction:sender {
    UIButton *tmpButton = sender;
    if (tmpButton.tag == 1) {
        NSLog(@"takePhoto...");
    } else if (tmpButton.tag == 2) {
        NSLog(@"ChoosePhoto...");
    } else if (tmpButton.tag == 3) {
        NSLog(@"sendMap");
    }
}

-(void)voiceLongPressAction:(UILongPressGestureRecognizer *)recogonizer {
    //    CGPoint p = [recogonizer locationInView:self.view];
    //    NSLog(@"[levi] finger position... x %f y %f", p.x, p.y);
    //    fingerX = p.x;
    //    fingerY = p.y;
    //    if (fingerX > 75 && fingerX < 235 && fingerY > 135 && fingerY < 285) {
    //        recordViewLabel.text = @"Cancel To Send";
    //    } else {
    //        recordViewLabel.text = @"Slide up to cancel";
    //    }
    //    switch (recogonizer.state) {
    //        case UIGestureRecognizerStateBegan:
    //        {
    //            NSLog(@"[levi] start record");
    //            self.recordView.hidden = NO;
    //            //创建录音文件，准备录音
    //            if ([recorder prepareToRecord]) {
    //                //开始
    //                [recorder record];
    //            }
    //            recordtTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    //        }
    //            break;
    //        case UIGestureRecognizerStateEnded:
    //        {
    //            NSLog(@"[levi] end record");
    //            self.recordView.hidden = YES;
    //            double cTime = recorder.currentTime;
    //            NSLog(@"record length %f", cTime);
    //            voiceRecordLength = [NSString stringWithFormat:@"%.f", cTime];
    //            if (fingerX > 75 && fingerX < 235 && fingerY > 135 && fingerY < 285) {
    //                [recorder deleteRecording];
    //                [recorder stop];
    //                [recordtTimer invalidate];
    //                NSLog(@"[levi] cancel record");
    //                return;
    //            }
    //            if (cTime > 2) {//如果录制时间<2 不发送
    //                NSLog(@"send voice...");
    //            }else {
    //                NSLog(@"delete voice...");
    //                //删除记录的文件
    //                [recorder deleteRecording];
    //                //删除存储的
    //            }
    //            [recorder stop];
    //            [recordtTimer invalidate];
    //            [self sendVoiceAction];
    //        }
    //            break;
    //        default:
    //            break;
    //    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if ([commentsArray count] == 0) {
        return;
    }
    NSInteger rows = [commentsArray count] - 1;
    NSLog(@"[levi] rows %d", rows);
    
    if(rows > 0) {
        [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}
@end
