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
    
    self.addButton.hidden = YES;
    isEditModel = NO;
    tittlesForSectionOneArray = [NSArray arrayWithObjects:@"Name",@"Sex",@"Birthday",@"Height",@"Weight",@"Blood Type",@"Constellation",@"Country", nil];
    tittlesForSectionTwoArray = [NSArray arrayWithObjects:@"Occupation",@"Interests",@"Countries Visited",@"Countries Visited",@"Travelling Plans", nil];
    itemsArrayOne = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i++) {
        [itemsArrayOne addObject:@""];
    }
    
    
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _customActionSheet = [[CustomActionSheet alloc] init];
    [_customActionSheet addButtonWithTitle:@"Take Photo"];
    [_customActionSheet addButtonWithTitle:@"Library"];
    [_customActionSheet addButtonWithTitle:@"Cancel"];
    _customActionSheet.delegate = self;
    headFacePathArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResultPersonInfo:) name:FB_GET_PERSON_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResultUploadPhotoHeadImage:) name:FB_UPLOAD_PHOTO_HEAD_IMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResultUploadComplete) name:FB_UPLOAD_PHOTO_RERESH object:nil];
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
    [editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton setBackgroundColor:[UIColor clearColor]];
    
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 40, 44)];
    [saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor clearColor]];
    saveButton.hidden = YES;
    
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
    [tittleView addSubview:saveButton];
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

-(void)editButtonPressed
{
    NSLog(@"editButtonPressed");
    isEditModel = YES;
    saveButton.hidden = NO;
    editButton.hidden = YES;
    
}

-(void)saveButtonPressed
{
    NSLog(@"saveButtonPressed");
    isEditModel = NO;
    saveButton.hidden = YES;
    editButton.hidden = NO;
    
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
    //    switch (alertView.tag) {
    //        case 0:
    //        {
    //            //Name
    //            switch (buttonIndex) {
    //                case 0:
    //                    NSLog(@"0");
    //                    break;
    //                case 1:
    //                    NSLog(@"1 %@", tmpTextField.text);
    //                    [itemsArray replaceObjectAtIndex:alertView.tag withObject:tmpTextField.text];
    //                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    //                    [self updatePerson:itemsArray];
    //                    break;
    //                default:
    //                    break;
    //            }
    //        }
    //
    //    }
}

-(void)updatePerson:(NSMutableArray*)itemArray {
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBUpdatePersonInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID] NickName:[itemsArrayOne objectAtIndex:0] Biography:self.describeTextView.text City:[itemsArrayOne objectAtIndex:7] Email:@"" Gender:[itemsArrayOne objectAtIndex:1] Height:[itemsArrayOne objectAtIndex:3] Weight:[itemsArrayOne objectAtIndex:4] Birthday:[itemsArrayOne objectAtIndex:2] BloodType:[itemsArrayOne objectAtIndex:5] Profession:[itemsArrayOne objectAtIndex:8] Tourism:[itemsArrayOne objectAtIndex:11] Intersets:[itemsArrayOne objectAtIndex:9] CountryVisited:[itemsArrayOne objectAtIndex:10]];
}

