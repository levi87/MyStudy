//
//  ProfileCell.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"

@interface ProfileCell : UITableViewCell {
    UILabel *keyLabel;
    UILabel *valueLabel;
}

-(void)setCellValue:(ProfileInfo*)value;

@end
