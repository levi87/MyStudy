//
//  ProfileViewController.m
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
#define  PIC_WIDTH 80
#define  PIC_HEIGHT 80
#define  INSETS 10

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    itemsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i++) {
        [itemsArray addObject:@""];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResultPersonInfo:) name:FB_GET_PERSON_INFO object:nil];
    [self.tableView setTableHeaderView:self.headerView];
    headImageView = [[EGOImageView alloc] init];
    headImageView.frame = CGRectMake(0, 0, 60, 60);
    [self.headViewButton addSubview:headImageView];
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _tittleLabel.textAlignment = UITextAlignmentCenter;
    [_tittleLabel setBackgroundColor:[UIColor clearColor]];
    _tittleLabel.text = @"Profile";
    _tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: _tittleLabel];
    _tittleLabel.center = CGPointMake(160, 22);
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(6,16, 80, 12)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    editButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 40, 44)];
    [editButton addTarget:self action:@selector(setEditMode) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton setBackgroundColor:[UIColor clearColor]];
    self.describeTextView.editable = NO;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDescribe)];
    tap1.numberOfTapsRequired = 1;
    [self.describeTextView addGestureRecognizer:tap1];
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-back.png"]];
    [imgV setFrame:CGRectMake(0, 0, 7, 12)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction)];
    tap.numberOfTapsRequired = 1;
    [imgV addGestureRecognizer:tap];
    [backButton addSubview:imgV];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];
    [self.navigationController.view addSubview:backButton];
    [tittleView addSubview:editButton];
    headImageArray = [[NSMutableArray alloc] init];
    [self refreshScrollView];
    commDialogView = [[OneLineDialogView alloc] init];
    [commDialogView setDelegate:self];

    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetPersonInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
