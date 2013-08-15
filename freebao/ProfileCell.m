//
//  ProfileCell.m
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ProfileCell.h"
#import "WeiBoHttpManager.h"
#define FONT_SIZE 18.0
#define FONT @"HelveticaNeue"

@implementation ProfileCell
@synthesize keyLabel = _keyLabel;
@synthesize valueLabel = _valueLabel;
@synthesize key = _key;
@synthesize valueTextField = _valueTextField;
@synthesize isEdit = _isEdit;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.frame = CGRectMake(5, 0, 135, 44);
        _keyLabel.textColor = [UIColor grayColor];
        _keyLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
//        _valueLabel = [[UILabel alloc] init];
//        _valueLabel.frame = CGRectMake(218, 0, 95, 44);
//        _valueLabel.textColor = [UIColor lightGrayColor];
//        _valueLabel.textAlignment = UITextAlignmentRight;
//        _valueLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        
        _valueTextField =[[UITextField alloc]initWithFrame:CGRectMake(208, 0, 105, 44)];
//        _valueTextField.borderStyle = UITextBorderStyleRoundedRect;
        _valueTextField.enabled = NO;
//        _valueTextField.hidden = YES;
        _valueTextField.textColor = [UIColor lightGrayColor];
        _valueTextField.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _valueTextField.textAlignment = UITextAlignmentRight;
        _valueTextField.delegate = self;
//        _valueTextField.text = @"truth273";
        
//        _valueTextField =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//        _valueTextField.borderStyle = UITextBorderStyleRoundedRect;
//        _valueTextField.enabled = NO;
//        _valueTextField.hidden = YES;
//        _valueTextField.textColor = [UIColor lightGrayColor];
//        _valueTextField.font = [UIFont fontWithName:FONT size:FONT_SIZE];
//        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
//        _valueTextField.text = @"truth273";
        [self addSubview:_keyLabel];
        [self addSubview:_valueLabel];
        [self addSubview:_valueTextField];
        _isEdit = NO;
    }
    return self;
}


-(void)setEditModel
{
//    if (self.isEdit) {
//        self.valueTextField.hidden = NO;
//        self.valueTextField.enabled = YES;
//        self.keyLabel.hidden = YES;
//        self.valueLabel.hidden = YES;
//        [self.valueTextField becomeFirstResponder];
//    }else
//    {
//        self.valueTextField.hidden = YES;
//        self.valueTextField.enabled = NO;
//        self.keyLabel.hidden = NO;
//        self.valueLabel.hidden = NO;
//    }
    
//    [self.valueTextField ];
}

-(void)prepareForReuse
{
//    NSLog(@"prepareForReuse");
//    self.valueTextField.hidden = YES;
//    self.valueTextField.enabled = NO;
//    self.keyLabel.hidden = NO;
//    self.valueLabel.hidden = NO;
}

-(void)resignTextField
{
//    [self.valueTextField resignFirstResponder];
//    self.keyLabel.hidden = NO;
//    self.valueLabel.hidden = NO;
//    self.valueTextField.hidden = YES;
//    self.valueTextField.enabled = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSDictionary *resultUser = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:self.key,textField.text, nil] forKeys:[NSArray arrayWithObjects:@"key",@"value", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:FB_UPDATE_PERSONALDIC object:resultUser];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
