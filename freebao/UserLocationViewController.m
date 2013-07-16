//
//  UserLocationViewController.m
//  freebao
//
//  Created by freebao on 13-7-16.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "UserLocationViewController.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface UserLocationViewController ()

@end

@implementation UserLocationViewController
@synthesize userLocationMap = _userLocationMap;
@synthesize userCoordinate = _userCoordinate;

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
    UIView *tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"User Location";
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 30, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    [backButton addSubview:imgV];
    UIView *tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.view addSubview:tittleLineView];
    [self.view addSubview:tittleView];
    [tittleView addSubview:backButton];

//    _userCoordinate.latitude = 30.2094;
//    _userCoordinate.longitude = 120.204;
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = _userCoordinate;
    [_userLocationMap addAnnotation:ann];
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    region.center = _userCoordinate;
    [_userLocationMap setRegion:region animated:YES];
    [_userLocationMap regionThatFits:region];
}

-(void)backButtonAction {
    NSArray *tmpArray = _userLocationMap.annotations;
    [_userLocationMap removeAnnotations:tmpArray];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
//    _userCoordinate.latitude = 30.2094;
//    _userCoordinate.longitude = 120.204;
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = _userCoordinate;
    [_userLocationMap addAnnotation:ann];
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    region.center = _userCoordinate;
    [_userLocationMap setRegion:region animated:YES];
    [_userLocationMap regionThatFits:region];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserLocationMap:nil];
    [super viewDidUnload];
}
@end
