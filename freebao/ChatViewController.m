//
//  ChatViewController.m
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "AppDelegate.h"
#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

#define INPUT_HEIGHT 40.0f

#define MSG_TYPE_TEXT   1
#define MSG_TYPR_PIC    2
#define MSG_TYPE_VOICE  3
#define MSG_TYPE_MAP    5

#define RECEIVE_REFRESH_VIEW @"fb_receive_msg"
#define IMAGE_TAP @"fb_image_tap"

@interface ChatViewController () {
    
    IBOutlet UIBubbleTableView *bubbleTable;
}

@end

@implementation ChatViewController
@synthesize isFirst = _isFirst;
@synthesize isReload = _isReload;
@synthesize browserView = _browserView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAudio];
    _isFirst = YES;
    _isReload = NO;
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view];
    bar.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewByNewMsg:) name:RECEIVE_REFRESH_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDidTap:) name:IMAGE_TAP object:nil];
    bubbleTable.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - toolBarHeight);
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
    bubbleTable.bubbleDataSource = self;
    
    bubbleTable.snapInterval = 120;
    
    bubbleTable.showAvatars = NO;
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
    [self queryMessageFromDb];
}

-(void)imageDidTap:(NSNotification*)notification {
    NSLog(@"tap.........");
    if ([notification.object isKindOfClass:[UIImageView class]]) {
        UIImageView *tmpImageV = notification.object;
        CGRect frame = CGRectMake(0, 0, 320, 480);
        if (_browserView == nil) {
            _browserView = [[ImageBrowser alloc]initWithFrame:frame];
            [_browserView setUp];
        }
        _browserView.image = tmpImageV.image;
        _browserView.theDelegate = self;
        [_browserView loadImage];
        [self.navigationController.view addSubview:_browserView];
    }
}

-(void)refreshViewByNewMsg:(NSNotification*)notification {
    NSLog(@"new message refresh...");
    MessageInfo *tmpMsg = notification.object;
    NSBubbleData *receiveBubble;
    if ([tmpMsg.postType integerValue] == MSG_TYPE_TEXT) {
        receiveBubble = [NSBubbleData dataWithText:tmpMsg.body date:[NSDate date] type:BubbleTypeSomeoneElse];
    } else if ([tmpMsg.postType integerValue] == MSG_TYPR_PIC) {
        receiveBubble = [NSBubbleData dataWithImage:[UIImage imageWithData:tmpMsg.data] date:[NSDate date] type:BubbleTypeSomeoneElse];
    } else if ([tmpMsg.postType integerValue] == MSG_TYPE_MAP) {
        UIEdgeInsets imageInsetsMine = {10, 10, 225, 225};
        receiveBubble = [NSBubbleData dataWithPosition:@"" date:[NSDate date] type:BubbleTypeSomeoneElse insets:imageInsetsMine];
    }
    [bubbleData insertObject:receiveBubble atIndex:[bubbleData count] - 1];
    
    [bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];
}

