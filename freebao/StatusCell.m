//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"
#import "AHMarkedHyperlink.h"

#define NO_COMMNET 0
#define COMMENT_COUNT_ONE 1
#define COMMENT_COUNT_TWO 2
#define COMMNET_COUNT_THREE 3

@implementation StatusCell
@synthesize retwitterContentTF;
@synthesize avatarImage;
@synthesize contentTF;
@synthesize translateContentTF;
@synthesize userNameLB;
@synthesize retwitterMainV;
@synthesize delegate;
@synthesize cellIndexPath;
@synthesize fromLB;
@synthesize timeLB;
@synthesize JSContentTF = _JSContentTF;
@synthesize JSRetitterContentTF = _JSRetitterContentTF;
@synthesize mainImageView;
@synthesize commentToolBarView;
@synthesize line1Comment = _line1Comment;
@synthesize line2Comment = _line2Comment;
@synthesize line3Comment = _line3Comment;
@synthesize likeCount;
@synthesize comtCount;
@synthesize distanceLabel;
@synthesize addLikeIconImage;
@synthesize tmpPoint = _tmpPoint;
@synthesize playTranslateVoiceImageView = _playTranslateVoiceImageView;
@synthesize soundPath = _soundPath;
@synthesize languageStr = _languageStr;
@synthesize voiceImage = _voiceImage;

-(JSTwitterCoreTextView*)JSContentTF
{
    
    if (_JSContentTF == nil) {
        _JSContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(0, 20, 308, 80)];
        [_JSContentTF setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_JSContentTF setDelegate:self];
        [_JSContentTF setFontName:FONT];
        [_JSContentTF setFontSize:FONT_SIZE];
        [_JSContentTF setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_JSContentTF setBackgroundColor:[UIColor clearColor]];
        [_JSContentTF setPaddingTop:PADDING_TOP];
        [_JSContentTF setPaddingLeft:PADDING_LEFT];
//        _JSContentTF.userInteractionEnabled = NO;
        _JSContentTF.backgroundColor = [UIColor clearColor];
        _JSContentTF.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _JSContentTF.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.contentView addSubview:_JSContentTF];
    }
//    [self setCellLayout:YES];
    return _JSContentTF;
}

- (void)playVoice {
    if ([delegate respondsToSelector:@selector(cellPlaySoundTaped:)])
    {
        [delegate cellPlaySoundTaped:self];
    }
}

- (void)setCellLayout:(BOOL)value {
    if (value) {
        self.mainImageView.frame = CGRectMake(0, 0, 320, 320);
        [self.mainImageView setHidden:NO];
        self.HeadView.frame = CGRectMake(0, 323, 320, 40);
        CGRect frameJS = _JSContentTF.frame;
        frameJS.origin.y = 360;
        
        _JSContentTF.frame = frameJS;
    } else {
        [self.mainImageView setHidden:YES];
        self.HeadView.frame = CGRectMake(0, 3, 320, 40);
        CGRect frameJS = _JSContentTF.frame;
        frameJS.origin.y = 38;
        
        _JSContentTF.frame = frameJS;
    }
}

-(JSTwitterCoreTextView*)JSRetitterContentTF
{    
    if (_JSRetitterContentTF == nil) {
        _JSRetitterContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(0, 0, 308, 80)];
        [_JSRetitterContentTF setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_JSRetitterContentTF setDelegate:self];
        [_JSRetitterContentTF setFontName:FONT];
        [_JSRetitterContentTF setFontSize:FONT_SIZE];
        [_JSRetitterContentTF setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_JSRetitterContentTF setBackgroundColor:[UIColor clearColor]];
        [_JSRetitterContentTF setPaddingTop:PADDING_TOP];
        [_JSRetitterContentTF setPaddingLeft:PADDING_LEFT];
//        _JSRetitterContentTF.userInteractionEnabled = NO;
        _JSRetitterContentTF.backgroundColor = [UIColor clearColor];
        _JSRetitterContentTF.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _JSRetitterContentTF.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.retwitterMainV addSubview:_JSRetitterContentTF];
    }
    
    return _JSRetitterContentTF;
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

-(void)adjustTheHeightOf:(JSTwitterCoreTextView *)jsView withText:(NSString*)text
{
    CGFloat height = [StatusCell getJSHeight:text jsViewWith:jsView.frame.size.width];
    CGRect textFrame = [jsView frame];
    textFrame.size.height = height;
    [jsView setFrame:textFrame];
}

