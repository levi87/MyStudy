//
//  MoreTableViewCell.m
//  freebao
//
//  Created by freebao on 13-7-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = CGRectMake(10, 20, 300, 44);
        logoutButton.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        [logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        [logoutButton.titleLabel setFont:[UIFont fontWithName:FONT size:18]];
        [logoutButton setTitleColor:[UIColor colorWithRed:255/255.0 green:44/255.0 blue:44/255.0 alpha:1] forState:UIControlStateNormal];
        [self.contentView addSubview:logoutButton];
        tmpImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more_chevron.png"]];
        self.accessoryView = tmpImageV;
        [self.textLabel setFont:[UIFont fontWithName:FONT size:15]];
//        CGRect frame = self.textLabel.frame;
//        frame.size.height = 42;
//        frame.origin.y = 10;
//        self.textLabel.frame = frame;

    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height - 1, rect.size.width - 20, 0.5));
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonHide:(BOOL)value {
    logoutButton.hidden = value;
}

- (void)setAccessoryViewHide:(BOOL)value {
    tmpImageV.hidden = value;
}

@end
