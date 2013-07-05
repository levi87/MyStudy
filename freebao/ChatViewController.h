//
//  ChatViewController.h
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource> {
    NSMutableArray *bubbleData;
}
@property (weak, nonatomic) IBOutlet UIView *chatBarView;
@end
