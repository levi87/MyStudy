//
//  NewLoginViewController.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-7.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"

@interface NewLoginViewController : UIViewController<UITextFieldDelegate>
{
    UITapGestureRecognizer *tapRecognizer;
    WeiBoMessageManager *manager; 
}

@property(nonatomic, strong) IBOutlet UIButton *loginBtn;
@property(nonatomic, strong) IBOutlet UITextField *emailField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)loginButtonPressed;

@end
