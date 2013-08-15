//
//  CityUserCell.m
//  freebao
//
//  Created by freebao on 13-8-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CityUserCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue"

@implementation CityUserCell

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
        nickNameLabel.frame = CGRectMake(58, 9, 160, 13);
        nickNameLabel.text = @"levi";
        nickNameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self.contentView addSubview:nickNameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

-(void)setCellValue:(CityUserInfo *)info {
    nickNameLabel.text = info.userName;
}

@end
