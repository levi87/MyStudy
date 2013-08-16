//
//  StatusNewCell.m
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "StatusNewCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDictionaryAdditions.h"

#define FONT_SIZE 16.0
#define FONT @"HelveticaNeue"
#define PADDING_TOP 8.0
#define PADDING_LEFT 0.0

#define COMMENT_VOICE @"fb_comment_voice"

@implementation StatusNewCell
@synthesize delegate = _delegate;
@synthesize contentTextView = _contentTextView;
@synthesize forwordContentTextView = _forwordContentTextView;
@synthesize upperView = _upperView;
@synthesize lowerView = _lowerView;
@synthesize languageImageView = _languageImageView;
@synthesize transVoiceImageView = _transVoiceImageView;
@synthesize statusDateLabel = _statusDateLabel;
@synthesize soundImageView = _soundImageView;
@synthesize indexPath = _indexPath;
@synthesize moreImageView = _moreImageView;
@synthesize likeImageView = _likeImageView;
@synthesize commentImageView = _commentImageView;
@synthesize locationImageView = _locationImageView;
@synthesize distanceLabel = _distanceLabel;
@synthesize statusInfo = _statusInfo;
@synthesize translateContentTextView = _translateContentTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		headImageView.frame = CGRectMake(8.0f, 8.0f, 40.0f, 40.0f);
		[self.contentView addSubview:headImageView];
        _upperView = [[UIView alloc] initWithFrame:CGRectMake(58, 9, 280, 50)];
        _lowerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _moreImageView.image = [UIImage imageNamed:@"icon_home_more_normal"];
        UITapGestureRecognizer *moreGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapAction)];
        moreGesTap.numberOfTapsRequired = 1;
        [_moreImageView addGestureRecognizer:moreGesTap];
        [_moreImageView setUserInteractionEnabled:YES];
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 0, 40, 40)];
        _likeImageView.image = [UIImage imageNamed:@"icon_home_favorite_off"];
        UITapGestureRecognizer *likeGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLikeTapAction)];
        likeGesTap.numberOfTapsRequired = 1;
        [_likeImageView addGestureRecognizer:likeGesTap];
        [_likeImageView setUserInteractionEnabled:YES];
        _commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 0, 40, 40)];
        UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction)];
        likeGesTap.numberOfTapsRequired = 1;
        [_commentImageView addGestureRecognizer:commentTap];
        [_commentImageView setUserInteractionEnabled:YES];
        _commentImageView.image = [UIImage imageNamed:@"icon_home_comment_normal"];
        [_lowerView addSubview:_moreImageView];
        [_lowerView addSubview:_likeImageView];
        [_lowerView addSubview:_commentImageView];
        nickNameLabel = [[UILabel alloc] init];
        nickNameLabel.frame = CGRectMake(0, 0, 80, 16);
        nickNameLabel.text = @"levi";
        nickNameLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [_upperView addSubview:nickNameLabel];
        _transVoiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 17, 13, 13)];
        UITapGestureRecognizer *transVoiceGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transVoiceTapAction)];
        transVoiceGesTap.numberOfTapsRequired = 1;
        [_transVoiceImageView addGestureRecognizer:transVoiceGesTap];
        [_transVoiceImageView setUserInteractionEnabled:YES];
        [_transVoiceImageView setImage:[UIImage imageNamed:@"con-speek"]];
        _transVoiceImageView.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"con-speek02"],
                                                [UIImage imageNamed:@"con-speek04"],
                                                [UIImage imageNamed:@"con-speek06"],
                                                nil];
        _transVoiceImageView.animationDuration = 1;
//        [_upperView addSubview:_transVoiceImageView];
        _languageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 17, 24, 16)];
        UITapGestureRecognizer *languageGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageSelectAction)];
        languageGesTap.numberOfTapsRequired = 1;
