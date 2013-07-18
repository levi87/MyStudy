//
//  CustomToolbar.m
//  freebao
//
//  Created by freebao on 13-7-8.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CustomToolbar.h"

@implementation CustomToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
        self.clearsContextBeforeDrawing = YES;
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
