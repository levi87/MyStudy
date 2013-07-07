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

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource,FaceToolBarDelegate> {
    NSMutableArray *bubbleData;
}
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@end
