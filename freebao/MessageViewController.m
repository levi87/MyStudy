//
//  MessageViewController.m
//  freebao
//
//  Created by levi on 13-6-1.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    MetionsStatusesVC *MentVC = [[MetionsStatusesVC alloc] initWithNibName:@"HomeLineViewController" bundle:nil];
//    UINavigationController *navMent = [[UINavigationController alloc] initWithRootViewController:MentVC];
////    [self.CommonUseView addSubview:navMent.view];
//    [MentVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:MentVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)navigationTabClicked:(id)sender {
    UIButton *btn = sender;
    [self moveSliderTo:btn];
    NSString *tmpStr = btn.restorationIdentifier;
    if ([tmpStr isEqualToString:@"atBtn"]) {
        NSLog(@"atButton");
    } else if ([tmpStr isEqualToString:@"mentionsBtn"]) {
        NSLog(@"mentionButton");
    } else if ([tmpStr isEqualToString:@"messageBtn"]) {
        NSLog(@"messageButton");
    } else if ([tmpStr isEqualToString:@"noticeBtn"]) {
        NSLog(@"noticeButton");
    }
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
@end
