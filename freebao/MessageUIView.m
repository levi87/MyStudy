//
//  MessageUIView.m
//  freebao
//
//  Created by levi on 13-6-1.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "MessageUIView.h"
@interface MessageUIView()
@end

@implementation MessageUIView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)changeMyInformationData:(id)sender {
    if ([self.delegate respondsToSelector:@selector(returnValueToShow:)]) {
        [self.delegate returnValueToShow:sender];
    }
}

+(MessageUIView*)instanceTitleView {
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"MessageUIView" owner:nil options:nil];
    MessageUIView *tmpView = [nibView objectAtIndex:0];
//    CGRect frame = tmpView.frame;
//    frame.origin.y = frame.origin.y + 70;
//    frame.origin.x = frame.origin.x + 60;
//    tmpView.frame = frame;
    return tmpView;
}

- (IBAction)navigationTabClicked:(id)sender {
    UIButton *btn = sender;
    [self moveSliderTo:btn];
    [self changeMyInformationData:sender];
}

- (void)moveSliderTo:(UIButton*) aButton
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration =0.25f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _sliderBar.layer.position.x, _sliderBar.layer.position.y);
    CGPathAddLineToPoint(path, NULL, aButton.layer.position.x, _sliderBar.layer.position.y); //添加一条路径
    positionAnimation.path = path; //设置移动路径为刚才创建的路径
    CGPathRelease(path);
    positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [_sliderBar.layer addAnimation:positionAnimation forKey:@"sliderMove"];
    [_sliderBar setCenter:CGPointMake(aButton.center.x, _sliderBar.center.y)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
