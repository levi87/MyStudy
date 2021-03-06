//
//  CommentViewController.m
//  freebao
//
//  Created by freebao on 13-7-18.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CommentViewController.h"
#import "EGOCache.h"
#import "NSDictionaryAdditions.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#define COMMENT_VOICE @"fb_comment_voice"

#define HIDE_KEYBOARD @"fb_hide_keyboard"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize cellContentId = _cellContentId;
@synthesize isRefresh = _isRefresh;
@synthesize avPlay = _avPlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didAddComments:(NSNotification*)notification {
    NSLog(@"add comment success.");
}

-(void)didGetComments:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    [commentsArray removeAllObjects];
    headPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        CommentInfo *tmpInfo = [[CommentInfo alloc] init];
        tmpInfo.nickName = [tmpDic getStringValueForKey:@"nickname" defaultValue:@""];
        tmpInfo.commentUserId = [tmpDic getStringValueForKey:@"commentUid" defaultValue:@"0"];
        tmpInfo.content = [tmpDic objectForKey:@"commentBody"];
        tmpInfo.contentId = [tmpDic objectForKey:@"contentId"];
        tmpInfo.commentId = [tmpDic objectForKey:@"commentId"];
        tmpInfo.commentDate = [tmpDic objectForKey:@"historyInfo"];
        tmpInfo.voiceUrl = [tmpDic getStringValueForKey:@"soundPath" defaultValue:@"0"];
        tmpInfo.voiceLength = [tmpDic getStringValueForKey:@"soundTime" defaultValue:@"0"];
        tmpInfo.languageType = [tmpDic getStringValueForKey:@"language" defaultValue:@""];
        NSLog(@"voiceUrl %@", tmpInfo.voiceUrl);
        [commentsArray addObject:tmpInfo];
        [headPhotos addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.commentTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAudio];
    CGRect frame;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        frame = self.view.frame;
        frame.size.height = 568;
        self.view.frame = frame;
    } else {
        frame = self.view.frame;
        frame.size.height = 460;
        self.view.frame = frame;
    }
    _isRefresh = FALSE;
    isFirst = TRUE;
    bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view IsCommentView:YES IsPostView:NO];
    bar.delegate=self;
    
    commentsArray = [[NSMutableArray alloc] init];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetComments:) name:FB_GET_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddComments:) name:FB_ADD_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVoice:) name:COMMENT_VOICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestVoiceResult:) name:FB_GET_TRANSLATION_VOICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslateResult:)       name:FB_GET_TRANSLATION_COMMENT object:nil];
    [manager FBGetCommentWithHomelineId:_cellContentId StatusType:@"0" Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    
    headPhotos = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.commentTableView setTableHeaderView:headerView];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"selected row %d", indexPath.row);
//    CommentInfo *tmpInfo = [commentsArray objectAtIndex:indexPath.row];
//    bar.textView.text = [NSString stringWithFormat:@"@%@ ", tmpInfo.nickName];
//    [bar.textView becomeFirstResponder];
//}

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
    [self setRecordView:nil];
    recordBackgroundView = nil;
    recordViewLabel = nil;
    recordLengthLabel = nil;
    recordPowerImageView = nil;
    recordPowerView = nil;
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
    [cell setCellValue:(CommentInfo*)[commentsArray objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentInfo *tmpInfo = [commentsArray objectAtIndex:indexPath.row];
    NSString *comentUserId = tmpInfo.commentUserId;
    NSLog(@"comment %@  fuser %@", comentUserId, [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]);
    if ([[NSString stringWithFormat:@"%@",comentUserId] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]]]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"comment...size %d", [commentsArray count]);
    NSString *commentId = [(CommentInfo*)[commentsArray objectAtIndex:indexPath.row] commentId];
    [manager FBDeleteMyCommentWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] CommentId:commentId PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [commentsArray removeObjectAtIndex:indexPath.row];
    [self.commentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tmpHeight;
    CommentInfo *tmpInfo = [commentsArray objectAtIndex:indexPath.row];
    tmpHeight = [CommentsCell getJSHeight:tmpInfo.content jsViewWith:230.0];
    NSLog(@"tmpHeight %f", tmpHeight);
    if (![tmpInfo.voiceUrl isEqualToString:@"0"]) {
        tmpHeight += 30;
    }
    return 23 + tmpHeight + 25;
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

-(void)sendTextAction:(NSString *)inputText Frame:(CGRect)frame {
    NSLog(@"send comment %@", inputText);
    CommentInfo *tmpInfo = [[CommentInfo alloc] init];
    tmpInfo.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_NICK_NAME];
    tmpInfo.content = inputText;
    tmpInfo.commentDate = @"just now";
    tmpInfo.voiceLength = @"0";
    tmpInfo.voiceUrl = @"0";
    [headPhotos insertObject:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_FACE_PATH] atIndex:0];
    [commentsArray insertObject:tmpInfo atIndex:0];
    [self.commentTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [manager FBAddAddWeiboCommentWithContentId:_cellContentId CommentContent:inputText UserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID] CommentId:@"" VoiceData:nil];
}