//        [_languageImageView addGestureRecognizer:languageGesTap];
        [_languageImageView setUserInteractionEnabled:YES];
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
        [_upperView addSubview:_languageImageView];
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(210, 10, 45, 30)];
        [arrowImage setImage:[UIImage imageNamed:@"icon_home_flagarrow_down"]];
        [arrowImage addGestureRecognizer:languageGesTap];
        [arrowImage setUserInteractionEnabled:YES];
        [_upperView addSubview:arrowImage];
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con-location.png"]];
        _locationImageView.frame = CGRectMake(0, 24, 15, 15);
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 43, 15)];
        UITapGestureRecognizer *distanceGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distanceTapAction)];
        distanceGesTap.numberOfTapsRequired = 1;
        [_distanceLabel addGestureRecognizer:distanceGesTap];
        [_distanceLabel setUserInteractionEnabled:YES];
        [_distanceLabel setFont:[UIFont fontWithName:FONT size:12]];
        [_distanceLabel setText:@"0.07km"];
        [_distanceLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
        _statusDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 120, 15)];
        _statusDateLabel.font = [UIFont fontWithName:FONT size:12];
        [_statusDateLabel setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [_upperView addSubview:_statusDateLabel];
        [_upperView addSubview:_locationImageView];
        [_upperView addSubview:_distanceLabel];
        
        _contentTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 50, 302, 25)];
        [_contentTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_contentTextView setDelegate:self];
        [_contentTextView setFontName:FONT];
        [_contentTextView setFontSize:FONT_SIZE];
        [_contentTextView setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        [_contentTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_contentTextView setBackgroundColor:[UIColor clearColor]];
        [_contentTextView setPaddingTop:PADDING_TOP];
        [_contentTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _contentTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _contentTextView.text = @"test message.";
        
        _forwordContentTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 50, 302, 25)];
        [_forwordContentTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_forwordContentTextView setDelegate:self];
        [_forwordContentTextView setFontName:FONT];
        [_forwordContentTextView setFontSize:FONT_SIZE];
        [_forwordContentTextView setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        [_forwordContentTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_forwordContentTextView setBackgroundColor:[UIColor clearColor]];
        [_forwordContentTextView setPaddingTop:PADDING_TOP];
        [_forwordContentTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _forwordContentTextView.backgroundColor = [UIColor clearColor];
        _forwordContentTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _forwordContentTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _forwordContentTextView.text = @"test message.";
        _forwordContentTextView.hidden = YES;
        
        _translateContentTextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(9, 50, 302, 25)];
        [_translateContentTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_translateContentTextView setDelegate:self];
        [_translateContentTextView setFontName:FONT];
        [_translateContentTextView setFontSize:FONT_SIZE];
        [_translateContentTextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_translateContentTextView setBackgroundColor:[UIColor clearColor]];
        [_translateContentTextView setPaddingTop:PADDING_TOP];
        [_translateContentTextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _translateContentTextView.backgroundColor = [UIColor clearColor];
        _translateContentTextView.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _translateContentTextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _translateContentTextView.text = @"test message.";
        _translateContentTextView.hidden = YES;
        
        _commentsView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, 302, 25)];
        _line1label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 60, 21)];
        [_line1label setText:@"Echo"];
        [_line1label setFont:[UIFont fontWithName:FONT size:FONT_SIZE]];
        [_line1label setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        _line1TextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(61, 2, 240, 21)];
        [_line1TextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line1TextView setDelegate:self];
        [_line1TextView setFontName:FONT];
        [_line1TextView setFontSize:FONT_SIZE];
        [_line1TextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line1TextView setBackgroundColor:[UIColor clearColor]];
        [_line1TextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _line1TextView.backgroundColor = [UIColor clearColor];
        _line1TextView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _line1TextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _line1TextView.text = @"test message.";
        _line2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 60, 21)];
        [_line2Label setText:@"Echo"];
        [_line2Label setFont:[UIFont fontWithName:FONT size:FONT_SIZE]];
        [_line2Label setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        _line2TextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(61, 24, 240, 21)];
        [_line2TextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line2TextView setDelegate:self];
        [_line2TextView setFontName:FONT];
        [_line2TextView setFontSize:FONT_SIZE];
        [_line2TextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line2TextView setBackgroundColor:[UIColor clearColor]];
        [_line2TextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _line2TextView.backgroundColor = [UIColor clearColor];
        _line2TextView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _line2TextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _line2TextView.text = @"test message.";
        _line3Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 60, 21)];
        [_line3Label setText:@"Echo"];
        [_line3Label setFont:[UIFont fontWithName:FONT size:FONT_SIZE]];
        [_line3Label setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        _line3TextView = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(61, 46, 240, 21)];
        [_line3TextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line3TextView setDelegate:self];
        [_line3TextView setFontName:FONT];
        [_line3TextView setFontSize:FONT_SIZE];
        [_line3TextView setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line3TextView setBackgroundColor:[UIColor clearColor]];
        [_line3TextView setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _line3TextView.backgroundColor = [UIColor clearColor];
        _line3TextView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _line3TextView.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        _line3TextView.text = @"test message.";
        [_commentsView addSubview:_line1label];
        [_commentsView addSubview:_line1TextView];
        [_commentsView addSubview:_line2Label];
        [_commentsView addSubview:_line2TextView];
        [_commentsView addSubview:_line3Label];
        [_commentsView addSubview:_line3TextView];
        _commentsView.hidden = YES;
        
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 2, 25, 21)];
        UITapGestureRecognizer *likerGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likerTapAction)];
        likerGesTap.numberOfTapsRequired = 1;
        [likeLabel addGestureRecognizer:likerGesTap];
        [likeLabel setUserInteractionEnabled:YES];
        [likeLabel setText:@"Like"];
        [likeLabel setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        [likeLabel setFont:[UIFont systemFontOfSize:12]];
        [likeLabel setBackgroundColor:[UIColor clearColor]];
        _likeCount = [[UILabel alloc] initWithFrame:CGRectMake(34, 2, 17, 21)];
        [_likeCount setText:@"10"];
        [_likeCount setFont:[UIFont systemFontOfSize:12]];
        [_likeCount setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        [_likeCount setBackgroundColor:[UIColor clearColor]];
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, 56, 21)];
        UITapGestureRecognizer *commentGesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction)];
        commentGesTap.numberOfTapsRequired = 1;
        [commentLabel addGestureRecognizer:commentGesTap];
        [commentLabel setUserInteractionEnabled:YES];
        [commentLabel setText:@"Comment"];
        [commentLabel setFont:[UIFont systemFontOfSize:12]];
        [commentLabel setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        _commentCount = [[UILabel alloc] initWithFrame:CGRectMake(121, 2, 17, 21)];
        [_commentCount setText:@"10"];
        [_commentCount setFont:[UIFont systemFontOfSize:12]];
        [_commentCount setTextColor:[UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]];
        [_commentCount setBackgroundColor:[UIColor clearColor]];
        [_middleView addSubview:likeLabel];
        [_middleView addSubview:commentLabel];
        [_middleView addSubview:_likeCount];
        [_middleView addSubview:_commentCount];
        
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
        [self.contentView addSubview:_forwordContentTextView];
        [self.contentView addSubview:_upperView];
        [self.contentView addSubview:_lowerView];
        [self.contentView addSubview:_middleView];
        [self.contentView addSubview:_commentsView];
        [self.contentView addSubview:_translateContentTextView];
    }
    return self;
}

