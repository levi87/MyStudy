//
//  EmojiView.h
//  FreeBao
//
//  Created by ye bingwei on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"

#define kEmojiWidth     40.f    // 一行显示8个
#define kEmojiHeigth    40.f

@class EmojiView;
@protocol EmojiViewDelegate <NSObject>

-(void)emojiDidSelect:(Emoji *)aEmoji;

@end

@interface EmojiView : UIView
{
@private
    id<EmojiViewDelegate>   delegate_;
    
    UIScrollView            *scrollView_;
    NSMutableArray          *emojis_;
}

@property(nonatomic, retain) IBOutlet id<EmojiViewDelegate> delegate;

@end