-(void)updateCellTextWith:(Status*)status
{
    if (voiceView == nil) {
        voiceView = [[UIView alloc] initWithFrame:CGRectMake(250, 10, 60, 30)];
        _voiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 24, 24)];
        _voiceImage.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"con-voice-01"],
                                       [UIImage imageNamed:@"con-voice-02"],
                                       [UIImage imageNamed:@"con-voice-03"],
                                       nil];
        _voiceImage.animationDuration = 1;
        _voiceImage.animationRepeatCount = [status.soundLength integerValue];
        [_voiceImage setImage:[UIImage imageNamed:@"con-voice-images"]];
        [voiceView addSubview:_voiceImage];
        UILabel *voiceLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 30, 15)];
        voiceLengthLabel.text = @"30 s";
        voiceLengthLabel.backgroundColor = [UIColor clearColor];
        voiceLengthLabel.font = [UIFont systemFontOfSize:13.0];
        [voiceLengthLabel setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
        [voiceView addSubview:voiceLengthLabel];
        [voiceView setBackgroundColor:[UIColor clearColor]];
        [voiceView setAlpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice)];
        tap.numberOfTapsRequired = 1;
        [voiceView addGestureRecognizer:tap];
        [voiceView setUserInteractionEnabled:YES];
        [self.mainImageView addSubview:voiceView];
    }

    _languageStr = status.language;
    if ([_languageStr isEqualToString:@"zh_CN"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
    } else if ([_languageStr isEqualToString:@"en_US"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_e"]];
    } else if ([_languageStr isEqualToString:@"fr_FR"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_f"]];
    } else if ([_languageStr isEqualToString:@"hi_IN"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_cn"]];
    } else if ([_languageStr isEqualToString:@"ja_JP"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_j"]];
    } else if ([_languageStr isEqualToString:@"ru_RU"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_p"]];
    } else if ([_languageStr isEqualToString:@"es_ES"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_x"]];
    } else if ([_languageStr isEqualToString:@"ko_KR"]) {
        [self.languageTypeView setImage:[UIImage imageNamed:@"icon_chat_flag_k"]];
    }
    _soundPath = status.soundPath;
    _playTranslateVoiceImageView.animationImages = [NSArray arrayWithObjects:
                                                    [UIImage imageNamed:@"con-speek02"],
                                                    [UIImage imageNamed:@"con-speek04"],
                                                    [UIImage imageNamed:@"con-speek06"],
                                                    nil];
    _playTranslateVoiceImageView.animationDuration = 1;
    if (status.isPlayTransVoice) {
        [_playTranslateVoiceImageView startAnimating];
    } else {
        [_playTranslateVoiceImageView stopAnimating];
    }
    self.contentTF.text = status.text;
    self.JSContentTF.text = status.text;
    self.userNameLB.text = status.user.screenName;
    _tmpPoint.x = status.latitude;
    _tmpPoint.y = status.longitude;

    timeLB.text = status.createdAt;
    
    Status  *retwitterStatus    = status.retweetedStatus;
    
    BOOL haveImage = NO;
    
    //有转发
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]]) 
    {
        self.retwitterMainV.hidden = NO;
        self.JSRetitterContentTF.text = [NSString stringWithFormat:@"@%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text];
        
        NSString *url = status.retweetedStatus.thumbnailPic;
//        self.retwitterContentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        if (status.hasImage) {
            [self setCellLayout:YES];
        } else {
            [self setCellLayout:NO];
        }
        [self setTFHeightWithImage:NO
                haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO Status:status];//计算cell的高度，以及背景图的处理
    }
    
    //无转发
    else
    {
        self.retwitterMainV.hidden = YES;
        NSString *url = status.thumbnailPic;
//        self.contentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        if (status.hasImage) {
            [self setCellLayout:YES];
        } else {
            [self setCellLayout:NO];
        }
        [self setTFHeightWithImage:url != nil && [url length] != 0 ? YES : NO 
                haveRetwitterImage:NO Status:status];//计算cell的高度，以及背景图的处理
    }
    
    if (_line1Comment == nil) {
        _line1Comment = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(76, 20, 230, 21)];
        [_line1Comment setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line1Comment setDelegate:self];
        [_line1Comment setFontName:FONT];
        [_line1Comment setFontSize:FONT_SIZE];
        [_line1Comment setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line1Comment setBackgroundColor:[UIColor clearColor]];
        [_line1Comment setPaddingTop:0];
        [_line1Comment setPaddingLeft:0];
        //        _JSRetitterContentTF.userInteractionEnabled = NO;
        _line1Comment.backgroundColor = [UIColor clearColor];
        _line1Comment.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _line1Comment.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.CommentView addSubview:_line1Comment];
    }
    if (_line2Comment == nil) {
        _line2Comment = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(76, 40, 230, 21)];
        [_line2Comment setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line2Comment setDelegate:self];
        [_line2Comment setFontName:FONT];
        [_line2Comment setFontSize:FONT_SIZE];
        [_line2Comment setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line2Comment setBackgroundColor:[UIColor clearColor]];
        [_line2Comment setPaddingTop:0];
        [_line2Comment setPaddingLeft:0];
        //        _JSRetitterContentTF.userInteractionEnabled = NO;
        _line2Comment.backgroundColor = [UIColor clearColor];
        _line2Comment.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _line2Comment.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.CommentView addSubview:_line2Comment];
    }
    if (_line3Comment == nil) {
        _line3Comment = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(76, 60, 230, 21)];
        [_line3Comment setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_line3Comment setDelegate:self];
        [_line3Comment setFontName:FONT];
        [_line3Comment setFontSize:FONT_SIZE];
        [_line3Comment setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_line3Comment setBackgroundColor:[UIColor clearColor]];
        [_line3Comment setPaddingTop:0];
        [_line3Comment setPaddingLeft:0];
        //        _JSRetitterContentTF.userInteractionEnabled = NO;
        _line3Comment.backgroundColor = [UIColor clearColor];
        _line3Comment.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _line3Comment.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.CommentView addSubview:_line3Comment];
    }
    _line1Comment.text = @"";
    _line2Comment.text = @"";
    _line3Comment.text = @"";