-(void)queryMessageFromDb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tmpArray = [LPDataBaseutil readMessage:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]] userId:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < [tmpArray count]; i ++) {
                MessageInfo *tmpM = [tmpArray objectAtIndex:i];
                if ([tmpM.postType integerValue] == MSG_TYPE_TEXT) {
                    NSBubbleData *tmpBd;
                    if ([tmpM.isSelf integerValue] == 1) {
                        tmpBd = [NSBubbleData dataWithText:tmpM.body date:[NSDate date] type:BubbleTypeMine];
                    } else {
                        tmpBd = [NSBubbleData dataWithText:tmpM.body date:[NSDate date] type:BubbleTypeSomeoneElse];
                    }
                    [bubbleData addObject:tmpBd];
                } else if ([tmpM.postType integerValue] == MSG_TYPR_PIC) {
                    NSBubbleData *tmpBd;
                    if ([tmpM.isSelf integerValue] == 1) {
                        tmpBd = [NSBubbleData dataWithImage:[UIImage imageWithData:tmpM.data] date:[NSDate date] type:BubbleTypeMine];
                    } else {
                        tmpBd = [NSBubbleData dataWithImage:[UIImage imageWithData:tmpM.data] date:[NSDate date] type:BubbleTypeSomeoneElse];
                    }
                    [bubbleData addObject:tmpBd];
                } else if ([tmpM.postType integerValue] == MSG_TYPE_VOICE) {
                    
                } else if ([tmpM.postType integerValue] == MSG_TYPE_MAP) {
                    NSBubbleData *tmpBd;
                    if ([tmpM.isSelf integerValue] == 1) {
                        UIEdgeInsets imageInsetsMine = {5, 5, 225, 225};
                        tmpBd = [NSBubbleData dataWithPosition:@"" date:[NSDate date] type:BubbleTypeMine insets:imageInsetsMine];
                    } else {
                        UIEdgeInsets imageInsetsMine = {10, 10, 225, 225};
                        tmpBd = [NSBubbleData dataWithPosition:@"" date:[NSDate date] type:BubbleTypeSomeoneElse insets:imageInsetsMine];
                    }
                    [bubbleData addObject:tmpBd];
                }
            }
            [bubbleTable reloadData];
            [self scrollToBottomAnimated:NO];
        });
    });
}

-(void)sendTextAction:(NSString *)inputText Frame:(CGRect)frame {
    NSLog(@"[ssss]");
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:inputText];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    //发送者
    NSXMLElement *fromId = [NSXMLElement elementWithName:@"fromId"];
    [fromId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    //发送者昵称
    NSXMLElement *nickName = [NSXMLElement elementWithName:@"nickName"];
    [nickName setStringValue:@"levi"];
    //语音时长
    NSXMLElement *voiceLength = [NSXMLElement elementWithName:@"voiceLength"];
    [voiceLength setStringValue:@"10"];
    //头像Url
    NSXMLElement *headIconUrl = [NSXMLElement elementWithName:@"headIconUrl"];
    [headIconUrl setStringValue:@"http://www.freebao.com/head.img"];
    //发送时间
    NSXMLElement *date = [NSXMLElement elementWithName:@"date"];
    [date setStringValue:@"2013-07-12"];
    //发送类型
    NSXMLElement *type = [NSXMLElement elementWithName:@"postType"];
    [type setStringValue:[NSString stringWithFormat:@"%d", MSG_TYPE_TEXT]];
    //语言
    NSXMLElement *language = [NSXMLElement elementWithName:@"language"];
    [language setStringValue:@"zh_CN"];
    //数据（声音/图片）
    NSXMLElement *bData = [NSXMLElement elementWithName:@"bData"];
    [bData setStringValue:@""];
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [mes addChild:bData];
    [KAppDelegate.xmppStream sendElement:mes];
    [self insertMessageToDb:inputText PostType:[NSString stringWithFormat:@"%d",MSG_TYPE_TEXT] Bdata:nil];
    [UIView animateWithDuration:0.2 animations:^{
        [bubbleTable setFrame:CGRectMake(0, 0, 320, frame.origin.y)];
    }completion:^(BOOL finished){
        if (finished) {
            NSBubbleData *heyBubble = [NSBubbleData dataWithText:inputText date:[NSDate date] type:BubbleTypeMine];
            [bubbleData insertObject:heyBubble atIndex:[bubbleData count] - 1];
            [bubbleTable reloadData];
            [self scrollToBottomAnimated:YES];
        }
    }];
}

- (void)insertMessageToDb:(NSString*)body PostType:(NSString*)postType Bdata:(NSData*)bData {
    if (KAppDelegate.insertChatQueen == nil) {
        KAppDelegate.insertChatQueen = dispatch_queue_create("insertChat", NULL);
    }
    dispatch_async(KAppDelegate.insertChatQueen, ^{
        [LPDataBaseutil insertMessageLast:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]] nickName:@"test" date:[NSDate date] face_path:@"" voicetime:@"0" body:body postType:postType isSelf:@"1" language:@"0" fail:@"0" userId:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID]] bData:bData];
    });
}

