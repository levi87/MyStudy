//
//  NewContactViewController.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NewContactViewController.h"

@interface NewContactViewController ()

@end

@implementation NewContactViewController

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
    tittleLabel.text = @"Contacts";
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    UIView *tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    //    UIButton *newConversationButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 50, 20)];
    //    newConversationButton.titleLabel.text = @" + ";
    //    newConversationButton.backgroundColor = [UIColor whiteColor];
    //    [newConversationButton addTarget:self action:@selector(createNewConversation) forControlEvents:UIControlEventTouchUpInside];
    //    [tittleView addSubview:newConversationButton];
    [self.view addSubview:tittleView];
    [self.view addSubview:tittleLineView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 480)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.backgroundColor = [UIColor clearColor];

    [searchBar setTintColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    [_tableView setTableHeaderView:searchBar];

    
    [self.view addSubview:_tableView];
   
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil;
    if (section>=1) {
        sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 21)];
        sectionHeaderView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        UILabel *sectionHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 150, 17)];
        sectionHeaderTitle.text = @"Freebao users";
        sectionHeaderTitle.textColor = [UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1];
        sectionHeaderTitle.backgroundColor = [UIColor clearColor];
        [sectionHeaderView addSubview:sectionHeaderTitle];
    }
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section>=1) {
        return 21;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 0) {
    //        static NSString *CellIdentifier = @"NoticesCell";
    //        ContactsNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //        if (cell == nil) {
    //            cell = [[ContactsNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //        }
    //        if (indexPath.row == 0) {
    //            cell.typeLabel.text = @"Notices";
    //        } else if (indexPath.row == 1) {
    //            cell.typeLabel.text = @"@Me";
    //        } else if (indexPath.row == 2) {
    //            cell.typeLabel.text = @"Comments";
    //        }
    //        return cell;
    //    }
    
    
    static NSString *CellIdentifier = @"Cell";
    ContactCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setType:@"Notices"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_notice_normal.png"]];
            [cell setDetail:@"Michael took a photo"];
            [cell setRightImage:[UIImage imageNamed:@"bg_contacts_boy.png"]];
            [cell setNum:@"2"];
        }else if(indexPath.row == 1){
            [cell setType:@"@Me"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_atme_normal.png"]];
            [cell setDetail:@"Michael in your release status @ you"];
        }else{
            [cell setType:@"Comments"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_comment_normal.png"]];
            [cell setDetail:@"Michael commented on you"];
        }
    }
    
    

    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
