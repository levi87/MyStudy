//
//  NewLoginViewController.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-7.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NewLoginViewController.h"
#import "AppDelegate.h"
#import "NewRegisterViewController.h"

#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface NewLoginViewController ()

@end

@implementation NewLoginViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultLoginSuccess:) name:FB_NOTIC_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultLoginFailed) name:FB_NOTIC_LOGIN_FAILED object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
    UITapGestureRecognizer *registerTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnRegister:)];
    
    self.navigationController.navigationBar.hidden = YES;
    self.passwordField.secureTextEntry = YES;
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    //test  //
    self.emailField.text = @"truth273@163.com";
    self.passwordField.text = @"xxl04024754";
    ///
    
    [self.registerLabel addGestureRecognizer:registerTapRecognizer];
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_normal.png"] forState:UIControlStateNormal];
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_preesed.png"] forState:UIControlStateSelected];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    
    // Do any additional setup after loading the view from its nib.
}

-(void)keyboardWillShow:(NSNotification *)note
{
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didTapAnywhere:(UITapGestureRecognizer *) recognizer
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

-(void)didTapOnRegister:(UITapGestureRecognizer *) recognizer
{
    NSLog(@"didTapOnRegister");
    
    NewRegisterViewController *registerVC = [[NewRegisterViewController alloc]init];
    
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)loginButtonPressed
{
    NSLog(@"loginButtonPressed");
    
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *username = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordField.text;
    
    if ([username length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text64", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if ([password length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text65", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBLogin:username Password:password Token:@""];
    NSString *isAutoLogin = @"0";
    NSString *isRemember = @"0";
//    if (autoLoginButton_.selected) {
//        isAutoLogin = @"1";
//    } else {
//        isAutoLogin = @"0";
//    }
//    if (rememberPasswordButton_.selected) {
//        [[NSUserDefaults standardUserDefaults] setObject:password forKey:FB_USER_PASSWORD];
//        isRemember = @"1";
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FB_USER_PASSWORD];
//        isRemember = @"0";
//    }
    [[NSUserDefaults standardUserDefaults] setObject:isAutoLogin forKey:FB_AUTOLOGIN];
    [[NSUserDefaults standardUserDefaults] setObject:isRemember forKey:FB_REMEMBER];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:FB_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)OnResultLoginSuccess:(NSNotification*)result {
    //    NSMutableDictionary *tmp = [result object];
    //    NSString *passId = [tmp objectForKey:@"passId"];
    //    NSString *passwordKey = [tmp objectForKey:@"passwordKey"];
    //    NSString *usrId = [tmp objectForKey:@"userId"];
    [KAppDelegate connect];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnResultLoginFailed {
    NSLog(@"[xxl] failed alert...");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Login Faild" delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
    [alert show];
}

@end