-(void)showKeyboard:(CGRect)frame {
    NSLog(@"show");
    NSLog(@"[levi]toolbar frame y %f", frame.origin.y);
//    [bubbleTable setContentOffset:CGPointMake(bubbleTable.contentOffset.x, bubbleTable.contentOffset.y - (415 - frame.origin.y) ) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [bubbleTable setFrame:CGRectMake(0, 0, 320, frame.origin.y)];
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
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:_imagePicker animated:YES];
    } else if (tmpButton.tag == 2) {
        NSLog(@"ChoosePhoto...");
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:_imagePicker animated:YES];
    } else if (tmpButton.tag == 3) {
        NSLog(@"sendMap");
        [self sendMyPositon];
    }
}

-(void)voiceLongPressAction:(UILongPressGestureRecognizer *)recogonizer {
    CGPoint p = [recogonizer locationInView:self.view];
    NSLog(@"[levi] finger position... x %f y %f", p.x, p.y);
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
            if (cTime > 2) {//如果录制时间<2 不发送
                NSLog(@"send voice...");
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

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"voice power %lf",lowPassResults);
    //最大50  0
//    //图片 小-》大
//    if (0<lowPassResults<=0.06) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
//    }else if (0.06<lowPassResults<=0.13) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
//    }else if (0.13<lowPassResults<=0.20) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
//    }else if (0.20<lowPassResults<=0.27) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
//    }else if (0.27<lowPassResults<=0.34) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
//    }else if (0.34<lowPassResults<=0.41) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
//    }else if (0.41<lowPassResults<=0.48) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
//    }else if (0.48<lowPassResults<=0.55) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
//    }else if (0.55<lowPassResults<=0.62) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
//    }else if (0.62<lowPassResults<=0.69) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
//    }else if (0.69<lowPassResults<=0.76) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
//    }else if (0.76<lowPassResults<=0.83) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
//    }else if (0.83<lowPassResults<=0.9) {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
//    }else {
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
//    }
}

