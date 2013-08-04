//
//  CommentsViewController.m
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CommentsViewController.h"
#import "EGOCache.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface CommentsViewController ()

@end

@implementation CommentsViewController
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

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isRefresh = FALSE;
    isFirst = TRUE;
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view IsCommentView:YES IsPostView:NO];
    bar.delegate=self;
    
    commentsArray = [[NSMutableArray alloc] init];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetComments:) name:FB_GET_COMMENT object:nil];
    [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];

    headPhotos = [[NSMutableArray alloc] init];
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
    if (indexPath.row == 0 && isFirst) {
        isFirst = FALSE;
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

- (void)viewWillAppear:(BOOL)animated {
    //    [KAppDelegate.tabBarVC.tabbar setHide:YES];
    if (_isRefresh) {
        [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
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

#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(CommentsCell *)swipeTableViewCell {

}

-(void)swipeTableViewCell:(CommentsCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {

}

-(void)swipeTableViewCellWillResetState:(CommentsCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        NSLog(@"[levi]...mmmmmmm");
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
                         }
         ];
    }
}

-(void)swipeTableViewCellDidResetState:(CommentsCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && -point.x > CGRectGetHeight(swipeTableViewCell.frame)) {
        NSLog(@"[levi]...ppooooo");
    }
}

-(void)hideKeyboardAndFaceV {
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 45)];
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
        [self.view setFrame:CGRectMake(0, 0, 320, frame.origin.y)];
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
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                           atScrollPosition:UITableViewScrollPositionBottom
                                   animated:animated];
    }
}

@end