-(void)onResultPersonInfo:(NSNotification*)notification {
    NSLog(@"result...person...info%@",notification.object);
    NSDictionary *tmpDic = notification.object;
    PersonInfo *personInfo = [[PersonInfo alloc] init];
    personInfo.age = [tmpDic getStringValueForKey:@"age" defaultValue:@""];
    if ([[tmpDic getStringValueForKey:@"birthday" defaultValue:@""] length] > 10) {
        personInfo.birthday = [[tmpDic getStringValueForKey:@"birthday" defaultValue:@""] substringToIndex:10];
    }
    
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
    itemsArrayOne = [[NSMutableArray alloc] init];
    headImageView.imageURL = [NSURL URLWithString:info.facePath];
    self.userIdLabel.text = [NSString stringWithFormat:@"ID:%@",info.userId];
    [itemsArrayOne addObject:info.nickname];
    if ([info.gender integerValue] == 1) {
        self.userAgeLabel.text = [NSString stringWithFormat:@"M %@",info.age];
        [itemsArrayOne addObject:@"Male"];
    } else {
        self.userAgeLabel.text = [NSString stringWithFormat:@"F %@",info.age];
        [itemsArrayOne addObject:@"Female"];
    }
    self.nationLabel.text = info.nation;
    self.describeTextView.text = info.biography;
    [itemsArrayOne addObject:@"19860402"];
    [itemsArrayOne addObject:info.height];
    [itemsArrayOne addObject:info.weight];
    [itemsArrayOne addObject:info.bloodtype];
    [itemsArrayOne addObject:info.constellation];
    [itemsArrayOne addObject:info.nation];
    [itemsArrayOne addObject:info.profession];
    [itemsArrayOne addObject:info.interests];
    [itemsArrayOne addObject:info.countryVisited];
    [itemsArrayOne addObject:info.tourism];
    [self.tableView reloadData];
}

- (void)refreshScrollView
{
    CGFloat width=100*(headImageArray.count + 1)<260?320:(headImageArray.count + 1)*90;
    NSLog(@"width %f", width);
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 8;
    }else{
        return 4;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    return sectionHeaderView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.keyLabel.text = [tittlesForSectionOneArray objectAtIndex:indexPath.row];
    }else{
        cell.keyLabel.text = [tittlesForSectionTwoArray objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row == 3) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@cm", [itemsArrayOne objectAtIndex:indexPath.row]];
    } else if (indexPath.row == 4) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@kg", [itemsArrayOne objectAtIndex:indexPath.row]];
    } else {
        cell.valueLabel.text = [itemsArrayOne objectAtIndex:indexPath.row];
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
    //    commDialogView = [[OneLineDialogView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    //    commDialogView.tag = indexPath.row;
    //    commDialogView.oneLineText.placeholder = [NSString stringWithFormat:@"%@",[itemsArray objectAtIndex:indexPath.row]];
    //    [commDialogView show];
    //    tmpTextField = commDialogView.oneLineText;
    //    if (indexPath.row == 3 || indexPath.row == 4) {
    //        [commDialogView.oneLineText setKeyboardType:UIKeyboardTypeNumberPad];
    //    } else if (indexPath.row == 2) {
    //        [commDialogView.oneLineText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //    }
    //    [commDialogView.oneLineText becomeFirstResponder];
    NSLog(@"didSelectRowAtIndexPath");
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_UPLOAD_PHOTO_RERESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_UPLOAD_PHOTO_HEAD_IMAGE object:nil];
}

- (void)loadingPics:(NSMutableArray*)faceArray {
    [headImageArray removeAllObjects];
    [headFacePathArray removeAllObjects];
    for (int i = 0; i < [self.headerImagesScrollView.subviews count]; i++) {
        EGOImageView *tmpE = [self.headerImagesScrollView.subviews objectAtIndex:i];
        [tmpE removeFromSuperview];
        NSLog(@"remove count %d", i);
    }
    for (int i = 0; i < [faceArray count]; i ++) {
        NSDictionary *tmpDic = [faceArray objectAtIndex:i];
        EGOImageView *tmpEGV = [[EGOImageView alloc] init];
        tmpEGV.tag = i;
        tmpEGV.frame = CGRectMake(i*85, INSETS, PIC_WIDTH, PIC_HEIGHT);
        tmpEGV.imageURL = [NSURL URLWithString:[tmpDic objectForKey:@"facepath"]];
        [headImageArray addObject:[tmpDic objectForKey:@"facepath"]];
        NSLog(@"headImageArray %@", headImageArray);
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap:)];
        tap1.numberOfTapsRequired = 1;
        [tmpEGV addGestureRecognizer:tap1];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        longTap.minimumPressDuration = 0.5;
        [tmpEGV addGestureRecognizer:longTap];
        tmpEGV.userInteractionEnabled = YES;
        [self.headerImagesScrollView addSubview:tmpEGV];
        NSLog(@"iiii %d", i);
    }
    if ([faceArray count] < 5) {
        self.addButton.hidden = NO;
        self.addButton.frame = CGRectMake([faceArray count]*85, INSETS, PIC_WIDTH, PIC_HEIGHT);
        [self.headerImagesScrollView addSubview:self.addButton];
    } else {
        self.addButton.hidden = YES;
    }
    [self refreshScrollView];
}

