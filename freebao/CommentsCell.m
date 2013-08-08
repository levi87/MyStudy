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
@synthesize delegate = _delegate;
@synthesize commentInfo = _commentInfo;
@synthesize translateTextView = _translateTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(9.0f, 9.0f, 40.0f, 40.0f);
		[self.contentView addSubview:headImageView];
        _upperView = [[UIView alloc] initWithFrame:CGRectMake(58, 9, 260, 50)];
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
        _transVoiceImageView.animationDuration = 1;
//        [_upperView addSubview:_transVoiceImageView];
        [_transVoiceImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapTransVoice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transVoiceTapAction)];
        tapTransVoice.numberOfTapsRequired = 1;
        [_transVoiceImageView addGestureRecognizer:tapTransVoice];
        _languageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 17, 21, 13)];
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
        UITapGestureRecognizer *tapLanguage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageSelectTapAction)];
        tapLanguage.numberOfTapsRequired = 1;
        [_languageImageView addGestureRecognizer:tapLanguage];
        [_languageImageView setUserInteractionEnabled:YES];
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
        
        _translateTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 50, 230, 25)];
        [_translateTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_translateTextView setDelegate:self];
        [_translateTextView setFontName:FONT];
        [_translateTextView setFontSize:FONT_SIZE];
        [_translateTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_translateTextView setBackgroundColor:[UIColor clearColor]];
        [_translateTextView setPaddingTop:PADDING_TOP];
        [_translateTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _translateTextView.backgroundColor = [UIColor clearColor];
        _translateTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _translateTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _translateTextView.text = @"test message.";
        _translateTextView.hidden = YES;
        
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
        [self.contentView addSubview:_translateTextView];
        
        [self initialize];
    }
    return self;
}

-(void)showTranslateTextView:(NSString *)content StatusInfo:(CommentInfo *)info {
    CGFloat transHeight = [CommentsCell getJSHeight:content jsViewWith:300];
    _translateTextView.hidden = NO;
    _translateTextView.text = content;
    CGRect frame = _translateTextView.frame;
    frame.size.height = transHeight;
    frame.origin.y = _commentTextView.frame.origin.y + _commentTextView.frame.size.height + 5;
    _translateTextView.frame = frame;
}

-(void)transVoiceTapAction {
    if ([_delegate respondsToSelector:@selector(cellTransVoiceDidTaped:)])
    {
        if (_commentInfo.isPlayingVoice) {
            _commentInfo.isPlayingVoice = NO;
            [_transVoiceImageView stopAnimating];
        } else {
            _commentInfo.isPlayingVoice = YES;
            [_transVoiceImageView startAnimating];
        }
        [_delegate cellTransVoiceDidTaped:self];
    }
}

-(void)playVoice {
    NSLog(@"play comment voice...");
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self,@"cell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_VOICE object:tmpDic];
}

-(void)setCellValue:(CommentInfo *)info {
    _commentInfo = info;
    if (info.isPlayingVoice) {
        [_transVoiceImageView startAnimating];
    } else {
        [_transVoiceImageView stopAnimating];
    }
    nickNameLabel.text = info.nickName;
    _commentTextView.text = info.content;
    _soundImageView.animationRepeatCount = [info.voiceLength integerValue];
    CGFloat tmpHeight = [CommentsCell getJSHeight:info.content jsViewWith:230];
    CGRect frame = _commentTextView.frame;
    frame.size.height = tmpHeight;
    _commentTextView.frame = frame;
    _commentDateLabel.text = info.commentDate;
    if (![info.voiceUrl isEqualToString:@"0"]) {
        _soundImageView.hidden = NO;
        _commentTextView.hidden = YES;
        _languageImageView.hidden = YES;
//        _transVoiceImageView.hidden = YES;
    } else {
        _soundImageView.hidden = YES;
        _commentTextView.hidden = NO;
        _languageImageView.hidden = NO;
//        _transVoiceImageView.hidden = NO;
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
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;
}

-(void)prepareForReuse {
    [super prepareForReuse];
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

-(void)languageSelectTapAction {
    NSLog(@"select language");
    if ([_delegate respondsToSelector:@selector(cellLanguageDidTaped:)])
    {
        [_delegate cellLanguageDidTaped:self];
    }
}

@end
