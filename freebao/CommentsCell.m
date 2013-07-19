//
//  CommentsCell.m
//  freebao
//
//  Created by freebao on 13-7-4.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "CommentsCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"
#define PADDING_TOP 8.0
#define PADDING_LEFT 0.0

#define COMMENT_VOICE @"fb_comment_voice"

@implementation CommentsCell
@synthesize commentTextView = _commentTextView;
@synthesize upperView = _upperView;
@synthesize languageImageView = _languageImageView;
@synthesize transVoiceImageView = _transVoiceImageView;
@synthesize commentDateLabel = _commentDateLabel;
@synthesize soundImageView = _soundImageView;
@synthesize indexPath = _indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(9.0f, 9.0f, 40.0f, 40.0f);
		[self.contentView addSubview:headImageView];
        _upperView = [[UIView alloc] initWithFrame:CGRectMake(58, 9, 230, 50)];
        nickNameLabel = [[UILabel alloc] init];
        nickNameLabel.frame = CGRectMake(0, 0, 80, 16);
        nickNameLabel.text = @"levi";
        nickNameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [_upperView addSubview:nickNameLabel];
        _transVoiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 17, 13, 13)];
        [_transVoiceImageView setImage:[UIImage imageNamed:@"con-speek"]];
        _transVoiceImageView.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"con-speek02"],
                                                [UIImage imageNamed:@"con-speek04"],
                                                [UIImage imageNamed:@"con-speek06"],
                                                nil];
        [_upperView addSubview:_transVoiceImageView];
        _languageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 17, 21, 13)];
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
        [_upperView addSubview:_languageImageView];
        _commentDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 180, 15)];
        _commentDateLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [_upperView addSubview:_commentDateLabel];
        _commentTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 50, 230, 25)];
        [_commentTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_commentTextView setDelegate:self];
        [_commentTextView setFontName:FONT];
        [_commentTextView setFontSize:FONT_SIZE];
        [_commentTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_commentTextView setBackgroundColor:[UIColor clearColor]];
        [_commentTextView setPaddingTop:PADDING_TOP];
        [_commentTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _commentTextView.backgroundColor = [UIColor clearColor];
        _commentTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _commentTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _commentTextView.text = @"test message.";
        _soundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 52, 20, 20)];
        [_soundImageView setImage:[UIImage imageNamed:@"con-voice"]];
        _soundImageView.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"con-voice-01"],
                                           [UIImage imageNamed:@"con-voice-02"],
                                           [UIImage imageNamed:@"con-voice-03"],
                                           nil];
        _soundImageView.animationDuration = 1;
        _soundImageView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice)];
        tap.numberOfTapsRequired = 1;
        [_soundImageView addGestureRecognizer:tap];
        _soundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_soundImageView];
        [self.contentView addSubview:_commentTextView];
        [self.contentView addSubview:_upperView];
        
        [self initialize];
    }
    return self;
}

-(void)playVoice {
    NSLog(@"play comment voice...");
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self,@"cell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_VOICE object:tmpDic];
}

-(void)setCellValue:(CommentInfo *)info {
    NSLog(@".........");
    nickNameLabel.text = info.nickName;
    _commentTextView.text = info.content;
    _soundImageView.animationRepeatCount = [info.voiceLength integerValue];
    CGFloat tmpHeight = [CommentsCell getJSHeight:info.content jsViewWith:230];
    CGRect frame = _commentTextView.frame;
    frame.size.height = tmpHeight;
    _commentTextView.frame = frame;
    _commentDateLabel.text = info.commentDate;
    NSLog(@"info voice Url %@", info.voiceUrl);
    if (![info.voiceUrl isEqualToString:@"0"]) {
        _soundImageView.hidden = NO;
        _commentTextView.hidden = YES;
        _languageImageView.hidden = YES;
        _transVoiceImageView.hidden = YES;
    } else {
        _soundImageView.hidden = YES;
        _commentTextView.hidden = NO;
        _languageImageView.hidden = NO;
        _transVoiceImageView.hidden = NO;
    }
    //    if ([info.sex integerValue] == 0) {
    //        sexImageV.image = [UIImage imageNamed:@"sex-male.png"];
    //    } else {
    //        sexImageV.image = [UIImage imageNamed:@"sex-female.png"];
    //    }
    //    ageLabel.text = info.age;
    //    city.text = info.city;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // We need to set the contentView's background colour, otherwise the sides are clear on the swipe and animations
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:panGestureRecognizer];
    
    self.revealDirection = RMSwipeTableViewCellRevealDirectionBoth;
    self.animationType = RMSwipeTableViewCellAnimationTypeBounce;
    self.animationDuration = 0.2f;
    self.shouldAnimateCellReset = YES;
    self.backViewbackgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    self.panElasticity = YES;
    self.panElasticityStartingPoint = 0;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.shouldAnimateCellReset = YES;
}

