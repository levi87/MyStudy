//
//  MessageUIView.h
//  freebao
//
//  Created by levi on 13-6-1.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class MessageUIView;

@protocol MessageUIViewDelegate <NSObject>
@required
-(void)returnValueToShow:(id)sender;

@end

@interface MessageUIView : UIView
@property (strong ,nonatomic)id<MessageUIViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *sliderBar;
- (IBAction)navigationTabClicked:(id)sender;

+ (MessageUIView*)instanceTitleView;
@end
