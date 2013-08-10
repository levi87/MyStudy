//
//  ContactCommonCell.m
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ContactCommonCell.h"

#define FONT_SIZE 18.0
#define FONT @"HelveticaNeue-Light"
@implementation ContactCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] init];
		_headImageView.frame = CGRectMake(8.0f, 4.0f, 40.0f, 40.0f);
        _headImageView.userInteractionEnabled = YES;
    
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.frame = CGRectMake(54, 6, 200, 18);
        _typeLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.frame = CGRectMake(54, 28, 230, 15);
        _detailLabel.text = @"test test test";
        _detailLabel.font = [UIFont fontWithName:FONT size:15];
        [_detailLabel setAdjustsFontSizeToFitWidth:YES];
        _detailLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        
        _rightImageView = [[UIImageView alloc] init];
		_rightImageView.frame = CGRectMake(299, 19, 15, 15);
        [_rightImageView setImage:[UIImage imageNamed:@"bg_contacts_boy.png"]];
        _rightImageView.userInteractionEnabled = YES;
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 13, 13)];
        _numLabel.textAlignment = UITextAlignmentCenter;
        [_numLabel setAdjustsFontSizeToFitWidth:YES];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.backgroundColor = [UIColor clearColor];
        [_rightImageView addSubview:_numLabel];
        
        [self addSubview:_headImageView];
        [self addSubview:_typeLabel];
        [self addSubview:_detailLabel];
        [self addSubview:_rightImageView];
    }
    return self;
}

- (void)setType:(NSString *)type
{
    _typeLabel.text = type;
}

- (void)setHeadImage:(UIImage *) headImage
{
    _headImageView.image = headImage;
}

- (void)setDetail:(NSString *) detail
{
    _detailLabel.text = detail;
}


- (void)setNum:(NSString *)num
{
    if ([@"0"isEqualToString:num]) {
        _rightImageView.hidden = YES;
    }else{
        _rightImageView.hidden = NO;
        _numLabel.text = num;
    }
    
}

-(void)prepareForReuse
{
    _headImageView.image = nil;
    _typeLabel.text = @"";
    _detailLabel.text = @"";
    _rightImageView.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
