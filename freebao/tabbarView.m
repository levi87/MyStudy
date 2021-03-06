//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarView.h"

#define SHOW_POST_VIEW @"fb_show_post"



@implementation tabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
//        [self setBackgroundColor:[UIColor blueColor]];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
//    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0"]];
//    [_tabbarView setFrame:CGRectMake(0, 9, _tabbarView.bounds.size.width, 51)];
//    [_tabbarView setUserInteractionEnabled:YES];
//    
//    _tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];
//
//    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
//    
//    [_tabbarViewCenter setUserInteractionEnabled:YES];
//    
//    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
//    _button_center.adjustsImageWhenHighlighted = YES;
//    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
//    
//    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
//    
//    _button_center.center =CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0 + 5) ;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor blackColor]];
    [lineView setAlpha:0.7];
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, 320, 45.5)];
    [_navigationBarView setBackgroundColor:[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:0.95]];
//    [_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:lineView];
    [self addSubview:_navigationBarView];
    
    [self layoutBtn];

}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(0, 0, 64, 45)];
    [_button_1 setTag:101];
    [_button_1 setBackgroundImage:[UIImage imageNamed:@"icon_home_home"] forState:UIControlStateNormal];
    [_button_1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(64, 0, 64, 45)];
    [_button_2 setTag:102];
    [_button_2 setBackgroundImage:[UIImage imageNamed:@"icon_home_chat"] forState:UIControlStateNormal];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_center setFrame:CGRectMake(128, 0, 64, 45)];
    [_button_center setTag:105];
    [_button_center setBackgroundImage:[UIImage imageNamed:@"icon_home_post"] forState:UIControlStateNormal];
    [_button_center addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(192, 0, 64, 45)];
    [_button_3 setTag:103];
    [_button_3 setBackgroundImage:[UIImage imageNamed:@"icon_home_contact"] forState:UIControlStateNormal];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(256, 0, 64, 45)];
    [_button_4 setTag:104];
    [_button_4 setBackgroundImage:[UIImage imageNamed:@"icon_home_more"] forState:UIControlStateNormal];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigationBarView addSubview:_button_1];
    [_navigationBarView addSubview:_button_2];
    [_navigationBarView addSubview:_button_3];
    [_navigationBarView addSubview:_button_4];
    [_navigationBarView addSubview:_button_center];
    
}

-(void)btn1Click:(id)sender
{
        
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%i",btn.tag);
    switch (btn.tag) {
        case 101:
        {
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [_button_1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 102:
        {
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [_button_2 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [_button_3 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:3];
            break;
        case 104:
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            [_button_4 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:2];
            break;
        case 105:
            [_button_center setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_POST_VIEW object:nil];
            break;
        default:
            break;
    }
}

-(void)selectTabAtIndex:(int) index
{
    switch (index) {
        case 0:
        {
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [_button_1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 1:
        {
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [_button_2 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 2:
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [_button_3 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:3];
            break;
        case 3:
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            [_button_4 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [_button_center setBackgroundColor:[UIColor clearColor]];
            
            [self.delegate touchBtnAtIndex:2];
            break;
        case 4:
            [_button_center setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
            [_button_2 setBackgroundColor:[UIColor clearColor]];
            [_button_3 setBackgroundColor:[UIColor clearColor]];
            [_button_4 setBackgroundColor:[UIColor clearColor]];
            [_button_1 setBackgroundColor:[UIColor clearColor]];
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_POST_VIEW object:nil];
            break;
        default:
            break;
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
