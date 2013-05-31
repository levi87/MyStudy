//
//  LoginViewContrller.m
//  FreeBao
//
//  Created by ye bingwei on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

#define columns 2
#define rows 3
#define itemsPerPage 6
#define space 20
#define gridHight 100
#define gridWith 100
#define unValidIndex  -1
#define threshold 30


@interface LoginViewController(private)
-(NSInteger)indexOfLocation:(CGPoint)location;
-(CGPoint)orginPointOfIndex:(NSInteger)index;
-(void) exchangeItem:(NSInteger)oldIndex withposition:(NSInteger) newIndex;
@end

@implementation LoginViewController

@synthesize loginButton =loginButton_;
@synthesize isLogingOut = isLogingOut_;
@synthesize usernameTextField = usernameTextField_;
@synthesize passwordTextField = passwordTextField_;
@synthesize rememberPasswordButton = rememberPasswordButton_;
@synthesize autoLoginButton = autoLoginButton_;
@synthesize tableView = tableView_;
//@synthesize QQLoginButton_;
@synthesize login_view = login_view_;
@synthesize backgoundImage;
@synthesize scrollview;
@synthesize fbimage = fbimage_;
@synthesize pagecontrol;
@synthesize RegistpasswordTextField = RegistpasswordTextField_;
@synthesize RegistusernameTextField = RegistusernameTextField_;
@synthesize ForgetpasswordTextField = ForgetpasswordTextField_;
@synthesize RegpasswordTextField = RegpasswordTextField_;
@synthesize regirButton = regirButton_;
@synthesize forgetButton = forgetButton_;
@synthesize BingdEmailView =BingdEmailView_;
@synthesize BindEmail = BindEmail_;
@synthesize ConBingEmail = ConBingEmail_;
@synthesize bindButton = BindButton_;
@synthesize BindPassword = BindPassword_;
@synthesize nickname ;
@synthesize avatar;
@synthesize gender;
@synthesize loginplatform1;

@synthesize nick_name_;
@synthesize avat_ar_;
@synthesize gend_er_;
@synthesize longinplat_form1_;
@synthesize loginViewBac =loginViewBac_;
@synthesize makeFaceUpbutton = makeFaceUpButton_;
@synthesize agreeButton = agreeButton_;
@synthesize firstShowImageView = firstShowImageView_;
@synthesize firetscrrollView;
@synthesize starFreebaoButton = starFreebaoButton_;
@synthesize imgeView1 = imgeView1_;
@synthesize imgeView2 = imgeView2_;
@synthesize imgeView3 = imgeView3_;
@synthesize imgeView4 = imgeView4_;
@synthesize imgeView5 = imgeView5_;


