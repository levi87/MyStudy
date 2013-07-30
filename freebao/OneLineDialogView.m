//
//  OneLineDialogView.m
//  
//
//  Created by levi on 13-1-30.
//  Copyright (c) 2013年 weiqun. All rights reserved.
//

#import "OneLineDialogView.h"

@implementation OneLineDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self != nil) {
        // 初始化自定义控件，注意摆放的位置，可以多试几次位置参数直到满意为止
        // createTextField函数用来初始化UITextField控件，在文件末尾附上
        UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 7, 25)];
        paddingView.textColor = [UIColor clearColor];
        paddingView.backgroundColor = [UIColor clearColor];
        self.oneLineText = [self createTextField:nil
                                   withFrame:CGRectMake(15, 45, 251, 36)];
        self.oneLineText.delegate = self;
        self.oneLineText.leftView = paddingView;
        self.oneLineText.leftViewMode = UITextFieldViewModeAlways;
        self.oneLineText.rightView = paddingView;
        self.oneLineText.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.oneLineText];
    }
    return self;
}

// Override父类的layoutSubviews方法
- (void)layoutSubviews {
    [super layoutSubviews];     // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    
    for (UIView* view in self.subviews) {
        //        if ([view class] == [UIImageView class]){
        //            [view setHidden:YES];
        //        }
        // 搜索AlertView底部的按钮，然后将其位置下移
        // IOS5以前按钮类是UIButton, IOS5里该按钮类是UIThreePartButton
        if ([view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = self.oneLineText.frame.origin.y + 50;
            view.frame = btnBounds;
            //            [view setHidden:YES];
        }
    }

    // 定义AlertView的大小
    CGRect bounds = self.frame;
    bounds.size.height = 170;
    self.frame = bounds;
}

- (UITextField*)createTextField:(NSString*)placeholder withFrame:(CGRect)frame {
    UITextField* field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = placeholder;
//    field.secureTextEntry = YES;
    field.backgroundColor = [UIColor whiteColor];
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return field;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.text.length > 20) {
        return NO;
    } else {
        int length1 = 20 - textField.text.length;
        if (length1 >= string.length) {
            return YES;
        } else {
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string substringToIndex:length1]];
            return NO;
        }
    }
    if (range.location > 20) {
        textField.text = [temp substringToIndex:11];
        return NO;
    }
}

@end
