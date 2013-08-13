//
//  CityUserViewController.m
//  freebao
//
//  Created by freebao on 13-8-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CityUserViewController.h"

@interface CityUserViewController ()

@end

@implementation CityUserViewController
@synthesize aCityName = _aCityName;
@synthesize isRefreshPeople = _isRefreshPeople;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidUnload {
    [self setCityUserTableView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_CITY_USERS object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitleBar];
    _isRefreshPeople = FALSE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultOfRequest:) name:FB_GET_CITY_USERS object:nil];
    peopleArray = [[NSMutableArray alloc] init];
    headPhotosPeople = [[NSMutableArray alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.cityUserTableView setTableHeaderView:headerView];
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBCityUsersWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] City:_aCityName Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)resultOfRequest:(NSNotification*)notification {
    NSMutableArray *tmpArray = notification.object;
    NSLog(@"tmpArray Array %@", tmpArray);
    NSLog(@"[levi] %@", [notification.userInfo objectForKey:@"maxCount"]);
    maxPage = [[notification.userInfo objectForKey:@"maxCount"] integerValue];
    if (currentPage == 0) {
        [peopleArray removeAllObjects];
        headPhotosPeople = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < [tmpArray count]; i ++) {
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        CityUserInfo *tmpInfo = [[CityUserInfo alloc] init];
        tmpInfo.userName = [tmpDic objectForKey:@"nickname"];
        tmpInfo.userId = [tmpDic objectForKey:@"userId"];
        tmpInfo.userFacePath = [tmpDic objectForKey:@"facePath"];
        [peopleArray addObject:tmpInfo];
        [headPhotosPeople addObject:[tmpDic objectForKey:@"facePath"]];
    }
    [self.cityUserTableView reloadData];
}

-(void)initTitleBar {
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = _aCityName;
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    //    UIButton *newConversationButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 50, 20)];
    //    newConversationButton.titleLabel.text = @" + ";
    //    newConversationButton.backgroundColor = [UIColor whiteColor];
    //    [newConversationButton addTarget:self action:@selector(createNewConversation) forControlEvents:UIControlEventTouchUpInside];
    //    [tittleView addSubview:newConversationButton];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,9, 51, 26)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back_normal"] forState:UIControlStateNormal];
    [tittleView addSubview:backButton];
    [self.view addSubview:tittleView];
    [self.view addSubview:tittleLineView];
}

-(void)viewWillAppear:(BOOL)animated {
    if (_isRefreshPeople) {
        NSLog(@"_aCityName %@", _aCityName);
        tittleLabel.text = _aCityName;
        [manager FBCityUsersWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] City:_aCityName Page:0 PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        _isRefreshPeople = FALSE;
    }
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [peopleArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CityUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CityUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCellValue:(CityUserInfo*)[peopleArray objectAtIndex:indexPath.row]];
    [cell setHeadPhoto:[headPhotosPeople objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y >= fmaxf(0.f, scrollView.contentSize.height - scrollView.frame.size.height) + 40.f) {
        NSLog(@"current page %d max page %d", maxPage, currentPage);
        if (currentPage + 1 >= maxPage) {
            return;
        }
        currentPage ++;
        if (manager == nil) {
            manager = [WeiBoMessageManager getInstance];
        }
        [manager FBCityUsersWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] City:_aCityName Page:currentPage PageSize:kDefaultRequestPageSize PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
        _isRefreshPeople = FALSE;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cityUserTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (commChatV == nil) {
        commChatV = [[ChatViewController alloc] init];
    } else {
        commChatV.isFirst = FALSE;
        commChatV.isReload = TRUE;
    }
    CityUserInfo *tmpInfo = [peopleArray objectAtIndex:indexPath.row];
    [commChatV setToUserId:tmpInfo.userId];
    [commChatV.tittleLabel setText:tmpInfo.userName];

    [self.navigationController pushViewController:commChatV animated:YES];
}

@end