-(void)playVoice {
    NSLog(@"play comment voice...");
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:self,@"cell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_VOICE object:tmpDic];
}

-(void)showTranslateTextView:(NSString *)content StatusInfo:(StatusInfo *)status{
    CGFloat transHeight = [StatusNewCell getJSHeight:content jsViewWith:300];
    _translateContentTextView.hidden = NO;
    _translateContentTextView.text = content;
    if (status.rePostDic != nil) {
        NSLog(@"has rePost");
        NSArray *commentAy = status.commentArray;
        NSDictionary *tmpCommDic;
        CGRect frame = _translateContentTextView.frame;
        frame.size.height = transHeight;
        frame.origin.y = _forwordContentTextView.frame.origin.y + _forwordContentTextView.frame.size.height + 5;
        _translateContentTextView.frame = frame;
        
        frame = _middleView.frame;
        frame.origin.y = _translateContentTextView.frame.origin.y + _translateContentTextView.frame.size.height + 5;
        _middleView.frame = frame;
        
        NSInteger cCount = [status.commentCount integerValue];
        if (cCount == 0) {
            _commentsView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y;
            frame.size.height = _middleView.frame.size.height;
            _commentsView.frame = frame;
        } else if (cCount == 1) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = YES;
            _line2TextView.hidden = YES;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 25;
            _commentsView.frame = frame;
        } else if (cCount == 2) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 50;
            _commentsView.frame = frame;
        } else if (cCount >= 3) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:2];
            _line3Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line3TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = NO;
            _line3TextView.hidden = NO;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 75;
            _commentsView.frame = frame;
        }
        
        frame = _lowerView.frame;
        frame.origin.y = _commentsView.frame.origin.y + _commentsView.frame.size.height + 5;
        _lowerView.frame = frame;
    } else {
        NSArray *commentAy = status.commentArray;
        NSDictionary *tmpCommDic;
        CGRect frame = _translateContentTextView.frame;
        frame.size.height = transHeight;
        frame.origin.y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + 5;
        _translateContentTextView.frame = frame;
        
        frame = _middleView.frame;
        frame.origin.y = _translateContentTextView.frame.origin.y + _translateContentTextView.frame.size.height + 5;
        _middleView.frame = frame;
        
        NSInteger cCount = [status.commentCount integerValue];
        if (cCount == 0) {
            _commentsView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y;
            frame.size.height = _middleView.frame.size.height;
            _commentsView.frame = frame;
        } else if (cCount == 1) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = YES;
            _line2TextView.hidden = YES;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 25;
            _commentsView.frame = frame;
        } else if (cCount == 2) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 50;
            _commentsView.frame = frame;
        } else if (cCount >= 3) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:2];
            _line3Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line3TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = NO;
            _line3TextView.hidden = NO;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 75;
            _commentsView.frame = frame;
        }
        
        frame = _lowerView.frame;
        frame.origin.y = _commentsView.frame.origin.y + _commentsView.frame.size.height + 5;
        _lowerView.frame = frame;
    }
}

