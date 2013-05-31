//
//  FaceView.m
//  FaceDemo
//
//  Created by user on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView
@synthesize deletage = _deletage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    if (_deletage) {
        _deletage = nil;
    }
}

-(void)createExpressionWithPage:(int)page
{
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = [[NSString stringWithFormat:@"%02d",i*8 + j + page*32] intValue];
            button.tag = i*8+j+page*32;
            //NSLog(@"button.tag %d",button.tag);
            //NSLog(@"tag %@",[NSString stringWithFormat:@"%03d",i*8 + j + page*32]);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(j*40, i*54, 40, 54);
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d",i*8 + j + page*32]] forState:UIControlStateNormal];
            if (button.imageView.image == nil) 
            {
                [button setEnabled:NO];
            }
            [self addSubview:button];
        }
    }
}

-(void)buttonClick:(UIButton *)button
{
    NSString *name = [NSString stringWithFormat:@"[%03d]",button.tag];
    if (self.deletage) 
    {
        [self.deletage expressionClickWith:self faceName:name];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
