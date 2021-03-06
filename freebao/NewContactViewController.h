//
//  NewContactViewController.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCommonCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface NewContactViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITapGestureRecognizer *tapRecognizer;
    UITableView *_tableView;
    UISearchBar *searchBar;
    NSMutableArray *_addressBook;
    NSArray *addressBookSorted;
}

//@property(nonatomic,strong) IBOutlet UISearchDisplayController *searchDisplay;

@end
