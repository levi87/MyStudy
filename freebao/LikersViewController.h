//
//  LikersViewController.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikersCell.h"
#import "AppDelegate.h"
#import "BlankCell.h"

@interface LikersViewController : UITableViewController {
@private
    NSMutableArray *headPhotos;
}

-(void)clearCache;

@end
