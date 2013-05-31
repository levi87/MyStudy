//
//  FaceScrollView.m
//  FaceDemo
//
//  Created by user on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FaceScrollView.h"
#import "FaceView.h"

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)rect target:(id)target
{
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code here.
        
        for (int i = 0; i < 4; i++) 
        {
            FaceView *faceView = [[FaceView alloc] initWithFrame:CGRectMake(i*320,0,320,160)];
            faceView.deletage = target;
            faceView.tag = i;
            [faceView createExpressionWithPage:i];
            faceView.backgroundColor = [UIColor greenColor];
            [self addSubview:faceView];
        }
        
        
        

    }
    
    return self;
}

@end
