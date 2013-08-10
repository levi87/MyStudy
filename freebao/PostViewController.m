//
//  PostViewController.m
//  freebao
//
//  Created by freebao on 13-7-22.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PostViewController.h"
#define FONT @"HelveticaNeue-Light"
#define FB_FAKE_WEIBO @"fb_fake_weibo"
#define INIT_FACEVIEW_POSITION @"init_faceview_position"
#define FB_SET_AT_NAME @"fb_set_at_name"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize avPlay = _avPlay;

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
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _customActionSheet = [[CustomActionSheet alloc] init];
    [_customActionSheet addButtonWithTitle:@"Take Photo"];
    [_customActionSheet addButtonWithTitle:@"Library"];
    [_customActionSheet addButtonWithTitle:@"Cancel"];
    _customActionSheet.delegate = self;
    _mkMap = [[MKMapView alloc] init];
    _mkMap.delegate = self;
    _isLocation = NO;
    _hasLocation = NO;
    _hasPhoto = NO;
    _hasVoice = NO;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _geocoder = [[CLGeocoder alloc] init];
    bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view IsCommentView:YES IsPostView:YES];
    bar.delegate=self;
    self.voicePlayButton.imageView.animationImages = [NSArray arrayWithObjects:
                                                      [UIImage imageNamed:@"icon_postedit_voice0_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice1_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice2_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice3_normal"],
                                                      nil];
    self.voicePlayButton.imageView.animationDuration = 1;
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetCircleWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRequestCircle:) name:FB_GET_CIRCLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAtName:) name:FB_SET_AT_NAME object:nil];
}

-(void)setAtName:(NSNotification*)notification {
    NSLog(@"at %@", notification.object);
    self.postTextView.text = [NSString stringWithFormat:@"%@ @%@ ",self.postTextView.text, notification.object];
}

- (void)onRequestCircle:(NSNotification*)notification {
    NSLog(@"[levi] onRequest %@", (NSDictionary*)notification.object);
    NSArray *tmpArray = notification.object;
    defaultCircle = [(NSDictionary*)[tmpArray objectAtIndex:0] objectForKey:@"teamId"];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@" x, %f y, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:FB_USER_LATITUDE];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:FB_USER_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_geocoder reverseGeocodeLocation:tmpLocation completionHandler:^(NSArray *placeMarks, NSError *error) {
//        NSLog(@"[levi] place Marks %@", placeMarks);
        for (CLPlacemark *placeMark in placeMarks)  {
            NSString *country = placeMark.country;
            NSString *city = placeMark.locality;
            NSString *thoroughfare = placeMark.thoroughfare;
            NSString *subLocality = placeMark.subLocality;
            NSString *subThoroughfare = placeMark.subThoroughfare;
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", country, city, subLocality , thoroughfare, subThoroughfare];
            }
        _isLocation = YES;
        [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_on"] forState:UIControlStateNormal];
        [SVProgressHUD dismiss];
    }];
}

-(void)hideKeyboardPost {
    NSLog(@"hide k");
    [self.postTextView resignFirstResponder];
}

-(void)showKeyboardPost {
    NSLog(@"show k");
    [self.postTextView becomeFirstResponder];
}

-(void)hideKeyboardAndFaceV {
    NSLog(@"hide keyboard...");
    [self.postTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainScrollView setFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 45)];
    }completion:^(BOOL finished){
        if (finished) {
            //            [self scrollToBottomAnimated:YES];
        }
    }];
}

-(void)inputText:(NSString *)str {
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.postTextView.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[self.postTextView.text substringFromIndex:self.postTextView.text.length-2]]) {
                NSLog(@"删除emoji %@",[self.postTextView.text substringFromIndex:self.postTextView.text.length-2]);
                newStr=[self.postTextView.text substringToIndex:self.postTextView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[self.postTextView.text substringFromIndex:self.postTextView.text.length-1]);
                newStr=[self.postTextView.text substringToIndex:self.postTextView.text.length-1];
            }
            self.postTextView.text=newStr;
        }
        NSLog(@"删除后更新%@",self.postTextView.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",self.postTextView.text,str];
        [self.postTextView setText:newStr];
        NSLog(@"点击其他后更新%d,%@",str.length,self.postTextView.text);
    }
}

-(void)showKeyboard:(CGRect)frame {
    NSLog(@"show");
    NSLog(@"[levi]toolbar frame y %f", frame.origin.y);
    //    [bubbleTable setContentOffset:CGPointMake(bubbleTable.contentOffset.x, bubbleTable.contentOffset.y - (415 - frame.origin.y) ) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainScrollView setFrame:CGRectMake(0, 44, 320, frame.origin.y)];
    }completion:^(BOOL finished){
        if (finished) {
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

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:INIT_FACEVIEW_POSITION object:nil];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.mainScrollView setFrame:CGRectMake(0, 44, 320, 568)];
    } else {
        [self.mainScrollView setFrame:CGRectMake(0, 44, 320, 460)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_CIRCLE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_SET_AT_NAME object:nil];
    [self setSelectPictureButton:nil];
    [self setUpperView:nil];
    [self setUserLocationButton:nil];
    [self setAddressLabel:nil];
    [self setMainScrollView:nil];
    [self setPostTextView:nil];
    recordBackgroundView = nil;
    recordViewLabel = nil;
    recordLengthLabel = nil;
    recordPowerImageView = nil;
    [self setRecordView:nil];
    [self setVoiceLengthLabel:nil];
    [self setVoiceImageView:nil];
    [self setVoicePlayButton:nil];
    [super viewDidUnload];
}

