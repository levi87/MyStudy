//
//  MoreViewController.m
//  freebao
//
//  Created by freebao on 13-7-11.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "MoreViewController.h"

#define FONT @"HelveticaNeue"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"More";
    [tittleLabel setFont:[UIFont fontWithName:FONT size:15]];
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 30, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    [backButton addSubview:imgV];
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    [self.navigationController.view addSubview:backButton];
    backButton.hidden = YES;
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
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setButtonHide:YES];
    if (row == 0 || row == 12 || row == 13) {
        [cell setAccessoryViewHide:YES];
        cell.imageView.image = nil;
        cell.textLabel.text = @"";
    } else {
        [cell setAccessoryViewHide:NO];
    }
    if (row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_page.png"];
        cell.textLabel.text = @"My Page";
    } else if (row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_profile.png"];
        cell.textLabel.text = @"My Profile";
    } else if (row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_cities.png"];
        cell.textLabel.text = @"My Cities";
    } else if (row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_people.png"];
        cell.textLabel.text = @"People you may know";
    } else if (row == 5) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_search.png"];
        cell.textLabel.text = @"Search";
    } else if (row == 6) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_circles.png"];
        cell.textLabel.text = @"Circles";
    } else if (row == 7) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_invitation.png"];
        cell.textLabel.text = @"Friends Invitation";
    } else if (row == 8) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_language.png"];
        cell.textLabel.text = @"Language Setting";
    } else if (row == 9) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_feedback.png"];
        cell.textLabel.text = @"Feedback";
    } else if (row == 10) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_about.png"];
        cell.textLabel.text = @"About";
    } else if (row == 11) {
        cell.imageView.image = [UIImage imageNamed:@"icon_more_setting.png"];
        cell.textLabel.text = @"Setting";
    } else if (row == 12) {
        [cell setButtonHide:NO];
    }
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 44;
    } else if (row == 12) {
        return 84;
    } else if (row == 13) {
        return 44;
    } else {
        return 48;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    tittleView.hidden = NO;
    tittleLineView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR object:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        PageViewController *proVC = [[PageViewController alloc] init];
        [self.navigationController pushViewController:proVC animated:YES];
    } else if (indexPath.row == 2) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        ProfileViewController *proVC = [[ProfileViewController alloc] init];
        [self.navigationController pushViewController:proVC animated:YES];
    } else if (indexPath.row == 3) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        CitiesViewController *myCityVC = [[CitiesViewController alloc] init];
        [self.navigationController pushViewController:myCityVC animated:YES];
    } else if (indexPath.row == 4) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        PeopleUMayKnowViewController *pumkVC = [[PeopleUMayKnowViewController alloc] init];
        [self.navigationController pushViewController:pumkVC animated:YES];
    } else if (indexPath.row == 5) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    } else if (indexPath.row == 9) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.row == 10) {
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

@end
