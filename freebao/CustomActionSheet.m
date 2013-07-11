//
//  CustomActionSheet.m
//  freebao
//
//  Created by freebao on 13-7-11.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CustomActionSheet.h"

@implementation CustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
