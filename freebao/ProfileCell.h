//
//  ProfileCell.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@interface ProfileCell : UITableViewCell <UITextFieldDelegate>{
    UILabel *_keyLabel;
    UILabel *_valueLabel;
}

//-(void)setCellValue:(PersonInfo*)value;
@property UILabel *keyLabel;
@property UILabel *valueLabel;
@property UITextField *valueTextField;
@property NSString *key;
@property BOOL *isEdit;

-(void)setEditModel;
-(void)resignTextField;

@end
