//
//  LikersCell.m
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "LikersCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"

#define TAP_NOTIFICATION @"tap_notification"
@implementation LikersCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(9.0f, 9.0f, 40.0f, 40.0f);
        UITapGestureRecognizer *singleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadIcon)];
        singleGes.numberOfTapsRequired = 1;
        [headImageView addGestureRecognizer:singleGes];
        headImageView.userInteractionEnabled = YES;
		[self.contentView addSubview:headImageView];
        nickNameLabel = [[UILabel alloc] init];
        nickNameLabel.frame = CGRectMake(58, 9, 40, 13);
        nickNameLabel.text = @"levi";
        nickNameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self.contentView addSubview:nickNameLabel];
        sexImageV = [[UIImageView alloc] init];
        sexImageV.frame = CGRectMake(98, 9, 13, 13);
        sexImageV.image = [UIImage imageNamed:@"sex-female.png"];
        [self.contentView addSubview:sexImageV];
        ageLabel = [[UILabel alloc] init];
        ageLabel.frame = CGRectMake(sexImageV.frame.origin.x + sexImageV.frame.size.width + 5, 9, 20, 13);
        ageLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        ageLabel.text = @"26";
        ageLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:ageLabel];
    }
    return self;
}

-(void)tapHeadIcon {
    [[NSNotificationCenter defaultCenter] postNotificationName:TAP_NOTIFICATION object:nil];
}

-(void)setHeadPhoto:(NSString *)headPhoto {
    headImageView.imageURL = [NSURL URLWithString:headPhoto];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[headImageView cancelImageLoad];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
