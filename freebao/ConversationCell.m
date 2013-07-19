//
//  ConversationCell.m
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ConversationCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(9.0f, 9.0f, 40.0f, 40.0f);
		[self.contentView addSubview:headImageView];
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 9, 80, 16)];
        userNameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 150, 13)];
        createDateLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 33, 260, 15)];
        contentLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self.contentView addSubview:userNameLabel];
        [self.contentView addSubview:createDateLabel];
        [self.contentView addSubview:contentLabel];
    }
    return self;
}

-(void)setCellValue:(ConversationInfo *)value {
    userNameLabel.text = value.fromUserName;
    createDateLabel.text = value.date;
    contentLabel.text = value.content;
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
