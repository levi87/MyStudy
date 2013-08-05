//
//  ProfileCell.m
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell
@synthesize keyLabel = _keyLabel;
@synthesize valueLabel = _valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.frame = CGRectMake(5, 0, 130, 44);
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.frame = CGRectMake(220, 0, 95, 44);
        _valueLabel.textAlignment = UITextAlignmentRight;
//        _keyLabel.text = @"key";
//        _valueLabel.text = @"value";
        [self addSubview:_keyLabel];
        [self addSubview:_valueLabel];
    }
    return self;
}

-(void)setCellValue:(PersonInfo *)value {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
