//
//  OneLineDialogView.h
//  
//
//  Created by levi on 13-1-30.
//  Copyright (c) 2013年 weiqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneLineDialogView : UIAlertView <UITextFieldDelegate>

@property(nonatomic, retain) UITextField* oneLineText;

@end
