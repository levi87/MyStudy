//
//  LoginViewContrller.h
//  FreeBao
//
//  Created by ye bingwei on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource, UITabBarDelegate,UIScrollViewDelegate>
{
    BOOL            isLogingOut_;   // 如果是注销的操作
//    TencentOAuth* _tencentOAuth;   //QQapi
    NSMutableArray* _permissions;
    
    UITextField     *usernameTextField_;
    UITextField     *passwordTextField_;
    
    UITextField     *RegistusernameTextField_;
    UITextField     *RegistpasswordTextField_;
    
    UITextField     *ForgetpasswordTextField_;
    UITextField     *RegpasswordTextField_;
    
//    Task                *requestTimelineTask_;
    UIButton        *rememberPasswordButton_;
    UIButton        *autoLoginButton_;
    UIButton        *loginButton_;
    UIButton        *regirButton_;
    UIButton        *forgetButton_;
//  IBOutlet UIButton        *QQLoginButton_;
    UITableView     *tableView_;
    
    UIView          *login_view_;
    
    
    NSMutableArray *gridItems;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    UITapGestureRecognizer *singletap;
    UIImageView     *fbimage_;
    
    
    UIView          *BingdEmailView_;
    UITextField     *BindEmail_;
    UITextField     *BindPassword_;
    UITextField     *ConBingEmail_;
    UIButton        *BindButton_;
    
    NSMutableString *nickname;
    NSMutableString *avatar;
    NSMutableString *gender;
    NSMutableString *loginplatform1;
    
    NSString *nick_name_;
    NSString *avat_ar_;
    NSString *gend_er_;
    NSString *longinplat_form1_;
    
    UIImageView *loginViewBac_;
    UIButton *makeFaceUpButton_;
    UIButton *agreeButton_;
    
    UIView   *firstShowImageView_;
    UIButton *starFreebaoButton_;
    
    UIImageView *imgeView1_;
    UIImageView *imgeView2_;
    UIImageView *imgeView3_;
    UIImageView *imgeView4_;
    UIImageView *imgeView5_;
    WeiBoMessageManager *manager;
    
}
@property(nonatomic, retain) IBOutlet UIImageView *imgeView1;
@property(nonatomic, retain) IBOutlet UIImageView *imgeView2;
@property(nonatomic, retain) IBOutlet UIImageView *imgeView3;
@property(nonatomic, retain) IBOutlet UIImageView *imgeView4;
@property(nonatomic, retain) IBOutlet UIImageView *imgeView5;


@property(nonatomic, retain) IBOutlet UIButton *starFreebaoButton;
@property (nonatomic, retain) IBOutlet UIScrollView *firetscrrollView;
@property(nonatomic, retain) IBOutlet UIView *firstShowImageView;
@property(nonatomic, retain) IBOutlet UIButton *agreeButton;
@property(nonatomic, retain) IBOutlet UIButton *makeFaceUpbutton;
@property(nonatomic, retain)IBOutlet UIImageView *loginViewBac;
@property(nonatomic, retain) NSString *nick_name_;
@property(nonatomic, retain) NSString *avat_ar_;
@property(nonatomic, retain) NSString *gend_er_;
@property(nonatomic, retain) NSString *longinplat_form1_;


@property(nonatomic, retain) NSMutableString    *nickname;
@property(nonatomic, retain) NSMutableString    *avatar;
@property(nonatomic, retain) NSMutableString    *gender;
@property(nonatomic, retain) NSMutableString    *loginplatform1;

@property(nonatomic, retain) IBOutlet UITextField     *BindPassword;
@property(nonatomic, retain) IBOutlet UITextField     *BindEmail;
@property(nonatomic, retain) IBOutlet UITextField     *ConBingEmail;
@property(nonatomic, retain) IBOutlet UIButton        *bindButton;
@property(nonatomic, retain) IBOutlet UIView *BingdEmailView;

@property(nonatomic, retain) IBOutlet UIButton *forgetButton;
@property(nonatomic, retain) IBOutlet UIButton *regirButton;
@property (nonatomic, retain) IBOutlet UIImageView *backgoundImage;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UIImageView *fbimage;
@property(nonatomic, assign) BOOL isLogingOut;
@property(nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property(nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property(nonatomic, retain) IBOutlet UITextField *RegistusernameTextField;
@property(nonatomic, retain) IBOutlet UITextField *RegistpasswordTextField;
@property(nonatomic, retain) IBOutlet UITextField *ForgetpasswordTextField;
@property(nonatomic, retain) IBOutlet UITextField *RegpasswordTextField;

@property(nonatomic, retain) IBOutlet UIButton *rememberPasswordButton;
@property(nonatomic, retain) IBOutlet UIButton *autoLoginButton;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
//@property(nonatomic, retain) IBOutlet UIButton  *QQLoginButton_;
@property(nonatomic, retain) IBOutlet UIButton  *loginButton;
@property(nonatomic, retain) IBOutlet UIView  *login_view;
@property ( nonatomic, retain) IBOutlet UIPageControl *pagecontrol;
- (IBAction)loginButtonPressed;
- (IBAction)registerButtonPressed;
//- (IBAction)QQLoginButton;
- (IBAction)rememberPasswordButtonPressed;
- (IBAction)autoLoginButtonPressed;
- (void)tencentDidNotNetWork;
- (IBAction)makefaceUpButtonPressed;
- (IBAction)makefaceDownButtonPressed;
-(IBAction)clearKeyBorad;

- (IBAction)chagepage:(id)sender;
-(IBAction)findMusic;
-(IBAction)Checkaround;
-(IBAction)hotUser;
-(IBAction)aboutFb;
-(IBAction)picCheck;
-(IBAction)hotstatus;
-(IBAction)Voicearound;
-(IBAction)FbGrils;

- (IBAction)RegistButtonPressed;
- (IBAction)ForgotButtonPressed;
-(IBAction)makeKeyBordDownPressed;


-(IBAction)upRegface;

-(IBAction)upForface;
-(IBAction)clearKeyBorad2;
-(IBAction)BindButtonPressed;
-(IBAction)agreeButtonPressed;
-(IBAction)StarFreebaoButtonPressed;
@end
