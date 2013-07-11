//
//  CommentsViewController.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsCell.h"
#import "AppDelegate.h"
#import "BlankCell.h"
#import "CustomActionSheet.h"

@interface CommentsViewController : UITableViewController <RMSwipeTableViewCellDelegate>{
@private
    NSMutableArray *headPhotos;
}

-(void)clearCache;

@end