//    [manager FBGetPersonPhotoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)editDescribe {
    commDialogView = [[OneLineDialogView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    commDialogView.tag = 20;
    commDialogView.oneLineText.placeholder = self.describeTextView.text;
    [commDialogView show];
    tmpTextField = commDialogView.oneLineText;
    [commDialogView.oneLineText becomeFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0:
        {
            //Name
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            //Sex
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            //Birthday
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            //Height
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            //Weight
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            //Blood Type
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 6:
        {
            //Constellation
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 7:
        {
            //Country
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 8:
        {
            //Occupation
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 9:
        {
            //Intersets
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 10:
        {
            //Countries Visited
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 11:
        {
            //Travelling Plans
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
        case 20:
        {
            //Travelling Plans
            switch (buttonIndex) {
                case 0:
                    NSLog(@"0");
                    break;
                case 1:
                    NSLog(@"1 %@", tmpTextField.text);
                    self.describeTextView.text = tmpTextField.text;
                    [self updatePerson:itemsArray];
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)updatePerson:(NSMutableArray*)itemArray {
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBUpdatePersonInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID] NickName:[itemsArray objectAtIndex:0] Biography:self.describeTextView.text City:[itemsArray objectAtIndex:7] Email:@"" Gender:[itemsArray objectAtIndex:1] Height:[itemsArray objectAtIndex:3] Weight:[itemsArray objectAtIndex:4] Birthday:[itemsArray objectAtIndex:2] BloodType:[itemsArray objectAtIndex:5] Profession:[itemsArray objectAtIndex:8] Tourism:[itemsArray objectAtIndex:11] Intersets:[itemsArray objectAtIndex:9] CountryVisited:[itemsArray objectAtIndex:10]];
}

-(void)onResultPersonInfo:(NSNotification*)notification {
    NSLog(@"result...person...info%@",notification.object);
    NSDictionary *tmpDic = notification.object;
    PersonInfo *personInfo = [[PersonInfo alloc] init];
    personInfo.age = [tmpDic getStringValueForKey:@"age" defaultValue:@""];
    personInfo.birthday = [[tmpDic getStringValueForKey:@"birthday" defaultValue:@""] substringToIndex:10];
    personInfo.biography = [tmpDic getStringValueForKey:@"biography" defaultValue:@""];
    personInfo.bloodtype = [tmpDic getStringValueForKey:@"bloodtype" defaultValue:@""];
    personInfo.profession = [tmpDic getStringValueForKey:@"profession" defaultValue:@""];
    personInfo.city = [tmpDic getStringValueForKey:@"city" defaultValue:@""];
    personInfo.constellation = [tmpDic getStringValueForKey:@"constellation" defaultValue:@""];
    personInfo.contentCount = [tmpDic getStringValueForKey:@"contentCount" defaultValue:@""];
    personInfo.countryVisited = [tmpDic getStringValueForKey:@"country_visited" defaultValue:@""];
    personInfo.facePath = [tmpDic getStringValueForKey:@"facePath" defaultValue:@""];
    personInfo.faceArray = [tmpDic objectForKey:@"faces"];
    [self loadingPics:(NSMutableArray*)personInfo.faceArray];
    personInfo.fansCount = [tmpDic getStringValueForKey:@"fansCount" defaultValue:@""];
    personInfo.favoriteCount = [tmpDic getStringValueForKey:@"favoriteCount" defaultValue:@""];
    personInfo.follow = [tmpDic getStringValueForKey:@"follow" defaultValue:@""];
    personInfo.followCount = [tmpDic getStringValueForKey:@"followCount" defaultValue:@""];
    personInfo.footmarkArray = [tmpDic objectForKey:@"footmark"];
    personInfo.gender = [tmpDic getStringValueForKey:@"gender" defaultValue:@""];
    personInfo.height = [tmpDic getStringValueForKey:@"height" defaultValue:@"0"];
    personInfo.interests = [tmpDic getStringValueForKey:@"interests" defaultValue:@""];
    personInfo.nation = [tmpDic getStringValueForKey:@"nation" defaultValue:@""];
    personInfo.nickname = [tmpDic getStringValueForKey:@"nickname" defaultValue:@""];
    personInfo.profession = [tmpDic getStringValueForKey:@"profession" defaultValue:@""];
    personInfo.tourism = [tmpDic getStringValueForKey:@"tourism" defaultValue:@""];
    personInfo.userId = [tmpDic getStringValueForKey:@"userId" defaultValue:@""];
    personInfo.weight = [tmpDic getStringValueForKey:@"weight" defaultValue:@"0"];
    [self refreshView:personInfo];
}

-(void)refreshView:(PersonInfo*)info {
    itemsArray = [[NSMutableArray alloc] init];
    headImageView.imageURL = [NSURL URLWithString:info.facePath];
    self.userIdLabel.text = [NSString stringWithFormat:@"ID:%@",info.userId];
    [itemsArray addObject:info.nickname];
    if ([info.gender integerValue] == 1) {
        self.userAgeLabel.text = [NSString stringWithFormat:@"M %@",info.age];
        [itemsArray addObject:@"Male"];
    } else {
        self.userAgeLabel.text = [NSString stringWithFormat:@"F %@",info.age];
        [itemsArray addObject:@"Female"];
    }
    self.nationLabel.text = info.nation;
    self.describeTextView.text = info.biography;
    [itemsArray addObject:info.birthday];
    [itemsArray addObject:info.height];
    [itemsArray addObject:info.weight];
    [itemsArray addObject:info.bloodtype];
    [itemsArray addObject:info.constellation];
    [itemsArray addObject:info.nation];
    [itemsArray addObject:info.profession];
    [itemsArray addObject:info.interests];
    [itemsArray addObject:info.countryVisited];
    [itemsArray addObject:info.tourism];
    [self.tableView reloadData];
}

- (void)refreshScrollView
{
    CGFloat width=100*(headImageArray.count)<300?320:100+headImageArray.count*90;
    
    CGSize contentSize=CGSizeMake(width, 100);
    [self.headerImagesScrollView setContentSize:contentSize];
//    [self.headerImagesScrollView setContentOffset:CGPointMake(width<320?0:width-320, 0) animated:YES];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.keyLabel.text = @"Name";
    } else if (indexPath.row == 1) {
        cell.keyLabel.text = @"Sex";
    } else if (indexPath.row == 2) {
        cell.keyLabel.text = @"Birthday";
    } else if (indexPath.row == 3) {
        cell.keyLabel.text = @"Height";
    } else if (indexPath.row == 4) {
        cell.keyLabel.text = @"Weight";
    } else if (indexPath.row == 5) {
        cell.keyLabel.text = @"Blood Type";
    } else if (indexPath.row == 6) {
        cell.keyLabel.text = @"Constellation";
    } else if (indexPath.row == 7) {
        cell.keyLabel.text = @"Country";
    } else if (indexPath.row == 8) {
        cell.keyLabel.text = @"Occupation";
    } else if (indexPath.row == 9) {
        cell.keyLabel.text = @"Interests";
    } else if (indexPath.row == 10) {
        cell.keyLabel.text = @"Countries Visited";
    } else if (indexPath.row == 11) {
        cell.keyLabel.text = @"Travelling Plans";
    }
    if (indexPath.row == 3) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@cm", [itemsArray objectAtIndex:indexPath.row]];
    } else if (indexPath.row == 4) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@kg", [itemsArray objectAtIndex:indexPath.row]];
    } else {
       cell.valueLabel.text = [itemsArray objectAtIndex:indexPath.row]; 
    }
    // Configure the cell...
    
    return cell;
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
    commDialogView = [[OneLineDialogView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    commDialogView.tag = indexPath.row;
    commDialogView.oneLineText.placeholder = [NSString stringWithFormat:@"%@",[itemsArray objectAtIndex:indexPath.row]];
    [commDialogView show];
    tmpTextField = commDialogView.oneLineText;
    if (indexPath.row == 3 || indexPath.row == 4) {
        [commDialogView.oneLineText setKeyboardType:UIKeyboardTypeNumberPad];
    } else if (indexPath.row == 2) {
        [commDialogView.oneLineText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    [commDialogView.oneLineText becomeFirstResponder];
}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setHeaderImagesScrollView:nil];
    [self setAddButton:nil];
    [self setHeadViewButton:nil];
    [self setUserIdLabel:nil];
    [self setUserAgeLabel:nil];
    [self setNationLabel:nil];
    [self setDescribeTextView:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_GET_PERSON_INFO object:nil];
}

- (void)loadingPics:(NSMutableArray*)faceArray {
    [headImageArray removeAllObjects];
    for (int i = 0; i < [faceArray count]; i ++) {
        NSDictionary *tmpDic = [faceArray objectAtIndex:i];
        EGOImageView *tmpEGV = [[EGOImageView alloc] init];
        tmpEGV.frame = CGRectMake(i*85, INSETS, PIC_WIDTH, PIC_HEIGHT);
        tmpEGV.imageURL = [NSURL URLWithString:[tmpDic objectForKey:@"facepath"]];
        [self.headerImagesScrollView addSubview:tmpEGV];
        [headImageArray addObject:tmpEGV];
    }
    [self refreshScrollView];
}

- (IBAction)addAction:(id)sender {
    //移动添加按钮
    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.addButton.center.x, self.addButton.center.y)]];
    [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(self.addButton.center.x+INSETS+PIC_WIDTH, self.addButton.center.y)]];
    [positionAnim setDelegate:self];
    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [positionAnim setDuration:0.25f];
    [self.addButton.layer addAnimation:positionAnim forKey:nil];
    [self.addButton setCenter:CGPointMake(self.addButton.center.x+INSETS+PIC_WIDTH, self.addButton.center.y)];
    
    //添加图片
    UIImageView *aImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boy"]];
    [aImageView setFrame:CGRectMake(INSETS-90, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [headImageArray addObject:aImageView];
    [self.headerImagesScrollView addSubview:aImageView];
    
    for (UIImageView *img in headImageArray) {
        
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x+INSETS+PIC_WIDTH, img.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [img.layer addAnimation:positionAnim forKey:nil];
        
        [img setCenter:CGPointMake(img.center.x+INSETS+PIC_WIDTH, img.center.y)];
    }
    
    
    
    [self refreshScrollView];
}
@end
