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

@interface ChatViewController () {
    
    IBOutlet UIBubbleTableView *bubbleTable;
}

@end

@implementation ChatViewController

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
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view];
    bar.delegate=self;
    
    //Note to reader - the blue initial button is inset 3px on all sides from
    // the initial frame you provide.  You should provide a square rect of any
    // size.
    
    bubbleTable.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - toolBarHeight);
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = NO;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
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
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [KAppDelegate.xmppStream sendElement:mes];
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
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [KAppDelegate.xmppStream sendElement:mes];
    
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
    [body setStringValue:pictureDataString];
    
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
    //组合
    [mes addChild:body];
    [mes addChild:fromId];
    [mes addChild:nickName];
    [mes addChild:voiceLength];
    [mes addChild:headIconUrl];
    [mes addChild:date];
    [mes addChild:type];
    [mes addChild:language];
    [KAppDelegate.xmppStream sendElement:mes];
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    //    [KAppDelegate.tabBarVC.tabbar setHide:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    bubbleTable = nil;
    [self setChatBarView:nil];
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
@end
