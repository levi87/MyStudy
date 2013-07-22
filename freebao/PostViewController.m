//
//  PostViewController.m
//  freebao
//
//  Created by freebao on 13-7-22.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PostViewController.h"
#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define FONT @"HelveticaNeue-Light"

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
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _geocoder = [[CLGeocoder alloc] init];
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view IsCommentView:YES IsPostView:YES];
    bar.delegate=self;
    self.voicePlayButton.imageView.animationImages = [NSArray arrayWithObjects:
                                                      [UIImage imageNamed:@"icon_postedit_voice0_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice1_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice2_normal"],
                                                      [UIImage imageNamed:@"icon_postedit_voice3_normal"],
                                                      nil];
    self.voicePlayButton.imageView.animationDuration = 1;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@" x, %f y, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
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
        [SVProgressHUD dismiss];
    }];
}

-(void)hideKeyboardAndFaceV {
    [self.postTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainScrollView setFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 45)];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
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
        _isLocation = YES;
        [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_on"] forState:UIControlStateNormal];
    }
}


- (IBAction)backButtonAction:(id)sender {
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
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSData *pictureData = UIImageJPEGRepresentation(editedImage,1);
    [self.selectPictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
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
@end