- (IBAction)getUserLocationAction:(id)sender {
    NSLog(@"show user location,,,");
    if (_isLocation) {
        if ([_geocoder isGeocoding]) {
            [_geocoder cancelGeocode];
        }
        [SVProgressHUD dismiss];
        self.addressLabel.text = @"";
        _mkMap.showsUserLocation = NO;
        _isLocation = NO;
        [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_off"] forState:UIControlStateNormal];
    } else {
        [SVProgressHUD showWithStatus:@"Locating..."];
        _mkMap.showsUserLocation = YES;
    }
}


- (IBAction)backButtonAction:(id)sender {
    [self clearData];
    if ([_geocoder isGeocoding]) {
        [_geocoder cancelGeocode];
    }
    [SVProgressHUD dismiss];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)SelectPictureAction:(id)sender {
    [_customActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 1:
            NSLog(@"1");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"[levi]take photo...");
    _hasPhoto = YES;
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSData *pictureData = UIImageJPEGRepresentation(editedImage,1);
    _photoData = UIImageJPEGRepresentation(editedImage, 1);
    [_photoData writeToFile:[self returnFilePath:@"tmpShareJPEG@2x.jpg"] atomically:YES];
    [self.selectPictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
}

-(NSString *)returnFilePath:(NSString*)nameStr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:nameStr];
    
    return filePath;
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

-(void)voiceLongPressAction:(UILongPressGestureRecognizer *)recogonizer {
    if (!_hasPhoto) {
        NSLog(@"please select a photo.");
        switch (recogonizer.state) {
            case UIGestureRecognizerStateBegan:
            {
                iToast *itoast = [[iToast alloc] initWithText:@"please select a photo first"];
                [itoast setToastPosition:kToastPositionCenter];
                [itoast setToastDuration:kToastDurationNormal];
                [itoast show];
            }
                break;
            case UIGestureRecognizerStateEnded:
                break;
            default:
                break;
        }
        return;
    }
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
                _hasVoice = YES;
                self.VoiceImageView.hidden = NO;
                self.voiceLengthLabel.text = [NSString stringWithFormat:@"%@ s", voiceRecordLength];
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
- (IBAction)voicePlayButtonAction:(id)sender {
    NSURL *soundUrl = [NSURL URLWithString:tmpVoicePath];
    if (self.avPlay.playing) {
        [self.voicePlayButton.imageView stopAnimating];
        [playTimer invalidate];
        [self.avPlay stop];
        return;
    }
    [self.voicePlayButton.imageView startAnimating];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.avPlay = player;
    self.avPlay.delegate = self;
    [self.avPlay play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.voicePlayButton.imageView stopAnimating];
}
- (IBAction)PostAciton:(id)sender {
    StatusInfo *fakeStatusInfo = [[StatusInfo alloc] init];
    fakeStatusInfo.isFakeWeibo = YES;
    fakeStatusInfo.commentCount = @"0";
    fakeStatusInfo.likeCount = @"0";
    fakeStatusInfo.content = self.postTextView.text;
    fakeStatusInfo.contentId = @"0";
    fakeStatusInfo.createAt = @"just now";
    fakeStatusInfo.liked = @"0";
    if (_hasPhoto) {
        fakeStatusInfo.originalPicUrl = [self returnFilePath:@"tmpShareJPEG.jpg"];
    } else {
        fakeStatusInfo.originalPicUrl = @"0";
    }
    fakeStatusInfo.distance = @"0";
    fakeStatusInfo.postLanguage = @"0";
    fakeStatusInfo.userFacePath = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_FACE_PATH];
    fakeStatusInfo.userId = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID];
    fakeStatusInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_NAME];
    fakeStatusInfo.rePostDic = nil;

    if ([_geocoder isGeocoding]) {
        [_geocoder cancelGeocode];
    }
    [SVProgressHUD dismiss];
    [self dismissModalViewControllerAnimated:YES];

    [self performSelector:@selector(delayPostNotification:) withObject:fakeStatusInfo afterDelay:0.2];
}

-(void)delayPostNotification:(Status *)status{
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setValue:[NSNumber numberWithBool:_hasLocation] forKey:@"hasLocation"];
    [tmpDic setValue:[NSNumber numberWithBool:_hasPhoto] forKey:@"hasPhoto"];
    [tmpDic setValue:[NSNumber numberWithBool:_hasVoice] forKey:@"hasVoice"];
    [tmpDic setValue:[self returnFilePath:@"tmpShareJPEG@2x.jpg"] forKey:@"PhotoPath"];
    [tmpDic setValue:tmpVoicePath forKey:@"VoicePath"];
    [tmpDic setValue:defaultCircle forKey:@"defaultCircle"];
    [tmpDic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_LATITUDE] forKey:@"latitude"];
    [tmpDic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_LONGITUDE] forKey:@"longitude"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FB_FAKE_WEIBO object:status userInfo:tmpDic];
    [self clearData];
}

-(void)clearData {
    self.postTextView.text = @"";
    _hasVoice = NO;
    _hasPhoto = NO;
    _hasLocation = NO;
    if ([_geocoder isGeocoding]) {
        [_geocoder cancelGeocode];
    }
    [SVProgressHUD dismiss];
    self.addressLabel.text = @"";
    _mkMap.showsUserLocation = NO;
    self.VoiceImageView.hidden = YES;
    [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_off"] forState:UIControlStateNormal];
    [self.selectPictureButton setBackgroundImage:[UIImage imageNamed:@"icon_postedit_camera_normal"] forState:UIControlStateNormal];
}

-(void)atView {
    NSLog(@"post view...");
    AtPostViewController *fanVC = [[AtPostViewController alloc] init];
    [self presentViewController:fanVC animated:YES completion:nil];
}
@end