- (void)longPressTap:(UILongPressGestureRecognizer *)recogonizer {
    NSLog(@"long tap....");
    switch (recogonizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            EGOImageView *tmpEgo = (EGOImageView*)recogonizer.view;
            [manager FBDeletePersonPhotoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PhotoUrl:[headImageArray objectAtIndex:tmpEgo.tag] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
            [headImageArray removeObjectAtIndex:[[NSString stringWithFormat:@"%d",tmpEgo.tag] integerValue]];
        }
            break;
            
        default:
            break;
    }
}

-(void)onResultUploadComplete {
    NSLog(@"upload complete...");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetPersonInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

-(void)onResultUploadPhotoHeadImage:(NSNotification*)notification {
    NSLog(@"upload success...");
    if (manager == nil) {
        manager = [WeiBoMessageManager getInstance];
    }
    [manager FBGetPersonInfoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

- (void)headImageTap:(UITapGestureRecognizer*)sender {
    EGOImageView *tmpEgo = (EGOImageView*)sender.view;
    NSLog(@"imgae %d %@", tmpEgo.tag,[headImageArray objectAtIndex:tmpEgo.tag]);
    headImageView.imageURL = [NSURL URLWithString:[headImageArray objectAtIndex:tmpEgo.tag]];
    [manager FBUpdatePersonHeaderImageWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] FacePath:[headImageArray objectAtIndex:tmpEgo.tag] PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 1:
            NSLog(@"1");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"[levi]take photo...");
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *pictureData = UIImageJPEGRepresentation(editedImage,1);
    [manager FBAddPersonPhotoWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_ID] PhotoFile:pictureData PassId:[[NSUserDefaults standardUserDefaults] objectForKey:FB_PASS_ID]];
    //    _photoData = UIImageJPEGRepresentation(editedImage, 1);
}

-(NSString *)returnFilePath:(NSString*)nameStr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:nameStr];
    
    return filePath;
}

- (IBAction)addAction:(id)sender {
    NSLog(@"[levi] add photo");
    [_customActionSheet showInView:self.view];
    //移动添加按钮
    //    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    //    [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.addButton.center.x, self.addButton.center.y)]];
    //    [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(self.addButton.center.x+INSETS+PIC_WIDTH, self.addButton.center.y)]];
    //    [positionAnim setDelegate:self];
    //    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //    [positionAnim setDuration:0.25f];
    //    [self.addButton.layer addAnimation:positionAnim forKey:nil];
    //    [self.addButton setCenter:CGPointMake(self.addButton.center.x+INSETS+PIC_WIDTH, self.addButton.center.y)];
    //
    //    //添加图片
    //    UIImageView *aImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boy"]];
    //    [aImageView setFrame:CGRectMake(INSETS-90, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    //    [headImageArray addObject:aImageView];
    //    [self.headerImagesScrollView addSubview:aImageView];
    //
    //    for (UIImageView *img in headImageArray) {
    //
    //        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    //        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
    //        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x+INSETS+PIC_WIDTH, img.center.y)]];
    //        [positionAnim setDelegate:self];
    //        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //        [positionAnim setDuration:0.25f];
    //        [img.layer addAnimation:positionAnim forKey:nil];
    //        
    //        [img setCenter:CGPointMake(img.center.x+INSETS+PIC_WIDTH, img.center.y)];
    //    }
    //    
    //    
    //    
    //    [self refreshScrollView];
}
@end