-(void)setCellValue:(StatusInfo *)info {
    _translateContentTextView.hidden = YES;
    _statusInfo = info;
    if ([info.postLanguage isEqualToString:@"zh_CN"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
    } else if ([info.postLanguage isEqualToString:@"en_US"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
    } else if ([info.postLanguage isEqualToString:@"fr_FR"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
    } else if ([info.postLanguage isEqualToString:@"hi_IN"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
    } else if ([info.postLanguage isEqualToString:@"ja_JP"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
    } else if ([info.postLanguage isEqualToString:@"ru_RU"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
    } else if ([info.postLanguage isEqualToString:@"es_ES"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
    } else if ([info.postLanguage isEqualToString:@"ko_KR"]) {
        [_languageImageView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
    }
    if (info.isPlayingVoice) {
        [_transVoiceImageView startAnimating];
    } else {
        [_transVoiceImageView stopAnimating];
    }
    if ([info.liked integerValue] == 1) {
        _likeImageView.image = [UIImage imageNamed:@"icon_home_favorite_on"];
    } else {
        _likeImageView.image = [UIImage imageNamed:@"icon_home_favorite_off"];
    }
    _distanceLabel.text = [NSString stringWithFormat:@"%@km",info.distance];
    _likeCount.text = [NSString stringWithFormat:@"%@",info.likeCount];
    _commentCount.text = [NSString stringWithFormat:@"%@",info.commentCount];
    NSArray *commentAy = info.commentArray;
    NSDictionary *tmpCommDic;
//    NSLog(@"statusNew %@", info.commentArray);
    nickNameLabel.text = info.userFacePath;
    _contentTextView.text = info.content;
//    _soundImageView.animationRepeatCount = [info.voiceLength integerValue];
    CGFloat tmpHeight = [StatusNewCell getJSHeight:info.content jsViewWith:300];
    CGRect frame = _contentTextView.frame;
    frame.size.height = tmpHeight;
    _contentTextView.frame = frame;
    if (info.rePostDic != nil) {
        _forwordContentTextView.hidden = NO;
        NSDictionary *tmpForword = info.rePostDic;
        CGFloat forwordHeight = [StatusNewCell getJSHeight:[tmpForword getStringValueForKey:@"text" defaultValue:@""] jsViewWith:300];
        CGRect forwordFrame = _forwordContentTextView.frame;
        forwordFrame.origin.y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height;
        forwordFrame.size.height = forwordHeight;
        _forwordContentTextView.frame = forwordFrame;
        NSString *nickName = [tmpForword getStringValueForKey:@"user_name" defaultValue:@""];
        _forwordContentTextView.text = [NSString stringWithFormat:@"@%@ %@",nickName,[tmpForword getStringValueForKey:@"text" defaultValue:@""]];
        
        frame = _middleView.frame;
        frame.origin.y = _forwordContentTextView.frame.origin.y + _forwordContentTextView.frame.size.height + 5;
        _middleView.frame = frame;

        NSInteger cCount = [info.commentCount integerValue];
        if (cCount == 0) {
            _commentsView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y;
            frame.size.height = _middleView.frame.size.height;
            _commentsView.frame = frame;
        } else if (cCount == 1) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = YES;
            _line2TextView.hidden = YES;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 25;
            _commentsView.frame = frame;
        } else if (cCount == 2) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 50;
            _commentsView.frame = frame;
        } else if (cCount >= 3) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:2];
            _line3Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line3TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = NO;
            _line3TextView.hidden = NO;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 75;
            _commentsView.frame = frame;
        }
        
        frame = _lowerView.frame;
        frame.origin.y = _commentsView.frame.origin.y + _commentsView.frame.size.height + 5;
        _lowerView.frame = frame;
    } else {
        _forwordContentTextView.hidden = YES;
        
        frame = _middleView.frame;
        frame.origin.y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + 5;
        _middleView.frame = frame;
        
        NSInteger cCount = [info.commentCount integerValue];
        if (cCount == 0) {
            _commentsView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y;
            frame.size.height = _middleView.frame.size.height;
            _commentsView.frame = frame;
        } else if (cCount == 1) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = YES;
            _line2TextView.hidden = YES;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 25;
            _commentsView.frame = frame;
        } else if (cCount == 2) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = YES;
            _line3TextView.hidden = YES;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 50;
            _commentsView.frame = frame;
        } else if (cCount >= 3) {
            tmpCommDic = [commentAy objectAtIndex:0];
            _line1label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line1TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:1];
            _line2Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line2TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            tmpCommDic = [commentAy objectAtIndex:2];
            _line3Label.text = [tmpCommDic getStringValueForKey:@"nickname" defaultValue:@""];
            _line3TextView.text = [tmpCommDic getStringValueForKey:@"commentBody" defaultValue:@""];
            _commentsView.hidden = NO;
            _line1label.hidden = NO;
            _line1TextView.hidden = NO;
            _line2Label.hidden = NO;
            _line2TextView.hidden = NO;
            _line3Label.hidden = NO;
            _line3TextView.hidden = NO;
            frame = _commentsView.frame;
            frame.origin.y = _middleView.frame.origin.y + _middleView.frame.size.height + 5;
            frame.size.height = 75;
            _commentsView.frame = frame;
        }
        
        frame = _lowerView.frame;
        frame.origin.y = _commentsView.frame.origin.y + _commentsView.frame.size.height + 5;
        _lowerView.frame = frame;
    }
    
    _statusDateLabel.text = info.createAt;
    if ([[EGOImageLoader sharedImageLoader] hasLoadedImageURL:[NSURL URLWithString:info.userFacePath]]) {
        headImageView.image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:info.userFacePath] shouldLoadWithObserver:nil];
    } else {
        headImageView.imageURL = [NSURL URLWithString:info.userFacePath];
    }
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