-(void)voiceLongPressAction:(UILongPressGestureRecognizer *)recogonizer {
    CGPoint p = [recogonizer locationInView:self.view];
    //    NSLog(@"[levi] finger position... x %f y %f", p.x, p.y);
    fingerX = p.x;
    fingerY = p.y;
    if (fingerX > 75 && fingerX < 235 && fingerY > 135 && fingerY < 285) {
        recordViewLabel.text = @"Cancel To Send";
    } else {
        recordViewLabel.text = @"Slide up to cancel";
    }
    switch (recogonizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"[levi] start record");
            self.recordView.hidden = NO;
            //创建录音文件，准备录音
            if ([recorder prepareToRecord]) {
                //开始
                [recorder record];
            }
            recordtTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"[levi] end record");
            self.recordView.hidden = YES;
            double cTime = recorder.currentTime;
            NSLog(@"record length %f", cTime);
            voiceRecordLength = [NSString stringWithFormat:@"%.f", cTime];
            if (fingerX > 75 && fingerX < 235 && fingerY > 135 && fingerY < 285) {
                [recorder deleteRecording];
                [recorder stop];
                [recordtTimer invalidate];
                NSLog(@"[levi] cancel record");
                return;
            }
            if (cTime > 2) {//如果录制时间<2 不发送
                NSLog(@"send voice...");
                [self sendVoiceAction];
            }else {
                NSLog(@"delete voice...");
                //删除记录的文件
                [recorder deleteRecording];
                //删除存储的
            }
            [recorder stop];
            [recordtTimer invalidate];
        }
            break;
        default:
            break;
    }
}

-(void)sendVoiceAction {
    NSLog(@"send voice comment...");
    CommentInfo *tmpInfo = [[CommentInfo alloc] init];
    tmpInfo.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_NICK_NAME];
    tmpInfo.content = @"";
    tmpInfo.commentDate = @"just now";
    tmpInfo.voiceLength = voiceRecordLength;
    tmpInfo.voiceUrl = tmpVoicePath;
    [headPhotos insertObject:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_FACE_PATH] atIndex:0];
    [commentsArray insertObject:tmpInfo atIndex:0];
    [self.commentTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [manager FBAddAddWeiboCommentWithContentId:_cellContentId CommentContent:@"" UserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID] CommentId:@"" VoiceData:[NSData dataWithContentsOfFile:tmpVoicePath]];
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    double cTime = recorder.currentTime;
    NSLog(@"record length %f", cTime);
    recordLengthLabel.text = [NSString stringWithFormat:@"%.f s", cTime];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"voice power %lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.13) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action01"]];
    }else if (0.06<lowPassResults<=0.13) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action02"]];
    }else if (0.13<lowPassResults<=0.20) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action03"]];
    }else if (0.20<lowPassResults<=0.27) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action04"]];
    }else if (0.27<lowPassResults<=0.34) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action05"]];
    }else if (0.34<lowPassResults<=0.41) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action06"]];
    }else if (0.41<lowPassResults<=0.48) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action07"]];
    }else if (0.48<lowPassResults<=0.55) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action08"]];
    }else if (0.55<lowPassResults<=0.62) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action09"]];
    }else if (0.62<lowPassResults<=0.69) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action10"]];
    }else if (0.69<lowPassResults<=0.76) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action10"]];
    }else if (0.76<lowPassResults<=0.83) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action10"]];
    }else if (0.83<lowPassResults) {
        [recordPowerImageView setImage:[UIImage imageNamed:@"big-voice-action10"]];
    }
}

- (void)initAudio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/tmpAudio.aac", strUrl]];
    tmpVoicePath = [NSString stringWithFormat:@"%@/tmpAudio.aac", strUrl];
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

