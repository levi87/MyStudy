//
//  ChatViewController.h
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "FaceToolBar.h"
#import "WeiBoHttpManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageBrowser.h"
#import "KxMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource,FaceToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,ImageBrowserDelegate> {
    NSMutableArray *bubbleData;
    UIImagePickerController *_imagePicker;
    BOOL _isFirst;
    BOOL _isReload;
    
    AVAudioRecorder *recorder;
    NSTimer *recordtTimer;
    
    ImageBrowser        *_browserView;
    NSString *tmpVoicePath;
    NSString *voiceRecordLength;
    
    UILabel *tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
    __weak IBOutlet UIView *recordBackgroundView;
    
    NSInteger fingerX;
    NSInteger fingerY;
    __weak IBOutlet UILabel *recordViewLabel;
    __weak IBOutlet UIView *recordPowerView;
    __weak IBOutlet UILabel *recordLengthLabel;
}
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@property BOOL isFirst;
@property BOOL isReload;

@property (nonatomic, retain)   ImageBrowser            *browserView;
@end