-(void)setHeadPhoto:(NSString *)headPhoto {
    headImageView.imageURL = [NSURL URLWithString:headPhoto];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[headImageView cancelImageLoad];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Gesture recognizer delegate

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    // We only want to deal with the gesture of it's a pan gesture
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && self.revealDirection != RMSwipeTableViewCellRevealDirectionNone) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else {
        return NO;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    CGFloat panOffset = translation.x;
    if (self.panElasticity) {
        if (ABS(translation.x) > self.panElasticityStartingPoint) {
            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat offset = abs(translation.x);
            panOffset = (offset * 0.55f * width) / (offset * 0.55f + width);
            panOffset *= translation.x < 0 ? -1.0f : 1.0f;
            if (self.panElasticityStartingPoint > 0) {
                panOffset = translation.x > 0 ? panOffset + self.panElasticityStartingPoint / 2 : panOffset - self.panElasticityStartingPoint / 2;
            }
        }
    }
    CGPoint actualTranslation = CGPointMake(panOffset, translation.y);
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan && [panGestureRecognizer numberOfTouches] > 0) {
        [self didStartSwiping];
        [self animateContentViewForPoint:actualTranslation velocity:velocity];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged && [panGestureRecognizer numberOfTouches] > 0) {
        [self animateContentViewForPoint:actualTranslation velocity:velocity];
	} else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[self resetCellFromPoint:actualTranslation  velocity:velocity];
	}
}

-(void)didStartSwiping {
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCellDidStartSwiping:)]) {
        [self.delegate swipeTableViewCellDidStartSwiping:self];
    }
    [self.backgroundView addSubview:self.backView];
    [self.backView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
}

#pragma mark - Gesture animations

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if ((point.x > 0 && self.revealDirection == RMSwipeTableViewCellRevealDirectionLeft) || (point.x < 0 && self.revealDirection == RMSwipeTableViewCellRevealDirectionRight) || self.revealDirection == RMSwipeTableViewCellRevealDirectionBoth) {
        self.contentView.frame = CGRectOffset(self.contentView.bounds, point.x, 0);
        if ([self.delegate respondsToSelector:@selector(swipeTableViewCell:didSwipeToPoint:velocity:)]) {
            [self.delegate swipeTableViewCell:self didSwipeToPoint:point velocity:velocity];
        }
    } else if ((point.x > 0 && self.revealDirection == RMSwipeTableViewCellRevealDirectionRight) || (point.x < 0 && self.revealDirection == RMSwipeTableViewCellRevealDirectionLeft)) {
        self.contentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
    }
    if (point.x < 0) {
        // set the X's frame to match the contentView
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetHeight(self.deleteGreyImageView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame)) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCellWillResetState:fromPoint:animation:velocity:)]) {
        [self.delegate swipeTableViewCellWillResetState:self fromPoint:point animation:self.animationType velocity:velocity];
    }
    if (self.shouldAnimateCellReset == NO) {
        return;
    }
    if ((self.revealDirection == RMSwipeTableViewCellRevealDirectionLeft && point.x < 0) || (self.revealDirection == RMSwipeTableViewCellRevealDirectionRight && point.x > 0)) {
        return;
    }
    if (self.animationType == RMSwipeTableViewCellAnimationTypeBounce) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.contentView.frame = CGRectOffset(self.contentView.bounds, 0 - (point.x * 0.03), 0);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.contentView.frame = CGRectOffset(self.contentView.bounds, 0 + (point.x * 0.02), 0);
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.1
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveEaseOut
                                                                   animations:^{
                                                                       self.contentView.frame = self.contentView.bounds;
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       [self cleanupBackView];
                                                                       if ([self.delegate respondsToSelector:@selector(swipeTableViewCellDidResetState:fromPoint:animation:velocity:)]) {
                                                                           [self.delegate swipeTableViewCellDidResetState:self fromPoint:point animation:self.animationType velocity:velocity];
                                                                       }
                                                                   }
                                                   ];
                                              }
                              ];
                         }
         ];
    } else {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:self.animationType
                         animations:^{
                             self.contentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
                         }
                         completion:^(BOOL finished) {
                             [self cleanupBackView];
                             if ([self.delegate respondsToSelector:@selector(swipeTableViewCellDidResetState:fromPoint:animation:velocity:)]) {
                                 [self.delegate swipeTableViewCellDidResetState:self fromPoint:point animation:self.animationType velocity:velocity];
                             }
                         }
         ];
    }
    if (point.x < 0) {
        if (-point.x <= CGRectGetHeight(self.frame)) {
            // user did not swipe far enough, animate the grey X back with the contentView animation
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.deleteGreyImageView.frame), CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetHeight(self.deleteGreyImageView.frame))];
                             }];
        } else {
            // user did swipe far enough to meet the delete action requirement, animate the Xs to show selection
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteGreyImageView setAlpha:0];
                                 [self.deleteRedImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteRedImageView setAlpha:0];
                             }];
        }
    }
}

-(UIView*)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _backView.backgroundColor = self.backViewbackgroundColor;
    }
    return _backView;
}

-(void)cleanupBackView {
    [_backView removeFromSuperview];
    _backView = nil;
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
}

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_deleteGreyImageView setImage:[UIImage imageNamed:@"DeleteGrey"]];
        [_deleteGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_deleteGreyImageView];
    }
    return _deleteGreyImageView;
}

-(UIImageView*)deleteRedImageView {
    if (!_deleteRedImageView) {
        _deleteRedImageView = [[UIImageView alloc] initWithFrame:self.deleteGreyImageView.bounds];
        [_deleteRedImageView setImage:[UIImage imageNamed:@"DeleteRed"]];
        [_deleteRedImageView setContentMode:UIViewContentModeCenter];
        [self.deleteGreyImageView addSubview:_deleteRedImageView];
    }
    return _deleteRedImageView;
}

+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with
{
    CGFloat height = [JSCoreTextView measureFrameHeightForText:text
                                                      fontName:FONT
                                                      fontSize:FONT_SIZE
                                            constrainedToWidth:with - (PADDING_LEFT * 2)
                                                    paddingTop:PADDING_TOP
                                                   paddingLeft:PADDING_LEFT];
    return height;
}

@end
