//
//  ProfileCell.m
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        keyLabel = [[UILabel alloc] init];
        keyLabel.frame = CGRectMake(0, 0, 80, 44);
        valueLabel = [[UILabel alloc] init];
        valueLabel.frame = CGRectMake(260, 0, 60, 44);
        keyLabel.text = @"key";
        valueLabel.text = @"value";
        [self addSubview:keyLabel];
        [self addSubview:valueLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
