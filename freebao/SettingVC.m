//
//  SettingVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "SettingVC.h"
#import "WeiBoMessageManager.h"
#import "User.h"
#import "ZJTHotRepostViewController.h"
#import "AboutViewController.h"
#import "MetionsStatusesVC.h"
#import "CoreDataManager.h"
#import "HotTrendsVC.h"

#define kAccountCount 6
#define kSettingCount 3
#define kLoginOutCount 1
//sections
enum{
    kAccountSection = 0,
    kStatusSection,
    kSectionsCount,
    kSectionsSize,
};

//rows

//status
enum{
    kHotStatus = 0,
    kHotRetwitted,
    kHotTrends,
//    kMetionsStatuses,
};

//kAccountSection
enum {
    kCurrentUser = 0,
    kRecUser,
    kInvUser,
    kCircle,
    kSearch,
    kCleanCache,
};

//kLogin
enum {
    kLogin = 0,
};

@interface SettingVC ()

@end

@implementation SettingVC

-(void)dealloc
{  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *TittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [TittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"More";
    tittleLabel.textColor = [UIColor whiteColor];
    [TittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 7, 12)];
    backButton.titleLabel.text = @"Back";
    backButton.titleLabel.textColor = [UIColor blackColor];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    [backButton addSubview:imgV];
    UIView *TittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [TittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:TittleView];
    [self.navigationController.view addSubview:TittleLineView];
    [self.navigationController.view addSubview:backButton];
    backButton.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kStatusSection) {
        return kSettingCount;
    }
    else if (section == kAccountSection) {
        return kAccountCount;
    } else if (section == kSectionsCount) {
        return kLoginOutCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    cell.image = [UIImage imageNamed:@"profile_icon"];
    return cell;
}

-(void)logout
{
//    OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
//    webV.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webV animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kAccountSection ) {
        if (row == kCurrentUser) {
            
        }
        
//        else if (row == kChangeAccount) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要更换账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更换", nil];
//            alert.tag = 0;
//            [alert show];
//        }
        
        else if (row == kCleanCache) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
            alert.tag = 1;
            [alert show];
        }
        
//        else if (row == kAboutMe) {
//            AboutViewController *a = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
//            a.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:a animated:YES];
//        }
    }
    
    else if (section == kStatusSection) {
        if (row == kHotStatus) {        
//            ZJTHotRepostViewController *h = [[ZJTHotRepostViewController alloc] initWithType:kHotCommentDaily];
//            h.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:h animated:YES];
        }
        
        else if (row == kHotRetwitted) {
//            ZJTHotRepostViewController *h = [[ZJTHotRepostViewController alloc] initWithType:kHotRepostDaily];
//            h.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:h animated:YES];
        }
        
        else if (row == kHotTrends) {
//            HotTrendsVC *h = [[HotTrendsVC alloc] initWithStyle:UITableViewStylePlain];
//            h.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:h animated:YES];
        }
        
//        else if (row == kMetionsStatuses) {
//            MetionsStatusesVC *m = [[MetionsStatusesVC alloc]initWithNibName:@"FirstViewController" bundle:nil];
//            m.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:m animated:YES];
//            [m release];
//        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self logout];
        }
    }
    
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1) {
            [[CoreDataManager getInstance]cleanEntityRecords:@"Images"];
            [[CoreDataManager getInstance]cleanEntityRecords:@"UserCDItem"];
            [[CoreDataManager getInstance]cleanEntityRecords:@"StatusCDItem"];
        }
    }

}
@end
