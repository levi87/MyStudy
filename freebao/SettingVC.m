//
//  SettingVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "SettingVC.h"
#import "OAuthWebView.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotUserInfo          object:nil];
    
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
    return kSectionsSize;
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
    NSInteger section = indexPath.section;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    if (section == kAccountSection) {
        if (row == kCurrentUser) {
//            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_NAME];
            cell.textLabel.text = @"我的资料";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (row == kRecUser) {
            cell.textLabel.text = @"推荐用户";
        }
        
        else if (row == kInvUser) {
            cell.textLabel.text = @"好友邀请";
        }
        
        else if (row == kCircle) {
            cell.textLabel.text = @"圈子";
        }
        
        else if (row == kSearch) {
            cell.textLabel.text = @"搜索";
        }
        else if (row == kCleanCache) {
            cell.textLabel.text = @"清空缓存";
        }
    }
    
    else if (section == kStatusSection) {
        if (row == kHotStatus) {
            cell.textLabel.text = @"意见反馈";
        }
        
        else if (row == kHotRetwitted) {
            cell.textLabel.text = @"关于";
        }
        
        else if (row == kHotTrends) {
            cell.textLabel.text = @"声音和震动设置";
        }
        
//        else if (row == kMetionsStatuses) {
//            cell.textLabel.text = @"@我";
//        }
    }
    
    else if (section == kSectionsCount) {
        if (row == kLogin) {
            cell.textLabel.text = @"注销";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.image = [UIImage imageNamed:@"profile_icon"];
    return cell;
}

-(void)logout
{
//    OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
//    webV.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webV animated:YES];
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    User *user = sender.object;
    [[NSUserDefaults standardUserDefaults] setObject:user.screenName forKey:USER_STORE_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSIndexPath *p = [NSIndexPath indexPathForRow:kCurrentUser inSection:kAccountSection];
    NSArray *arr = [NSArray arrayWithObject:p];
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
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