-(void)sendMyPositon {
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[NSString stringWithFormat:@"%g=%g",120.204,30.2094]];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    //发送者
    NSXMLElement *fromId = [NSXMLElement elementWithName:@"fromId"];
    [fromId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    //发送者昵称
    NSXMLElement *nickName = [NSXMLElement elementWithName:@"nickName"];
    [nickName setStringValue:@"levi"];
    //语音时长
    NSXMLElement *voiceLength = [NSXMLElement elementWithName:@"voiceLength"];
    [voiceLength setStringValue:@"10"];
    //头像Url
    NSXMLElement *headIconUrl = [NSXMLElement elementWithName:@"headIconUrl"];
    [headIconUrl setStringValue:@"http://www.freebao.com/head.img"];
    //发送时间
    NSXMLElement *date = [NSXMLElement elementWithName:@"date"];
    [date setStringValue:@"2013-07-12"];
    //发送类型
    NSXMLElement *type = [NSXMLElement elementWithName:@"postType"];
    [type setStringValue:[NSString stringWithFormat:@"%d", MSG_TYPE_MAP]];
    //语言
    NSXMLElement *language = [NSXMLElement elementWithName:@"language"];
    [language setStringValue:@"zh_CN"];
    //数据（声音/图片）
    NSXMLElement *bData = [NSXMLElement elementWithName:@"bData"];
    [bData setStringValue:@""];
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [mes addChild:bData];
    [KAppDelegate.xmppStream sendElement:mes];
    [self insertMessageToDb:@"" PostType:[NSString stringWithFormat:@"%d", MSG_TYPE_MAP] Bdata:nil];
//    mapImageView = [[EGOImageView alloc] init];
//    mapImageView.frame = CGRectMake(0, 0, 300, 300);
//    NSString *myPositionUrl=@"http://maps.google.com/maps/api/staticmap?center=30.2094,120.204&zoom=14&size=120x120&sensor=false&markers=30.2094,120.204&language=zh_CN";
//    mapImageView.imageURL = [NSURL URLWithString:myPositionUrl];
//    [self.navigationController.view addSubview:mapImageView];
    UIEdgeInsets imageInsetsMine = {5, 5, 225, 225};
    NSBubbleData *heyBubble = [NSBubbleData dataWithPosition:@"" date:[NSDate date] type:BubbleTypeMine insets:imageInsetsMine];
    [bubbleData insertObject:heyBubble atIndex:[bubbleData count] - 1];
    [bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"[levi]take photo...");
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *pictureData = UIImageJPEGRepresentation(editedImage,1);
    
    NSString* pictureDataString = [pictureData base64Encoded];
    
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@""];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"@t.freebao.com"]];
    //发送者
    NSXMLElement *fromId = [NSXMLElement elementWithName:@"fromId"];
    [fromId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    //发送者昵称
    NSXMLElement *nickName = [NSXMLElement elementWithName:@"nickName"];
    [nickName setStringValue:@"levi"];
    //语音时长
    NSXMLElement *voiceLength = [NSXMLElement elementWithName:@"voiceLength"];
    [voiceLength setStringValue:@"10"];
    //头像Url
    NSXMLElement *headIconUrl = [NSXMLElement elementWithName:@"headIconUrl"];
    [headIconUrl setStringValue:@"http://www.freebao.com/head.img"];
    //发送时间
    NSXMLElement *date = [NSXMLElement elementWithName:@"date"];
    [date setStringValue:@"2013-07-12"];
    //发送类型
    NSXMLElement *type = [NSXMLElement elementWithName:@"postType"];
    [type setStringValue:[NSString stringWithFormat:@"%d", MSG_TYPR_PIC]];
    //语言
    NSXMLElement *language = [NSXMLElement elementWithName:@"language"];
    [language setStringValue:@"zh_CN"];
    //数据（声音/图片）
    NSXMLElement *bData = [NSXMLElement elementWithName:@"bData"];
    [bData setStringValue:pictureDataString];
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [mes addChild:bData];
    [KAppDelegate.xmppStream sendElement:mes];
    [self insertMessageToDb:@"" PostType:[NSString stringWithFormat:@"%d",MSG_TYPR_PIC] Bdata:pictureData];
    NSBubbleData *heyBubble = [NSBubbleData dataWithImage:[UIImage imageWithData:pictureData] date:[NSDate date] type:BubbleTypeMine];
    [bubbleData insertObject:heyBubble atIndex:[bubbleData count] - 1];
    [bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger sections = [bubbleTable numberOfSections];
    NSInteger rows = [bubbleTable numberOfRowsInSection:sections - 1];
    NSLog(@"[levi] rows %d", rows);
    
    if(rows > 0) {
        [bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:sections - 1]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

-(void)hideKeyboard:(CGRect)frame {
    NSLog(@"hide");
    NSLog(@"[levi]toolbar frame y %f", frame.origin.y);
    [UIView animateWithDuration:0.3 animations:^{
        [bubbleTable setFrame:CGRectMake(0, 0, 320, frame.origin.y)];
    }completion:^(BOOL finished){
        if (finished) {
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"[view] will disappear...");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"[view] view did appear...");
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"[view] view will appear...");
    //    [KAppDelegate.tabBarVC.tabbar setHide:YES];
    if (!_isFirst) {
        NSLog(@"[here...]");
        _isFirst = FALSE;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewByNewMsg:) name:RECEIVE_REFRESH_VIEW object:nil];
    }
    if (_isReload) {
        _isReload = FALSE;
        [self queryMessageFromDb];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    NSLog(@"[view] view did unload...");
    bubbleTable = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setChatBarView:nil];
    [self setRecordView:nil];
    [super viewDidUnload];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
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
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}
@end
