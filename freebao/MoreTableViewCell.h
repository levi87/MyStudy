//
//  MoreTableViewCell.h
//  freebao
//
//  Created by freebao on 13-7-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoHttpManager.h"
#define FONT @"HelveticaNeue-Light"

@interface MoreTableViewCell : UITableViewCell <UIAlertViewDelegate> {
    UIButton *logoutButton;
    UIImageView *tmpImageV;
}

-(void)setButtonHide:(BOOL)value;

-(void)setAccessoryViewHide:(BOOL)value;

@end
