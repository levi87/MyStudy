//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarViewController.h"
#import "tabbarView.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat orginHeight = self.view.frame.size.height- 45.5;
    if (iPhone5) {
        orginHeight = self.view.frame.size.height- 45.5 + addHeight;
    }
    NSLog(@"[levi] %f", self.view.frame.size.height);
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 45.5)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSelf) name:HIDE_TABBAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelf) name:SHOW_TABBAR object:nil];
}

- (void)hideSelf {
    [_tabbar setHidden:YES];
}

- (void)showSelf {
    [_tabbar setHidden:NO];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    

    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];

}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    HomeLineViewController *HomeVC = [[HomeLineViewController alloc] initWithNibName:@"HomeLineViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:HomeVC];
    [nav1.navigationBar setHidden:YES];
    
    ConversationViewController *ConvVC = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:ConvVC];
    [nav2.navigationBar setHidden:YES];
    
    MetionsStatusesVC *MesVC = [[MetionsStatusesVC alloc] initWithNibName:@"HomeLineViewController" bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:MesVC];
    nav3.navigationBar.tintColor = [UIColor blackColor];
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", nav1, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", nav2, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", nav3, @"viewController",@"主页",@"title", nil],nil];
    return tabBarItems;
    
}

@end
