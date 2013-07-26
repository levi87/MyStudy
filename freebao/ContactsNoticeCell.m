//
//  ContactsNoticeCell.m
//  freebao
//
//  Created by freebao on 13-7-26.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ContactsNoticeCell.h"

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"

@implementation ContactsNoticeCell
@synthesize headImageView = _headImageView;
@synthesize typeLabel = _typeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] init];
		_headImageView.frame = CGRectMake(9.0f, 9.0f, 40.0f, 40.0f);
//        UITapGestureRecognizer *singleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadIcon)];
//        singleGes.numberOfTapsRequired = 1;
//        [headImageView addGestureRecognizer:singleGes];
        _headImageView.userInteractionEnabled = YES;
		[self.contentView addSubview:_headImageView];
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.frame = CGRectMake(58, 9, 160, 13);
        _typeLabel.text = @"levi";
        _typeLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self.contentView addSubview:_typeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
