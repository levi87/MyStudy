//
//  EmojiView.m
//  FreeBao
//
//  Created by ye bingwei on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EmojiView.h"

@implementation EmojiView


@synthesize delegate = delegate_;

-(void)buttonClick:(UIButton *)button
{
    Emoji *emoji = [emojis_ objectAtIndex:(button.tag-1)];
    if ([delegate_ respondsToSelector:@selector(emojiDidSelect:)]) 
    {
        [delegate_ emojiDidSelect:emoji];
    }
}

- (void)setup
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *keys = [dic allKeys];

    emojis_ = [[NSMutableArray alloc] init];
    for (NSString *name in keys)
    {
        Emoji *emoji = [[Emoji alloc] init];
        
        [emoji setText:name];
        [emoji setFileName:[dic objectForKey:name]];
        
        [emojis_ addObject:emoji];
    }
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView_];
    scrollView_.backgroundColor=[UIColor clearColor];
    
    CGFloat height = (([emojis_ count]+7)/8)*kEmojiHeigth;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, height)];
    for (int i = 0; i < ([emojis_ count]+7)/8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            NSInteger index = i*8+j;
            if (index >= [emojis_ count])
            {
                break;
            }
            
            Emoji *emoji = [emojis_ objectAtIndex:index];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index+1;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(j*40, i*40, 40, 40);
            [button setImage:[UIImage imageNamed:emoji.fileName] forState:UIControlStateNormal];
            if (button.imageView.image == nil) 
            {
                [button setEnabled:NO];
            }
            [v addSubview:button];
        }
    }
    [scrollView_ setContentSize:v.bounds.size];
    [scrollView_ addSubview:v];
}

- (id)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    if (self)
    {   
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {   
        [self setup];
    }
    return self;   
}

- (void)dealloc
{
    [scrollView_ setDelegate:nil];
    [scrollView_ removeFromSuperview];
}

@end
