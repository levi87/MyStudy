//
//  MyPageViewController.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URBSegmentedControl.h"

@interface MyPageViewController : UIViewController {
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
