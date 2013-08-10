//
//  NewContactViewController.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NewContactViewController.h"
#import "NewNoticesViewController.h"
#import "NewAtMeViewController.h"
#import "PersonAddress.h"
#import "NewCommentsViewController.h"

@interface NewContactViewController ()

@end

@implementation NewContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _addressBook = [[NSMutableArray alloc]init];
        [self readContactFromLocal];
        
    }
    return self;
}


- (void)readContactFromLocal {
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        if (granted) {
            NSLog(@"read works.");
            [self filterContentForSearchText:@""];
        }
    });
    CFRelease(addressBook);
}

- (void)filterContentForSearchText:(NSString*)searchText {
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return;
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if([searchText length]==0) {
        //查询所有
        NSArray *r = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
        for (int i = 0; i < [r count]; i ++) {
            ABRecordRef thisPerson = CFBridgingRetain([r objectAtIndex:i]);
            NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
            firstName = firstName != nil?firstName:@"";
            
            NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
            lastName = lastName != nil?lastName:@"";
            NSString *tel;
            ABMultiValueRef phoneNumber = CFBridgingRetain(CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonPhoneProperty)));
            if (ABMultiValueGetCount(phoneNumber) > 0) {
                tel = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumber, 0));
            }
            
//            NSLog(@"name %@",[NSString stringWithFormat:@"%@ %@",firstName,lastName]);
            NSString *name = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
            NSString *strPhone = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
//            NSLog(@"phone %@", strPhone);
            PersonAddress *personAddress = [[PersonAddress alloc]init];
            personAddress.Name = name;
            personAddress.phone = strPhone;
            [_addressBook addObject:personAddress];
            CFRelease(phoneNumber);
            CFRelease(thisPerson);
        }
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        //        self.listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        CFRelease(cfSearchText);
    }
    CFRelease(addressBook);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    addressBookSorted = [_addressBook sortedArrayUsingComparator:^(id a, id b) {
//        
//        char c1=pinyinFirstLetterNew([(NSString*)a characterAtIndex:0]);
//        
//        char c2=pinyinFirstLetterNew([(NSString*)b characterAtIndex:0]);
//        
//        NSString* s1=[[NSString stringWithFormat:@"%c",c1] uppercaseString];
//        
//        NSString* s2=[[NSString stringWithFormat:@"%c",c2] uppercaseString];
//        
//        return [s1 compare:s2];
//        
//    }];
//    
//    NSLog(@"%@",addressBookSorted);
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
    
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

    [self.view addSubview:tittleView];
    [self.view addSubview:tittleLineView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 568)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.backgroundColor = [UIColor clearColor];
//    searchBar.showsCancelButton = YES;
    [searchBar canResignFirstResponder];
    [searchBar setTintColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    [_tableView setTableHeaderView:searchBar];

    
    [self.view addSubview:_tableView];
   
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 2;
    }else{
        return [_addressBook count];
    }
    
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
    PersonAddress *personAddress;
    
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
            [cell setNum:@"2"];
        }else if(indexPath.row == 1){
            [cell setType:@"@Me"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_atme_normal.png"]];
            [cell setDetail:@"Michael in your release status @ you"];
            [cell setNum:@"0"];
        }else{
            [cell setType:@"Comments"];
            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_comment_normal.png"]];
            [cell setDetail:@"Michael commented on you"];
            [cell setNum:@"0"];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell setType:@"Jason"];
//            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_notice_normal.png"]];
            [cell setDetail:@"Fighting! Fighting! Fighting!"];
            [cell setNum:@"0"];
        }else if(indexPath.row == 1){
            [cell setType:@"William"];
//            [cell setHeadImage:[UIImage imageNamed:@"icon_contact_atme_normal.png"]];
            [cell setDetail:@"Fighting!"];
            [cell setNum:@"0"];
        }
    }else{
        personAddress = [_addressBook objectAtIndex:indexPath.row];
        [cell setType:personAddress.Name];
        [cell setDetail:personAddress.phone];
        [cell setNum:@"0"];
    }
    
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@" section0  row0");
            NewNoticesViewController *noticeVC = [[NewNoticesViewController alloc]init];
            [self.navigationController pushViewController:noticeVC animated:YES ];
        }else if(indexPath.row == 1){
            NewAtMeViewController *homeCV = [[NewAtMeViewController alloc]init];
            [self.navigationController pushViewController:homeCV animated:YES];
        }else if(indexPath.row == 2){
            NewCommentsViewController *commentVC = [[NewCommentsViewController alloc]init];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
    }
}

-(void)didTapAnywhere:(UITapGestureRecognizer *) recognizer
{
    [searchBar resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
