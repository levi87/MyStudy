//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "EGOImageView.h"

#define IMAGE_TAP @"fb_image_tap"
#define HIDE_KEYBOARD @"fb_hide_keyboard"
#define VOICE_DATA @"fb_voice_data"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic, retain) EGOImageView *mapImageView;
@property (nonatomic, retain) UILabel *voiceLengthLabel;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize mapImageView = _mapImageView;
@synthesize voiceButton = _voiceButton;
@synthesize voiceLengthLabel = _voiceLengthLabel;
@synthesize voiceImageView = _voiceImageView;
@synthesize indexPath = _indexPath;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void)onSingleTap:(UIGestureRecognizer *)gestureR {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_TAP object:self.data.view];
}

- (void)hideKeyboardAndFaceV {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_KEYBOARD object:nil];
}

- (void)onSingleTapVoice {
    NSDictionary *tmpDic;
    if (self.data.isSelf) {
        tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self, @"cell", @"1", @"IsSelf", nil];
    } else {
        tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self, @"cell", @"0", @"IsSelf", nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:VOICE_DATA object:self.data.voiceData userInfo:tmpDic];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];
#endif
        [self addSubview:self.bubbleImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardAndFaceV)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.avatarImage.layer.cornerRadius = 9.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 2 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 50;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }

    [self.customView removeFromSuperview];
    [self.mapImageView removeFromSuperview];
    if (self.data.isMap) {
        self.mapImageView = self.data.mapView;
        self.mapImageView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, 220, 220);
        [self.contentView addSubview:self.mapImageView];
    } else if (self.data.isVoice) {
        if (_voiceImageView != nil) {
            NSLog(@"is nil...");
            return;
        }
        NSLog(@"create new button...");
        self.voiceButton = self.data.voiceButton;
        self.voiceButton.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, 80, 30);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTapVoice)];
        tap.numberOfTapsRequired = 1;
        _voiceLengthLabel = [[UILabel alloc] init];
        _voiceLengthLabel.frame = CGRectMake(40, 0, 40, 30);
        _voiceLengthLabel.text = [NSString stringWithFormat:@"%@ s", self.data.voiceLength];
        _voiceLengthLabel.backgroundColor = [UIColor clearColor];
        _voiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con-voice"]];
        _voiceImageView.frame = CGRectMake(5, 5, 20, 20);
        _voiceImageView.backgroundColor = [UIColor clearColor];
        _voiceImageView.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"con-voice-01"],
                                           [UIImage imageNamed:@"con-voice-02"],
                                           [UIImage imageNamed:@"con-voice-03"],
                                           nil];
        _voiceImageView.animationDuration = 1;
        _voiceImageView.animationRepeatCount = [self.data.voiceLength integerValue];
        if (self.data.isPlayAnimation) {
            [_voiceImageView startAnimating];
        }
        [self.voiceButton addSubview:_voiceImageView];
        [self.voiceButton addSubview:_voiceLengthLabel];
        [self.voiceButton addGestureRecognizer:tap];
        [self.contentView addSubview:self.voiceButton];
    } else {
        self.customView = self.data.view;
        self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        tap.numberOfTapsRequired = 1;
        [self.customView addGestureRecognizer:tap];
        [self.customView setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.customView];
    }

    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bg_chat_blue_normal.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];

    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bg_chat_white_normal.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    }

    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

@end