//    [self.CommentView setHidden:YES];
//    int commentCount = 3;
    int commentCount = status.commentsCount;
    likeCount.text = [NSString stringWithFormat:@"%d", status.likeCount];
    comtCount.text = [NSString stringWithFormat:@"%d", commentCount];
    distanceLabel.text = [NSString stringWithFormat:@"%@ km", status.distance];
    _isLiked = status.favorited;
    if (status.favorited) {
        addLikeIconImage.image = [UIImage imageNamed:@"con-liked.png"];
    } else {
        addLikeIconImage.image = [UIImage imageNamed:@"con-like.png"];
    }
    if (commentCount > 3) {
        commentCount = 3;
    }
    if (commentCount == NO_COMMNET) {
        CGRect tmpF = self.CommentView.frame;
        tmpF.origin.y = self.iconMoreImageView.frame.origin.y - 25;
        tmpF.size.height = 25;
        _line1Comment.hidden = YES;
        _line2Comment.hidden = YES;
        _line3Comment.hidden = YES;
        self.line1Label.hidden = YES;
        self.line2Label.hidden = YES;
        self.line3Label.hidden = YES;
        self.CommentView.frame = tmpF;
    } else if (commentCount == COMMENT_COUNT_ONE) {
        NSDictionary *tmpDic = [status.homeLineComments objectAtIndex:0];
        _line1Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line1Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line1Comment.text.length > 30) {
            _line1Comment.text = [[_line1Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        CGRect tmpF = self.CommentView.frame;
        tmpF.origin.y = self.iconMoreImageView.frame.origin.y - 50;
        tmpF.size.height = 50;
        _line1Comment.hidden = NO;
        _line2Comment.hidden = YES;
        _line3Comment.hidden = YES;
        self.line1Label.hidden = NO;
        self.line2Label.hidden = YES;
        self.line3Label.hidden = YES;
        self.CommentView.frame = tmpF;
    } else if (commentCount == COMMENT_COUNT_TWO) {
        NSDictionary *tmpDic = [status.homeLineComments objectAtIndex:0];
        _line1Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line1Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line1Comment.text.length > 30) {
            _line1Comment.text = [[_line1Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        tmpDic = [status.homeLineComments objectAtIndex:1];
        _line2Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line2Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line2Comment.text.length > 30) {
            _line2Comment.text = [[_line2Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        CGRect tmpF = self.CommentView.frame;
        tmpF.origin.y = self.iconMoreImageView.frame.origin.y - 70;
        tmpF.size.height = 70;
        _line1Comment.hidden = NO;
        _line2Comment.hidden = NO;
        _line3Comment.hidden = YES;
        self.line1Label.hidden = NO;
        self.line2Label.hidden = NO;
        self.line3Label.hidden = YES;
        self.CommentView.frame = tmpF;
    } else if (commentCount == COMMNET_COUNT_THREE) {
        NSDictionary *tmpDic = [status.homeLineComments objectAtIndex:0];
        _line1Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line1Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line1Comment.text.length > 30) {
            _line1Comment.text = [[_line1Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        tmpDic = [status.homeLineComments objectAtIndex:1];
        _line2Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line2Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line2Comment.text.length > 30) {
            _line2Comment.text = [[_line2Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        tmpDic = [status.homeLineComments objectAtIndex:2];
        _line3Comment.text = [tmpDic objectForKey:@"commentBody"];
        _line3Label.text = [tmpDic objectForKey:@"nickname"];
        if (_line3Comment.text.length > 30) {
            _line3Comment.text = [[_line3Comment.text substringToIndex:30] stringByAppendingString:@"..."];
        }
        CGRect tmpF = self.CommentView.frame;
        tmpF.origin.y = self.iconMoreImageView.frame.origin.y - 85;
        tmpF.size.height = 85;
        _line1Comment.hidden = NO;
        _line2Comment.hidden = NO;
        _line3Comment.hidden = NO;
        self.line1Label.hidden = NO;
        self.line2Label.hidden = NO;
        self.line3Label.hidden = NO;
        self.CommentView.frame = tmpF;
    }
    if (status.isFakeWeibo) {
        NSLog(@"....FAKE IMAGE........");
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self returnFilePath:@"tmpShareJPEG@2x.jpg"]]];
        imageV.frame = self.mainImageView.frame;
        [self.mainImageView addSubview:imageV];
    }
}

-(NSString *)returnFilePath:(NSString*)nameStr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:nameStr];
    
    return filePath;
}

-(void)setCommentPosition:(CGFloat)height {
    NSLog(@"[levi] _JSContent y + height %f", _JSContentTF.frame.origin.y + _JSContentTF.frame.size.height);
    CGRect tmpframe = self.CommentView.frame;
    tmpframe.origin.y = height - 100;
    //    tmpframe.size.height = 45;
    self.CommentView.frame = tmpframe;
}

-(void)adjustMainImagePosition:(CGFloat)height {
    CGRect frame = self.mainImageView.frame;
    frame.origin.y = frame.origin.y + height;
    self.mainImageView.frame = frame;
}

//增加翻译的高度并显示翻译
-(void)showTranslateTV:(CGFloat)height Content:(NSString *)content {
    self.translateContentTF.hidden = NO;
    self.translateContentTF.text = content;
//    NSLog(@"[levi]jscontentTF %f", self.JSContentTF.frame.size.height);
    self.translateContentTF.frame = CGRectMake(self.JSContentTF.frame.origin.x, self.JSContentTF.frame.origin.y + [self returnTranslateHeightWithJSContent:self.JSContentTF], self.JSContentTF.frame.size.width, [self returnTranslateHeight:self.translateContentTF]);
    
    CGRect frame = self.retwitterMainV.frame;
    
    frame.origin.y = frame.origin.y + [self returnTranslateHeightWithJSContent:self.JSContentTF];
    self.retwitterMainV.frame = frame;
}

-(CGFloat)returnTranslateHeightWithJSContent:(JSCoreTextView*)originJSview {
    return [StatusCell getJSHeight:originJSview.text jsViewWith:originJSview.frame.size.width];
}

-(CGFloat)returnTranslateHeight:(UITextView*)translateView {
    return [StatusCell getJSHeight:translateView.text jsViewWith:translateView.frame.size.width];
}

//计算cell的高度，以及背景图的处理
-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage Status:(Status *)sts
{
    hasImage = FALSE;
    haveRetwitterImage = FALSE;
    if (!self.translateContentTF.isHidden) {
        self.translateContentTF.hidden = YES;
    }
    //博文Text
    CGRect frame;
    [self adjustTheHeightOf:self.JSContentTF withText:self.JSContentTF.text];
    
    //转发博文Text
    [self adjustTheHeightOf:self.JSRetitterContentTF withText:self.JSRetitterContentTF.text];
    
//    frame = timeLB.frame;
//    CGSize size = [timeLB.text sizeWithFont:[UIFont systemFontOfSize:13.0]];
//    frame.size = size;
//    frame.origin.x = 320 - 10 - size.width;
//    timeLB.frame = frame;
    
    //转发的主View
    frame = retwitterMainV.frame;
    
    if (haveRetwitterImage) 
        frame.size.height = self.JSRetitterContentTF.frame.size.height + IMAGE_VIEW_HEIGHT + 15;
    else 
        frame.size.height = self.JSRetitterContentTF.frame.size.height + 5;
    
    if(hasImage) 
        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + IMAGE_VIEW_HEIGHT;
    else 
        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y;
    
    retwitterMainV.frame = frame;
    
    
    //转发的图片
//    frame.origin.x = -30;
//    frame.size.height = 300;
//    frame.size.width = 300;
    
    //正文的图片
//    frame.origin.x = 10;
//    frame.size.height = 300;
//    frame.size.width = 300;
    
    //背景设置
//    int commentCount = 3;
    int commentCount = sts.commentsCount;
    if (commentCount > 3) {
        commentCount = 3;
    }

    CGFloat blankHeight = 0.0;
    if (self.JSContentTF.text.length == 0) {
        blankHeight = 10;
    }
    if (commentCount == NO_COMMNET) {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + blankHeight;
    } else if (commentCount == COMMENT_COUNT_ONE) {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + 25 + blankHeight;
    } else if (commentCount == COMMENT_COUNT_TWO) {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + 55 + blankHeight;
    } else if (commentCount == COMMNET_COUNT_THREE) {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + 60 + blankHeight;
    } else {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + 55 + blankHeight;
    }
}

-(IBAction)tapDetected:(id)sender
{
    NSLog(@"[levi]tap...");
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    if ([imageView isEqual:addLikeIconImage]) {
        if ([delegate respondsToSelector:@selector(cellAddLikeDidTaped:)]) {
            if (_isLiked) {
                _isLiked = FALSE;
                likeCount.text = [NSString stringWithFormat:@"%d", [likeCount.text integerValue] - 1];
                addLikeIconImage.image = [UIImage imageNamed:@"con-like.png"];
            } else {
                _isLiked = TRUE;
                likeCount.text = [NSString stringWithFormat:@"%d", [likeCount.text integerValue] + 1];
                addLikeIconImage.image = [UIImage imageNamed:@"con-liked.png"];
            }
            [delegate cellAddLikeDidTaped:self];
        }
    }
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
    NSLog(@"%@",link.URL.absoluteString);
    if ([self.delegate respondsToSelector:@selector(cellLinkDidTaped:link:)]) {
        [self.delegate cellLinkDidTaped:self link:link.URL.absoluteString];
    }
}

- (void)textViewTextTapped:(JSCoreTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(cellTextDidTaped:)]) {
        [self.delegate cellTextDidTaped:self];
    }
}
- (IBAction)likerTap:(id)sender {
    if ([delegate respondsToSelector:@selector(cellLikerDidTaped:)])
    {
        [delegate cellLikerDidTaped:self];
    }
}
- (IBAction)commentTap:(id)sender {
    NSLog(@"[levi]comment tap...");
    if ([delegate respondsToSelector:@selector(cellCommentDidTaped:)])
    {
        [delegate cellCommentDidTaped:self];
    }
}
- (IBAction)ShowMapTap:(id)sender {
    NSLog(@"[levi] show map...");
    if ([delegate respondsToSelector:@selector(cellShowUserLocationTaped:)])
    {
        [delegate cellShowUserLocationTaped:self];
    }
}
- (IBAction)playTranslateVoice:(id)sender {
    if ([delegate respondsToSelector:@selector(cellPlayTranslateVoiceTaped:)])
    {
        [delegate cellPlayTranslateVoiceTaped:self];
    }
}
- (IBAction)languageSelectAction:(id)sender {
    if ([delegate respondsToSelector:@selector(cellLanguageSelectTaped:)])
    {
        [delegate cellLanguageSelectTaped:self];
    }
}
- (IBAction)moreDoAction:(id)sender {
    if ([delegate respondsToSelector:@selector(cellMoreDoTaped:)])
    {
        [delegate cellMoreDoTaped:self];
    }
}

- (void)dealloc {
}
@end
