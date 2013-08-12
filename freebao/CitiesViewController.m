//
//  CitiesViewController.m
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CitiesViewController.h"
#import "pinyin.h"
#import "ChineseString.h"

#define CHECK_TAG 1110

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"

@interface CitiesViewController ()
@property NSUInteger curSection;
@property NSUInteger curRowCities;
@end

@implementation CitiesViewController
@synthesize contactsArray = _contactsArray;
@synthesize keys = _keys;
@synthesize curRowCities;
@synthesize curSection;
@synthesize sortedArrForArrays = _sortedArrForArrays;
@synthesize sectionHeadsKeys = _sectionHeadsKeys;

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
    [self initTitleBar];
    
    curRowCities = NSNotFound;
    
    _keys = [NSArray arrayWithObjects:@"",@"",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
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

-(void)initTitleBar {
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"My Cities";
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

- (void)backButtonAction {
    NSLog(@"[levi]back...");
    [self.navigationController popViewControllerAnimated:YES];
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
    return [[_contactsArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)viewWillAppear:(BOOL)animated {
    tittleView.hidden = NO;
    tittleLineView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
