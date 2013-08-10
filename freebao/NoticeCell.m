//
//  NoticeCell.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "NoticeCell.h"

#define FONT_SIZE 18.0
#define FONT @"HelveticaNeue-Light"
@implementation NoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] init];
		_headImageView.frame = CGRectMake(8.0f, 4.0f, 40.0f, 40.0f);
        _headImageView.userInteractionEnabled = YES;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(54, 6, 200, 18);
        _nameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.frame = CGRectMake(54, 28, 230, 15);
        _detailLabel.text = @"test test test";
        _detailLabel.font = [UIFont fontWithName:FONT size:15];
        [_detailLabel setAdjustsFontSizeToFitWidth:YES];
        _detailLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 9, 80, 15)];
        _timeLabel.textAlignment = UITextAlignmentRight;
        [_timeLabel setAdjustsFontSizeToFitWidth:YES];
        _timeLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        _timeLabel.text = @"2012-8-10";
        _timeLabel.font = [UIFont fontWithName:FONT size:15];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_headImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_detailLabel];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

- (void)setHeadImage:(UIImage *) headImage
{
    _headImageView.image = headImage;
}

- (void)setDetail:(NSString *) detail
{
    _detailLabel.text = detail;
}


- (void)setTime:(NSString *)time
{
    _timeLabel.text = time;
}

-(void)prepareForReuse
{
    _headImageView.image = nil;
    _nameLabel.text = @"";
    _detailLabel.text = @"";
    _timeLabel.text = @"";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
