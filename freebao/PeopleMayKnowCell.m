//
//  PeopleMayKnowCell.m
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PeopleMayKnowCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"

@implementation PeopleMayKnowCell

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
        sexImageV = [[UIImageView alloc] init];
        sexImageV.frame = CGRectMake(150, 9, 13, 13);
        sexImageV.image = [UIImage imageNamed:@"sex-female.png"];
        [self.contentView addSubview:sexImageV];
        ageLabel = [[UILabel alloc] init];
        ageLabel.frame = CGRectMake(sexImageV.frame.origin.x + sexImageV.frame.size.width + 5, 9, 20, 13);
        ageLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        ageLabel.text = @"26";
        ageLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:ageLabel];
        cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 36, 260, 15)];
        cityLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self.contentView addSubview:cityLabel];
        commLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 23, 260, 13)];
        commLabel.font = [UIFont fontWithName:FONT size:12];
        commLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:commLabel];
    }
    return self;
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

-(void)setCellValue:(PeopleMayKnowInfo *)info {
    nickNameLabel.text = info.userName;
    cityLabel.text = @"hangzhou, China";
    commLabel.text = @"friends in common.";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
