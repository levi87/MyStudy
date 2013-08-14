//
//  AboutCell.m
//  freebao
//
//  Created by freebao on 13-8-14.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell
@synthesize labelName = _labelName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 58)];
        [self.labelName setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.labelName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