#pragma mark - Private Methods

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
- (void)setField:(NSString *)field forKey:(NSString *)key
{
    if (field != nil) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

#pragma mark - IBActions~

- (IBAction)loginButtonPressed
{
    [usernameTextField_ resignFirstResponder];
    [passwordTextField_ resignFirstResponder];
    
    NSString *username = [usernameTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = passwordTextField_.text;
    
    if ([username length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text64", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;   
    }
    
    if ([password length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text65", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBLogin:username Password:password Token:@""];
    NSString *isAutoLogin = @"0";
    NSString *isRemember = @"0";
    if (autoLoginButton_.selected) {
        isAutoLogin = @"1";
    } else {
        isAutoLogin = @"0";
    }
    if (rememberPasswordButton_.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:FB_USER_PASSWORD];
        isRemember = @"1";
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:FB_USER_PASSWORD];
        isRemember = @"0";
    }
    [[NSUserDefaults standardUserDefaults] setObject:isAutoLogin forKey:FB_AUTOLOGIN];
    [[NSUserDefaults standardUserDefaults] setObject:isRemember forKey:FB_REMEMBER];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:FB_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)RegistButtonPressed{
    NSString *username = [RegistusernameTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *usernametwo = [RegistpasswordTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }

    if ([self isUsernameLegal:username]&&![username isEqualToString:usernametwo]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text168", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (RegpasswordTextField_.text.length<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text65", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (agreeButton_.selected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ui_text167", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
}

-(IBAction)BindButtonPressed{
    NSString *username = [BindEmail_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *usernametwo = [ConBingEmail_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if ([self isUsernameLegal:username]&&![username isEqualToString:usernametwo]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"两次输入不一样" delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (BindPassword_.text.length<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空" delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (IBAction)ForgotButtonPressed{
    NSString *username = [ForgetpasswordTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![self isUsernameLegal:username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"illegal_username", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_dialog_ok", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
}

-(IBAction)makeKeyBordDownPressed{
    NSLog(@"11111111111");
    [RegistusernameTextField_ resignFirstResponder];
    [RegistpasswordTextField_ resignFirstResponder];
    [ForgetpasswordTextField_ resignFirstResponder];
    
}
- (IBAction)registerButtonPressed
{
    
}

- (IBAction)rememberPasswordButtonPressed
{
    [rememberPasswordButton_ setSelected:!rememberPasswordButton_.selected];
}

- (IBAction)autoLoginButtonPressed
{
    [autoLoginButton_ setSelected:!autoLoginButton_.selected];
}

-(IBAction)agreeButtonPressed{
    
    [agreeButton_ setSelected:!agreeButton_.selected];
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

-(IBAction)findMusic{
}


-(IBAction)Checkaround{
    
}

-(IBAction)Voicearound{
    
}

-(IBAction)hotUser{
    
}

-(IBAction)FbGrils{
    
}

-(IBAction)aboutFb{
    
}

-(IBAction)picCheck{
    
}

-(IBAction)hotstatus{
    
}
#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    [cell.textLabel setTextColor:[UIColor colorWithRGB:0x1D72C2 alpha:1.f]];
    
    NSString *text = nil;
    if (indexPath.row == 0)
    {
        //text = @"随便看看";
        text = NSLocalizedString(@"ui_text2", @"");
    }
    else if (indexPath.row == 1)
    {
        //text = @"人气用户";
        text = NSLocalizedString(@"ui_text4", @"");
    }
    else
    {
        //text = @"热门转发";
        text = NSLocalizedString(@"ui_text1", "");
    }
    [cell.textLabel setText:text];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) // 随便看看
    {
//        RandomViewController *randomVC = [[RandomViewController alloc] initWithNibName:@"RandomViewController" bundle:nil];
//        [self.navigationController pushViewController:randomVC animated:YES];
    }
    else if (indexPath.row == 1)  // 人气用户
    {
//        StarsViewController *starsVC = [[StarsViewController alloc] initWithNibName:@"StarsViewController" bundle:nil];
//        [self.navigationController pushViewController:starsVC animated:YES];
    }
    else    // 热门转发
    {
//        HotStatusesViewController *hotStatusesVC = [[HotStatusesViewController alloc] initWithNibName:@"HotStatusesViewController" bundle:nil];
//        [self.navigationController pushViewController:hotStatusesVC animated:YES];
    }
}

#pragma mark - View lifecycle
- (IBAction)makefaceUpButtonPressed{
    
    [UIView animateWithDuration:0.3 //速度0.7秒
                     animations:^{//修改rView坐标
                         login_view_.frame = CGRectMake(self.view.frame.origin.x,
                                                  -self.view.frame.size.height-30,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    

}

-(IBAction)upRegface{
    
    [UIView animateWithDuration:0.3 //速度0.7秒
                     animations:^{//修改rView坐标
                         login_view_.frame = CGRectMake(self.view.frame.origin.x,
                                                        -self.view.frame.size.height-30,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

    [scrollview setContentOffset:CGPointMake(320.f, 0.f)];
//    scrollview.contentOffset.x = scrollview.frame.size.width/3;
}

-(IBAction)upForface{
    
    [UIView animateWithDuration:0.3 //速度0.7秒
                     animations:^{//修改rView坐标
                         login_view_.frame = CGRectMake(self.view.frame.origin.x,
                                                        -self.view.frame.size.height-30,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

     [scrollview setContentOffset:CGPointMake(640.f, 0.f)];
}

- (IBAction)makefaceDownButtonPressed{
    
    
    [UIView animateWithDuration:0.3 //速度0.7秒
                     animations:^{//修改rView坐标
                         login_view_.frame = CGRectMake([[UIScreen mainScreen] bounds].origin.x,
                                                        [[UIScreen mainScreen] bounds].origin.y,
                                                        
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}

- (void)OnResultLoginSuccess {
    NSLog(@"[levi] success disappear...");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnResultLoginFailed {
    NSLog(@"[levi] failed alert...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultLoginSuccess) name:FB_NOTIC_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnResultLoginFailed) name:FB_NOTIC_LOGIN_FAILED object:nil];
    
    if (FALSE) {
        [loginViewBac_ setFrame:CGRectMake(0, 0, 320, 568)];
        [loginViewBac_ setImage:[UIImage imageNamed:@"iphone5_LoginFace.png"]];
        
        [makeFaceUpButton_ setFrame:CGRectMake(260, 500, 30, 30)];
        [scrollview setFrame:CGRectMake(0, 0, 320, 568)];
        [backgoundImage setFrame:CGRectMake(0, 0, 480, 568)];
        
        [pagecontrol setFrame:CGRectMake(120, 500, 70, 36)];
    }
    
    if (FALSE) {
        [firstShowImageView_ setFrame:CGRectMake(0, 0, 320, 548)];
        [firetscrrollView setFrame:CGRectMake(0, 0, firetscrrollView.frame.size.width, 548)];
        [imgeView1_ setImage:[UIImage imageNamed:@"iphonePage1.png"]];
        [imgeView1_ setFrame:CGRectMake(0, 0, 320, 548)];
        
        [imgeView2_ setImage:[UIImage imageNamed:@"iphonePage2.png"]];
        [imgeView2_ setFrame:CGRectMake(320,0 , 320, 548)];
        
        [imgeView3_ setImage:[UIImage imageNamed:@"iphonePage3.png"]];
        [imgeView3_ setFrame:CGRectMake(640, 0, 320, 548)];
        
        [imgeView4_ setImage:[UIImage imageNamed:@"iphonePage4.png"]];
        [imgeView4_ setFrame:CGRectMake(960, 0, 320, 548)];
        
        [imgeView5_ setImage:[UIImage imageNamed:@"iphonePage5.png"]];
        [imgeView5_ setFrame:CGRectMake(1280,0 , 320, 548)];
        
        [starFreebaoButton_ setFrame:CGRectMake(starFreebaoButton_.frame.origin.x, starFreebaoButton_.frame.origin.y+12, starFreebaoButton_.frame.size.width, starFreebaoButton_.frame.size.height)];
        
              
    }
    
    [self.view addSubview:login_view_];


//    [self.view addSubview:firstShowImageView_]; 
    [self.view addSubview:BingdEmailView_];
    
    BingdEmailView_.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    [self.loginButton setTitleColor:[UIColor colorWithRed:145/255.f green:76/255.f blue:0.f alpha:1.f] forState:UIControlStateNormal];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nagvigation.png"] forBarMetrics:UIBarMetricsDefault];
    }

    [self.navigationItem setTitle:@"FreeBao"];
    usernameTextField_.placeholder=@"email";
    
    [tableView_ setBackgroundView:nil];
    [tableView_ setOpaque:NO];
    [tableView_ setBackgroundColor:[UIColor clearColor]];
    
    // 根据是否自动登录，和记住密码设置按钮状态
//    [autoLoginButton_ setSelected:[[DataEngine sharedInstance] autoLoginEnabled]];
//    [rememberPasswordButton_ setSelected:[[DataEngine sharedInstance] rememberPasswordEnabled]];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QQLogin) name:@"QQLoginsucess" object:nil];
    
    //[QQLoginButton_ setTitleColor:[UIColor colorWithRed:145/255.f green:76/255.f blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [loginButton_ setTitleColor:[UIColor colorWithRed:145/255.f green:76/255.f blue:0.f alpha:1.f] forState:UIControlStateNormal]; 
    [regirButton_ setTitleColor:[UIColor colorWithRed:145/255.f green:76/255.f blue:0.f alpha:1.f] forState:UIControlStateNormal]; 
    [forgetButton_ setTitleColor:[UIColor colorWithRed:145/255.f green:76/255.f blue:0.f alpha:1.f] forState:UIControlStateNormal]; 
    
    UISwipeGestureRecognizer *rezaker;
    
    rezaker = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
//    rezaker = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [rezaker setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:rezaker];
    
//    rezaker = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rezaker setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:rezaker];
    
    //Modify
    UIGestureRecognizer* pan_recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
    [login_view_ addGestureRecognizer:pan_recognizer];
//    pan_recognizer.delegate =self;

    
    scrollview.delegate = self;
    [scrollview setPagingEnabled:YES];


    
    firetscrrollView.delegate = self;
    [firetscrrollView setPagingEnabled:YES];
    firetscrrollView.showsHorizontalScrollIndicator = NO;
    firetscrrollView.showsVerticalScrollIndicator = NO;
    
    [firetscrrollView setContentSize:CGSizeMake(scrollview.frame.size.width * 5, 480)];
    
    
    
    [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width * 3, scrollview.frame.size.height)];
    
//    [self onLoginResult11];
    usernameTextField_.text = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_NAME];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FB_AUTOLOGIN] integerValue] == 0) {
        [autoLoginButton_ setSelected:FALSE];
    } else {
        [autoLoginButton_ setSelected:TRUE];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FB_REMEMBER] integerValue] == 0) {
        [rememberPasswordButton_ setSelected:FALSE];
    } else {
        [rememberPasswordButton_ setSelected:TRUE];
        passwordTextField_.text = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_PASSWORD];
    }

}
- (void)performPanGesture:(UIPanGestureRecognizer *)recognizer{
    
    if (recognizer.state ==UIGestureRecognizerStateChanged ){
        
        CGPoint point = [recognizer translationInView:login_view_];
        
        login_view_.layer.position = CGPointMake(160, point.y+180);
        
        if (login_view_.frame.origin.y>=0) {
            login_view_.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        
    }
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        if (login_view_.frame.origin.y>-self.view.frame.size.height/2) {
            
            [UIView animateWithDuration:0.3 //速度0.7秒
                             animations:^{//修改rView坐标
                                 login_view_.frame = CGRectMake(0,
                                                                0,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height);
                                 
                             }
                             completion:^(BOOL finished){
                             }];
                    }
        else{
            [UIView animateWithDuration:0.3 //速度0.7秒
                             animations:^{//修改rView坐标
                                 login_view_.frame = CGRectMake(self.view.frame.origin.x,
                                                                -self.view.frame.size.height-30,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height);

                             }
                             completion:^(BOOL finished){
                             }];

                   }
    }
    
    
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == firetscrrollView) {
        NSLog(@"");
    }else{
        CGRect frame = self.backgoundImage.frame;
        frame.origin.x = preFrame.origin.x + (preX - scrollView.contentOffset.x)/7 ;
        if (frame.origin.x <= 0 && frame.origin.x > scrollView.frame.size.width - frame.size.width ) {
            self.backgoundImage.frame = frame;
            
        }
        CGFloat pageWidth = scrollView.frame.size.width;
        pagecontrol.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self fbimageMove:pagecontrol.currentPage];
        [fbimage_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"faceicon%d.png",pagecontrol.currentPage]]];

        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == firetscrrollView) {
        
    }else{
        preX = scrollView.contentOffset.x;
        preFrame = backgoundImage.frame;
    }
   
    NSLog(@"prex:%f",preX);
   
}

- (IBAction)chagepage:(id)sender {
//    int page = pagecontrol.currentPage;
//        index = page;
    //	
    //    CGRect frame = scrollImages.frame;
    //    frame.origin.x = frame.size.width * page;
    //    frame.origin.y = 0;
    //    [scrollImages scrollRectToVisible:frame animated:YES];
    //    
    //    pageControlUsed = YES;
    //    pf.frame = ((UIImageView*)[imageviews objectAtIndex:index]).frame;
    //    [pf setAlpha:0];
    //    [UIView animateWithDuration:0.2f animations:^(void){
    //        [pf setAlpha:.85f];
    //    }];
    
}
int a=0;
-(void )fbimageMove:(int)number{
    
    if (a != number) {
        a=number;
        [UIView beginAnimations:@"Curl444"context:nil];       
        [UIView setAnimationDuration:1.0];  
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:fbimage_ cache:YES];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];  
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        
        [UIView animateWithDuration:0.3 //速度0.7秒
                         animations:^{//修改rView坐标
                             login_view_.frame = CGRectMake([[UIScreen mainScreen] bounds].origin.x,
                                                       [[UIScreen mainScreen] bounds].origin.y,
                                                       
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [UIView animateWithDuration:0.3 //速度0.7秒
                         animations:^{//修改rView坐标
                             login_view_.frame = CGRectMake(self.view.frame.origin.x,
                                                            -self.view.frame.size.height-30,
                                                            self.view.frame.size.width,
                                                            self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}
-(IBAction)StarFreebaoButtonPressed{
    NSLog(@"点击  按钮  ");
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 0.5f * 1;
////    animation.timingFunction = UIViewAnimationCurveEaseInOut;
////	animation.fillMode = kCAFillModeForwards;
////	animation.endProgress = 1;
//	animation.removedOnCompletion = YES;
//	animation.timeOffset = 3.f;
//    animation.type = @"rippleEffect";//110
//	[firstShowImageView_  removeFromSuperview];
//	[self.view.layer addAnimation:animation forKey:@"animation"];
//    [[DataEngine sharedInstance] setISFirstTime:YES];
    [UIView animateWithDuration:0.3 //速度0.7秒
                     animations:^{//修改rView坐标
                         [firstShowImageView_ setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                     }];
	
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_NOTIC_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_NOTIC_LOGIN_FAILED object:nil];
}

-(IBAction)clearKeyBorad{
	[usernameTextField_ resignFirstResponder];
    [passwordTextField_ resignFirstResponder];
//    [BindPassword_ resignFirstResponder];
//    [BindPassword_ resignFirstResponder];
    
}
-(IBAction)clearKeyBorad2{
    [BindEmail_ resignFirstResponder];
    [ConBingEmail_ resignFirstResponder];
    [BindPassword_ resignFirstResponder];
    
}


- (void)dealloc
{
}

@end
