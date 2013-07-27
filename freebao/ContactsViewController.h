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
#import "AtMeViewController.h"
#import "NoticesViewController.h"

@interface ContactsViewController : UITableViewController {
    NSMutableArray *_contactsArray;
    NSArray *_keys;
    AtMeViewController *_atMeVc;
    NoticesViewController *_noticeVc;
    
    UIView *tittleView;
    UIView *tittleLineView;
}

@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@property (strong, nonatomic) IBOutlet UIView *headerView;
- (IBAction)noticeButtonAction:(id)sender;
- (IBAction)atButtonAction:(id)sender;
- (IBAction)commentButtonAction:(id)sender;
@end
