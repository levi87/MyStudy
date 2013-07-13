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

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource,FaceToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray *bubbleData;
    UIImagePickerController *_imagePicker;
}
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@end
