//
//  NewRegisterViewController.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-7.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"

@protocol NewRegisterViewControllerDelegate<NSObject>
- (void)updateUsername:(NSString *)username;
@end

@interface NewRegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITapGestureRecognizer *tapRecognizer;
    WeiBoMessageManager *manager; 
}

@property(nonatomic, strong) IBOutlet UIButton *signUpBtn;
@property(nonatomic, strong) IBOutlet UITextField *emailTextFeild;
@property(nonatomic, strong) IBOutlet UITextField *confirmEmailTextFeild;
@property(nonatomic, strong) IBOutlet UITextField *passwordTextFeild;
@property(nonatomic, strong) IBOutlet UITextField *confirmPasswordTextFeild;
@property(nonatomic, strong) IBOutlet UIImageView *boxView1;
@property(nonatomic, strong) IBOutlet UIImageView *boxView2;
@property(nonatomic, strong) IBOutlet UIImageView *boxView3;
@property(nonatomic, strong) IBOutlet UIImageView *boxView4;

@property(nonatomic, strong) IBOutlet UIImageView *emailUnMatch;
@property(nonatomic, strong) IBOutlet UIImageView *passwordUnMatch;

@property (assign,nonatomic)id<NewRegisterViewControllerDelegate> delegate;

@end
