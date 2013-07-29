//
//  StatusNewCell.m
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "StatusNewImageCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"
#define PADDING_TOP 8.0
#define PADDING_LEFT 0.0

#define COMMENT_VOICE @"fb_comment_voice"

@implementation StatusNewImageCell
@synthesize contentTextView = _contentTextView;
@synthesize upperView = _upperView;
@synthesize lowerView = _lowerView;
@synthesize languageImageView = _languageImageView;
@synthesize transVoiceImageView = _transVoiceImageView;
@synthesize commentDateLabel = _commentDateLabel;
@synthesize soundImageView = _soundImageView;
@synthesize indexPath = _indexPath;
@synthesize moreImageView = _moreImageView;
@synthesize likeImageView = _likeImageView;
@synthesize commentImageView = _commentImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(9.0f, 339.0f, 40.0f, 40.0f);
        mainImageView = [[EGOImageView alloc] init];
        mainImageView.frame = CGRectMake(0, 0, 320, 320);
        mainImageView.imageURL = [NSURL URLWithString:@"http://freebao.com//contentImg//20130704/2013070414072457290.jpg"];
        [self.contentView addSubview:mainImageView];
		[self.contentView addSubview:headImageView];
        _upperView = [[UIView alloc] initWithFrame:CGRectMake(58, 339, 230, 50)];
        _lowerView = [[UIView alloc] initWithFrame:CGRectMake(0, 339, 320, 20)];
        _moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 23, 7)];
        _moreImageView.image = [UIImage imageNamed:@"con-moredo.png"];
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 2, 18, 16)];
        _likeImageView.image = [UIImage imageNamed:@"con-like.png"];
        _commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 2, 18, 16)];
        _commentImageView.image = [UIImage imageNamed:@"con-comment.png"];
        [_lowerView addSubview:_moreImageView];
        [_lowerView addSubview:_likeImageView];
        [_lowerView addSubview:_commentImageView];
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
        _contentTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 380, 230, 25)];
        [_contentTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_contentTextView setDelegate:self];
        [_contentTextView setFontName:FONT];
        [_contentTextView setFontSize:FONT_SIZE];
        [_contentTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_contentTextView setBackgroundColor:[UIColor clearColor]];
        [_contentTextView setPaddingTop:PADDING_TOP];
        [_contentTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _contentTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _contentTextView.text = @"test message.";
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
        [self.contentView addSubview:_contentTextView];
        [self.contentView addSubview:_upperView];
        [self.contentView addSubview:_lowerView];
    }
    return self;
}

-(void)playVoice {
    NSLog(@"play comment voice...");
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self,@"cell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_VOICE object:tmpDic];
}

-(void)setCellValue:(CommentInfo *)info {
    nickNameLabel.text = info.nickName;
    _contentTextView.text = info.content;
    _soundImageView.animationRepeatCount = [info.voiceLength integerValue];
    CGFloat tmpHeight = [StatusNewImageCell getJSHeight:info.content jsViewWith:230];
    CGRect frame = _contentTextView.frame;
    frame.size.height = tmpHeight;
    _contentTextView.frame = frame;
    
    frame = _lowerView.frame;
    frame.origin.y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + 5;
    _lowerView.frame = frame;
    _commentDateLabel.text = info.commentDate;
    if (![info.voiceUrl isEqualToString:@"0"]) {
        _soundImageView.hidden = NO;
        _contentTextView.hidden = YES;
        _languageImageView.hidden = YES;
        _transVoiceImageView.hidden = YES;
    } else {
        _soundImageView.hidden = YES;
        _contentTextView.hidden = NO;
        _languageImageView.hidden = NO;
        _transVoiceImageView.hidden = NO;
    }
}

-(void)setHeadPhoto:(NSString *)headPhoto {
    headImageView.imageURL = [NSURL URLWithString:headPhoto];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[headImageView cancelImageLoad];
        [mainImageView cancelImageLoad];
	}
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
