//
//  PostViewController.h
//  freebao
//
//  Created by freebao on 13-7-22.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"
#import "FaceToolBar.h"
#import <AVFoundation/AVFoundation.h>
#import "Status.h"
#import "WeiBoHttpManager.h"
#import "WeiBoMessageManager.h"

@class WeiBoMessageManager;
@interface PostViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,MKMapViewDelegate,CLLocationManagerDelegate,FaceToolBarDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate> {
    WeiBoMessageManager *manager;
    UIImagePickerController *_imagePicker;
    CustomActionSheet *_customActionSheet;
    MKMapView *_mkMap;
    BOOL _isLocation;
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    
    NSInteger fingerX;
    NSInteger fingerY;
    AVAudioRecorder *recorder;
    NSTimer *recordtTimer;
    NSTimer *playTimer;
    NSString *voiceRecordLength;
    NSString *tmpVoicePath;
    __weak IBOutlet UIView *recordBackgroundView;
    __weak IBOutlet UILabel *recordViewLabel;
    __weak IBOutlet UILabel *recordLengthLabel;
    __weak IBOutlet UIImageView *recordPowerImageView;

    BOOL _hasPhoto;
    BOOL _hasVoice;
    BOOL _hasLocation;
    
    NSData          *_photoData;
    FaceToolBar* bar;
    NSString *defaultCircle;
}
- (IBAction)PostAciton:(id)sender;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIButton *selectPictureButton;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *VoiceImageView;
- (IBAction)getUserLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *voicePlayButton;
- (IBAction)voicePlayButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLengthLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UITextView *postTextView;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)SelectPictureAction:(id)sender;
@end
