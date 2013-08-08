//
//  NewRegisterViewController.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-7.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NewRegisterViewController.h"

#define OFFSET 70
#define BUTTON_OFFSET 90

@interface NewRegisterViewController ()

@end

@implementation NewRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultRegisterSuccess:) name:FB_NOTIC_REGISTER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultRegisterFailed) name:FB_NOTIC_REGISTER_FAILED object:nil];
    
    
    
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titlebar_login_forgotpassword.png"]];
    titleView.frame = CGRectMake(0, 0, 320, 44);
    titleView.userInteractionEnabled = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,0, 80, 44)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 16, 7, 12)];
    [backButton addSubview:imgV];
    [self.view addSubview:titleView];
    [self.view addSubview:backButton];
    
    self.emailTextFeild.delegate = self;
    self.confirmEmailTextFeild.delegate = self;
    self.passwordTextFeild.delegate = self;
    self.confirmPasswordTextFeild.delegate = self;
    
    self.passwordTextFeild.secureTextEntry = YES;
    self.confirmPasswordTextFeild.secureTextEntry = YES;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.signUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(31, 371, 258, 40)];
    
    [self.signUpBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_normal.png"] forState:UIControlStateNormal];
    
    [self.signUpBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_preesed.png"] forState:UIControlStateSelected];
    [self.signUpBtn addTarget:self action:@selector(signUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
//    [self.signUpBtn setFont:[UIFont fontWithName:@"Helvetica Neue Bold" size:21]];
    
    UILabel *signUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(89, 0, 80, 40)];
    [signUpLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:21]];
    [signUpLabel setText:@"Sign Up"];
    [signUpLabel setTextColor:[UIColor whiteColor]];
    [signUpLabel setBackgroundColor:[UIColor clearColor]];
    [signUpLabel setTextAlignment:UITextAlignmentCenter];

    [self.signUpBtn addSubview:signUpLabel];
    [self.view addSubview:self.signUpBtn];
    
    self.emailUnMatch.hidden = YES;
    self.passwordUnMatch.hidden = YES;
 
}

- (BOOL)isUsernameLegal:(NSString *)aUsername {
    BOOL legal = NO;
    
    do {
        NSString *username = [aUsername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([username length] == 0) {
            break;
        }
        
        NSUInteger i;
        for (i=0; i<[username length]; i++) {
            unichar c = [username characterAtIndex:i];
            
            if (c > 127) {
                break;
            }
        }
        if (i != [username length]) {
            break;
        }
        
        NSRange range;
        
        range = [username rangeOfString:@"."];
        if (range.location == NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@"@"];
        if (range.location == NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@","];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@".."];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@" "];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@"@."];
        if (range.location != NSNotFound) {
            break;
        }
        
        if ([username hasPrefix:@"@"]) {
            break;
        }
        
        if ([username hasSuffix:@"."]) {
            break;
        }
        
        range = [username rangeOfString:@"@"];
        NSString *stringAfter = [username
                                 substringFromIndex:range.location+range.length];
        NSString *stringBefore = [username substringToIndex:range.location];
        
        range = [stringAfter rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [stringBefore rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [stringAfter rangeOfString:@"."];
        if (range.location == NSNotFound) {
            break;
        }
        
        legal = YES;
    } while (NO);
    
    return legal;
}


//box1 31 125 258 51
//176
//227
//278
//
//textfield 43 136 232 30
//187
//238
//289
//
//
//button 31 371 258 40

-(void)didTapAnywhere:(UITapGestureRecognizer *) recognizer
{
    [self.emailTextFeild resignFirstResponder];
    [self.confirmEmailTextFeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
    [self.confirmPasswordTextFeild resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    [self.view addGestureRecognizer:tapRecognizer];
    [UIView animateWithDuration:0.5 animations:^(void){
        self.boxView1.frame = CGRectMake(31, 125-OFFSET, 258, 51);
        self.boxView2.frame = CGRectMake(31, 176-OFFSET, 258, 51);
        self.boxView3.frame = CGRectMake(31, 227-OFFSET, 258, 51);
        self.boxView4.frame = CGRectMake(31, 278-OFFSET, 258, 51);
        
        self.emailTextFeild.frame           = CGRectMake(43, 136-OFFSET, 232, 30);
        self.confirmEmailTextFeild.frame    = CGRectMake(43, 187-OFFSET, 232, 30);
        self.passwordTextFeild.frame        = CGRectMake(43, 238-OFFSET, 232, 30);
        self.confirmPasswordTextFeild.frame = CGRectMake(43, 289-OFFSET, 232, 30);
        
        self.emailUnMatch.frame = CGRectMake(295, 194-OFFSET, 18, 17);
        self.passwordUnMatch.frame = CGRectMake(295, 295-OFFSET, 18, 17);
        
        self.signUpBtn.frame = CGRectMake(31, 371-BUTTON_OFFSET, 258, 40);
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    [self.view removeGestureRecognizer:tapRecognizer];
    [UIView animateWithDuration:0.5 animations:^(void){
        self.boxView1.frame = CGRectMake(31, 125, 258, 51);
        self.boxView2.frame = CGRectMake(31, 176, 258, 51);
        self.boxView3.frame = CGRectMake(31, 227, 258, 51);
        self.boxView4.frame = CGRectMake(31, 278, 258, 51);
        
        self.emailTextFeild.frame = CGRectMake(43, 136, 232, 30);
        self.confirmEmailTextFeild.frame = CGRectMake(43, 187, 232, 30);
        self.passwordTextFeild.frame = CGRectMake(43, 238, 232, 30);
        self.confirmPasswordTextFeild.frame = CGRectMake(43, 289, 232, 30);
        
        self.emailUnMatch.frame = CGRectMake(295, 194, 18, 17);
        self.passwordUnMatch.frame = CGRectMake(295, 295, 18, 17);
        
        self.signUpBtn.frame = CGRectMake(31, 371, 258, 40);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)signUpButtonPressed
{
    
    NSString *username = [self.emailTextFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *usernametwo = [self.confirmEmailTextFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordTextFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passwordTwo = [self.confirmPasswordTextFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if ([self isUsernameLegal:username]&&![username isEqualToString:usernametwo]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text168", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
//        [alert show];
        
        self.emailUnMatch.hidden = NO;
        
        return;
    }else{
        self.emailUnMatch.hidden = YES;
    }
    
    if (password.length<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text65", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![password isEqualToString:passwordTwo]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码不一致" delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
//        [alert show];
        self.passwordUnMatch.hidden = NO;
        return;
    }else{
        self.passwordUnMatch.hidden = YES;
    }
    
//    if (agreeButton_.selected) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text167", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    NSLog(@"signUpButtonPressed");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBRegister:username Password:password];
}

-(void)OnResultRegisterSuccess:(NSNotification*)result
{
    NSLog(@"OnResultRegisterSuccess");
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text145", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
    alert.tag = 1;
    alert.delegate = self;
    [alert show];
        
   
}

-(void)OnResultRegisterFailed
{
    NSLog(@"OnResultRegisterFailed");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text144", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
    [alert show];
        

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.delegate updateUsername:self.emailTextFeild.text];

}

- (void)backButtonAction {
    [self.emailTextFeild resignFirstResponder];
    [self.confirmEmailTextFeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
    [self.confirmPasswordTextFeild resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
