//
//  NewNoticesViewController.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NewNoticesViewController.h"
#import "tabbarViewController.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface NewNoticesViewController ()

@end

@implementation NewNoticesViewController

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
    tittleLabel.text = @"Notices";
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    UIView *tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,0, 80, 44)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 16, 7, 12)];
    [backButton addSubview:imgV];
    
    [tittleView addSubview:backButton];
    [self.view addSubview:tittleView];
    [self.view addSubview:tittleLineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 568)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];

    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];

    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setName:@"Michael"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_notice_normal.png"]];
            [cell setDetail:@"Michael took a photo"];
            [cell setTime:@"16:30"];
        }else if(indexPath.row == 1){
            [cell setName:@"William"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_atme_normal.png"]];
            [cell setDetail:@"William took a photo"];
            [cell setTime:@"Yesterday"];
        }else{
            [cell setName:@"Jason"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_comment_normal.png"]];
            [cell setDetail:@"2013-8-8"];
            [cell setTime:@"0"];
        }
    }else{
//        [cell setTime:@"0"];
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@" section0  row0");
        }
    }
}

- (void)backButtonAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
