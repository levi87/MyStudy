//
//  ContactsViewController.m
//  freebao
//
//  Created by freebao on 13-7-26.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ContactsViewController.h"
#import "pinyin.h"
#import "ChineseString.h"

#define CHECK_TAG 1110

@interface ContactsViewController ()
@property NSUInteger curSection;
@property NSUInteger curRow;
@end

@implementation ContactsViewController
@synthesize contactsArray = _contactsArray;
@synthesize keys = _keys;
@synthesize curRow;
@synthesize curSection;
@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

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

    curRow = NSNotFound;
    
    _keys = [NSArray arrayWithObjects:@"",@"",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    [self readContactFromLocal];
    NSMutableArray *_dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...
    
    //add test data
    [_dataArr addObject:@"郭靖"];
    [_dataArr addObject:@"黄蓉"];
    [_dataArr addObject:@"杨过"];
    [_dataArr addObject:@"苗若兰"];
    [_dataArr addObject:@"令狐冲"];
    [_dataArr addObject:@"小龙女"];
    [_dataArr addObject:@"胡斐"];
    [_dataArr addObject:@"水笙"];
    [_dataArr addObject:@"任盈盈"];
    [_dataArr addObject:@"白琇"];
    [_dataArr addObject:@"狄云"];
    [_dataArr addObject:@"石破天"];
    [_dataArr addObject:@"殷素素"];
    [_dataArr addObject:@"张翠山"];
    [_dataArr addObject:@"张无忌"];
    [_dataArr addObject:@"青青"];
    [_dataArr addObject:@"袁冠南"];
    [_dataArr addObject:@"萧中慧"];
    [_dataArr addObject:@"袁承志"];
    [_dataArr addObject:@"乔峰"];
    [_dataArr addObject:@"王语嫣"];
    [_dataArr addObject:@"段玉"];
    [_dataArr addObject:@"虚竹"];
    [_dataArr addObject:@"苏星河"];
    [_dataArr addObject:@"丁春秋"];
    [_dataArr addObject:@"庄聚贤"];
    [_dataArr addObject:@"阿紫"];
    [_dataArr addObject:@"阿朱"];
    [_dataArr addObject:@"阿碧"];
    [_dataArr addObject:@"鸠魔智"];
    [_dataArr addObject:@"萧远山"];
    [_dataArr addObject:@"慕容复"];
    [_dataArr addObject:@"慕容博"];
    [_dataArr addObject:@"Jim"];
    [_dataArr addObject:@"Lily"];
    [_dataArr addObject:@"Ethan"];
    [_dataArr addObject:@"Green小"];
    [_dataArr addObject:@"Green大"];
    [_dataArr addObject:@"DavidSmall"];
    [_dataArr addObject:@"DavidBig"];
    [_dataArr addObject:@"James"];
    [_dataArr addObject:@"Kobe Brand"];
    [_dataArr addObject:@"Kobe Crand"];
    _contactsArray = [self getChineseStringArr:_dataArr];
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
            
            NSLog(@"name %@",[NSString stringWithFormat:@"%@ %@",firstName,lastName]);
            NSString *strPhone = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            strPhone = [strPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSLog(@"phone %@", strPhone);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_contactsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (section == 0) {
//        return 3;
//    }
//    return 6;
    return [[_contactsArray objectAtIndex:section] count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
//    cell.textLabel.font = [UIFont systemFontOfSize:18];
//    cell.textLabel.text = @"TEST";
//    
//    if (indexPath.section == curSection && indexPath.row == curRow)
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    else
//        cell.accessoryType = UITableViewCellAccessoryNone;
    if ([_contactsArray count] > indexPath.section) {
        NSArray *arr = [_contactsArray objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = str.string;
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Notice";
//    } else if (section == 1) {
//        return @"Freebao User";
//    }
    NSString *key = [_sectionHeadsKeys objectAtIndex:section];
    return key;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionHeadsKeys;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetterNew([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

@end
