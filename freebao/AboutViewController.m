//
//  AboutViewController.m
//  freebao
//
//  Created by levi on 13-7-28.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "AboutViewController.h"
#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_login_4"]]];
    [self.aboutTableview setBackgroundColor:[UIColor clearColor]];
    itemsArray = [[NSMutableArray alloc] initWithObjects:@"Rate Freebao",@"User Guide",@"Check New Version", nil];
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tittleLabel.textAlignment = UITextAlignmentCenter;
    [_tittleLabel setBackgroundColor:[UIColor clearColor]];
    _tittleLabel.text = @"About";
    _tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: _tittleLabel];
    _tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,9, 51, 26)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back_normal"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    [self.navigationController.view addSubview:backButton];
}

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    tittleView.hidden = YES;
    tittleLineView.hidden = YES;
    backButton.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAboutTableview:nil];
    [super viewDidUnload];
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
    return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AboutCell alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    }
    cell.labelName.text = (NSString*)[itemsArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.aboutTableview deselectRowAtIndexPath:indexPath animated:YES];
}
@end
