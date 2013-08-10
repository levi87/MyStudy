//
//  NewNoticesViewController.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCommonCell.h"

@interface NewNoticesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end
