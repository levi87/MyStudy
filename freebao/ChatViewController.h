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

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource,FaceToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,ImageBrowserDelegate> {
    NSMutableArray *bubbleData;
    UIImagePickerController *_imagePicker;
    BOOL _isFirst;
    BOOL _isReload;
    
    AVAudioRecorder *recorder;
    NSTimer *recordtTimer;
    
    ImageBrowser        *_browserView;
    NSString *tmpVoicePath;
}
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@property BOOL isFirst;
@property BOOL isReload;

@property (nonatomic, retain)   ImageBrowser            *browserView;
@end
