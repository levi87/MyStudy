//
//  LPFriendCell.m
//  HHuan
//
//  Created by yonghongchen on 11-11-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LPFriendCell.h"

@implementation LPFriendCell
@synthesize invitationBtn;
@synthesize nameLabel;
@synthesize headerView;
@synthesize lidStr;
@synthesize type;
@synthesize cellBG;
@synthesize delegate = _delegate;
@synthesize lpCellIndexPath = _lpCellIndexPath;

- (IBAction)cellButtonClicked:(id)sender 
{
    [_delegate lpCellDidClicked:self];
}

- (void)dealloc
{
}
@end
