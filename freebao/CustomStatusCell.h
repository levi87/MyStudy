//
//  CustomStatusCell.h
//  freebao
//
//  Created by freebao on 13-7-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "LPBaseCell.h"

@interface CustomStatusCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *customTableView;
@end