-(void)playVoice:(NSNotification*)notification {
    NSLog(@"[levi] playVoice..");
    CommentsCell *tmpC = [notification.object objectForKey:@"cell"];
    CommentInfo *tmpInfo = [commentsArray objectAtIndex:tmpC.indexPath.row];
    NSLog(@"sound url %@ body %@ cell row %d", tmpInfo.voiceUrl, tmpInfo.content, tmpC.indexPath.row);
    NSURL *soundUrl = [NSURL URLWithString:tmpInfo.voiceUrl];
    if (self.avPlay.playing) {
        [self detectionPlayTime];
        [playTimer invalidate];
        [self.avPlay stop];
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.avPlay = player;
    [self.avPlay play];
//    CommentInfo *data = [[bubbleTable.bubbleSection objectAtIndex:tmpIndexP.section] objectAtIndex:tmpIndexP.row - 1];
//    data.isPlayAnimation = YES;
//    [bubbleData replaceObjectAtIndex:tmpIndexP.row - 1 withObject:data];
    //    [bubbleTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpIndexP] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tmpC.soundImageView startAnimating];
//    playTimer = [NSTimer scheduledTimerWithTimeInterval:[data.voiceLength integerValue] target:self selector:@selector(detectionPlayTime) userInfo:notification.userInfo repeats:NO];
}

-(void)detectionPlayTime {
//    CommentsCell *tmpC = [playTimer.userInfo objectForKey:@"cell"];
//    NSIndexPath *tmpIndexP = tmpC.indexPath;
//    NSBubbleData *data = [[bubbleTable.bubbleSection objectAtIndex:tmpIndexP.section] objectAtIndex:tmpIndexP.row - 1];
//    data.isPlayAnimation = NO;
//    [bubbleData replaceObjectAtIndex:tmpIndexP.row - 1 withObject:data];
//    [self.commentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpIndexP] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)cellTransVoiceDidTaped:(CommentsCell *)theCell {
    NSLog(@"play trans Voice...");
    tmpIndexPath = theCell.indexPath;
    if (_avPlay.playing) {
        [_avPlay stop];
        CommentsCell *tmpCell = (CommentsCell*)[self.commentTableView cellForRowAtIndexPath:tmpIndexPath];
        [tmpCell.transVoiceImageView stopAnimating];
        return;
    }
    [manager FBGetTranslateVoiceWithBody:theCell.commentInfo.content Language:theCell.commentInfo.languageType PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)onRequestVoiceResult:(NSNotification*)notification {
    NSString *voiceUrl = notification.object;
    //    NSLog(@"[levi] voice url %@",voiceUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *tmpVoiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:tmpVoiceData error:nil];
            _avPlay = player;
            _avPlay.delegate = self;
            [_avPlay play];
        });
    });
}

-(void)cellLanguageDidTaped:(CommentsCell *)theCell {
    NSLog(@"select language....sss");
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
      
      [KxMenuItem menuItem:@"Cancel" image:nil target:self action:@selector(pushMenuItem:)],
      ];
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(150, 24, 20, 10)
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *tmpKxM = sender;
    NSLog(@"tittle %@", tmpKxM.title);
    translateLanguage = @"zh_CN";
    CommentsCell *tmpCell = (CommentsCell*)[self.commentTableView cellForRowAtIndexPath:tmpIndexPath];
    if ([tmpKxM.title isEqualToString:@"中文"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
        translateLanguage = @"zh_CN";
    } else if ([tmpKxM.title isEqualToString:@"English"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
        translateLanguage = @"en_US";
    } else if ([tmpKxM.title isEqualToString:@"日本語"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
        translateLanguage = @"ja_JP";
    } else if ([tmpKxM.title isEqualToString:@"한국어"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
        translateLanguage = @"ko_KR";
    } else if ([tmpKxM.title isEqualToString:@"España"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
        translateLanguage = @"es_ES";
    } else if ([tmpKxM.title isEqualToString:@"Français"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
        translateLanguage = @"fr_FR";
    } else if ([tmpKxM.title isEqualToString:@"Deutsch"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_d"]];
        translateLanguage = @"";
    } else if ([tmpKxM.title isEqualToString:@"русский"]) {
        [tmpCell.languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
        translateLanguage = @"ru_RU";
    }
    [self getTranslate:tmpCell.commentInfo.content Language:translateLanguage];
}

-(void)getTranslate:(NSString *)content Language:(NSString*)language{
    NSLog(@"language %@", language);
    [SVProgressHUD showWithStatus:@"request translate..." maskType:SVProgressHUDMaskTypeGradient];
    [manager FBGetTranslateWithBodyComment:content Language:language PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)onTranslateFailResult:(NSNotification*)notification {
    [SVProgressHUD dismiss];
}

-(void)onTranslateResult:(NSNotification*)notification {
    NSLog(@"fdafbakhkflkah");
    NSLog(@"[levi] translate result %@", notification.object);
    NSString *transResult = notification.object;
    CGFloat transHeght = [CommentsCell getJSHeight:transResult jsViewWith:300];
    NSLog(@"trans %f", transHeght);
    for (int i = tmpIndexPath.row + 1; i < [commentsArray count]; i ++) {
        CommentsCell *tmpCommentCell = (CommentsCell*)[self.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        tmpCommentCell.frame = CGRectMake(tmpCommentCell.frame.origin.x, tmpCommentCell.frame.origin.y + transHeght, tmpCommentCell.frame.size.width, tmpCommentCell.frame.size.height);
    }
    CommentsCell *tmpCell = (CommentsCell*)[self.commentTableView cellForRowAtIndexPath:tmpIndexPath];
    [tmpCell showTranslateTextView:transResult StatusInfo:[commentsArray objectAtIndex:tmpIndexPath.row]];
    CGRect frame = tmpCell.frame;
    frame.size.height += transHeght + 10;
    tmpCell.frame = frame;
    [SVProgressHUD dismiss];
}
@end
