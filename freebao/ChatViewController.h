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

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource,FaceToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate> {
    NSMutableArray *bubbleData;
    UIImagePickerController *_imagePicker;
    BOOL _isFirst;
    BOOL _isReload;
    
    AVAudioRecorder *recorder;
    NSTimer *recordtTimer;
}
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@property BOOL isFirst;
@property BOOL isReload;
@end
