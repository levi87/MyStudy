//
//  ContactsViewController.h
//  freebao
//
//  Created by freebao on 13-7-26.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsUserCell.h"
#import "ContactsNoticeCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsViewController : UITableViewController {
    NSMutableArray *_contactsArray;
    NSArray *_keys;
}

@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@end