-(void)addLikeTapAction {
    if ([_delegate respondsToSelector:@selector(cellAddLikeDidTaped:)])
    {
        NSInteger isLiked = [_statusInfo.liked integerValue];
        if (isLiked == 1) {
            _statusInfo.liked = @"0";
            _statusInfo.likeCount = [NSString stringWithFormat:@"%d",[_statusInfo.likeCount integerValue] - 1];
            _likeCount.text = _statusInfo.likeCount;
            _likeImageView.image = [UIImage imageNamed:@"icon_home_favorite_off"];
        } else {
            _statusInfo.liked = @"1";
            _statusInfo.likeCount = [NSString stringWithFormat:@"%d",[_statusInfo.likeCount integerValue] + 1];
            _likeCount.text = _statusInfo.likeCount;
            _likeImageView.image = [UIImage imageNamed:@"icon_home_favorite_on"];
        }
        [_delegate cellAddLikeDidTaped:self];
    }
}

-(void)moreTapAction {
    if ([_delegate respondsToSelector:@selector(cellMoreDidTaped:)])
    {
        [_delegate cellMoreDidTaped:self];
    }
}

-(void)likerTapAction {
    if ([_delegate respondsToSelector:@selector(cellLikerDidTaped:)])
    {
        [_delegate cellLikerDidTaped:self];
    }
}

-(void)commentTapAction {
    if ([_delegate respondsToSelector:@selector(cellCommentDidTaped:)])
    {
        [_delegate cellCommentDidTaped:self];
    }
}

-(void)distanceTapAction {
    if ([_delegate respondsToSelector:@selector(cellDistanceDidTaped:)])
    {
        [_delegate cellDistanceDidTaped:self];
    }
}

-(void)transVoiceTapAction {
    if ([_delegate respondsToSelector:@selector(cellTransVoiceDidTaped:)])
    {
        if (_statusInfo.isPlayingVoice) {
            _statusInfo.isPlayingVoice = NO;
            [_transVoiceImageView stopAnimating];
        } else {
            _statusInfo.isPlayingVoice = YES;
            [_transVoiceImageView startAnimating];
        }
        [_delegate cellTransVoiceDidTaped:self];
    }
}

-(void)languageSelectAction {
    if ([_delegate respondsToSelector:@selector(cellLanguageDidTaped:)])
    {
        [_delegate cellLanguageDidTaped:self];
    }
}

@end
