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
@synthesize retwitterBgImage;
@synthesize retwitterContentTF;
@synthesize retwitterContentImage;
@synthesize avatarImage;
@synthesize contentTF;
@synthesize translateContentTF;
@synthesize userNameLB;
@synthesize bgImage;
@synthesize contentImage;
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

- (void)setCellLayout:(BOOL)value {
    if (value) {
        self.mainImageView.frame = CGRectMake(0, 0, 320, 320);
        [self.mainImageView setHidden:NO];
        self.HeadView.frame = CGRectMake(0, 323, 40, 40);
        CGRect frameJS = _JSContentTF.frame;
        frameJS.origin.y = 360;
        
        _JSContentTF.frame = frameJS;
    } else {
        [self.mainImageView setHidden:YES];
        self.HeadView.frame = CGRectMake(0, 3, 40, 40);
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
    self.contentTF.text = status.text;
    self.JSContentTF.text = status.text;
    self.userNameLB.text = status.user.screenName;
//    countLB.text = [NSString stringWithFormat:@"  :%d     :%d",status.commentsCount,status.retweetsCount];
//    fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    timeLB.text = status.createdAt;
    
    Status  *retwitterStatus    = status.retweetedStatus;
    
    BOOL haveImage = NO;
    
//    CGRect frame;
//    frame = countLB.frame;
//    CGFloat padding = 320 - frame.origin.x - frame.size.width;
//    
//    frame = retweetCountImageView.frame;
//    CGSize size = [[NSString stringWithFormat:@"%d",status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
//    frame.origin.x = 320 - padding - size.width - retweetCountImageView.frame.size.width - 5;
//    retweetCountImageView.frame = frame;
//    
//    frame = commentCountImageView.frame;
//    size = [[NSString stringWithFormat:@"%d     :%d",status.commentsCount,status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
//    frame.origin.x = 320 - padding - size.width - commentCountImageView.frame.size.width - 5;
//    commentCountImageView.frame = frame;
    
//    NSLog(@"[levi] _JSContent status %@", status.text);
//    NSLog(@"[levi] _JSContent y + height %f", _JSContentTF.frame.origin.y + _JSContentTF.frame.size.height);
//    CGRect tmpframe = self.CommentView.frame;
//    tmpframe.origin.y = _JSContentTF.frame.origin.y + _JSContentTF.frame.size.height;
//    //    tmpframe.size.height = 45;
//    self.CommentView.frame = tmpframe;
    //有转发
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]]) 
    {
        self.retwitterMainV.hidden = NO;
        self.JSRetitterContentTF.text = [NSString stringWithFormat:@"@%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text];
        self.contentImage.hidden = YES;
        
        NSString *url = status.retweetedStatus.thumbnailPic;
//        self.retwitterContentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        haveImage = !self.retwitterContentImage.hidden;
        if (status.hasImage) {
            [self setCellLayout:YES];
        } else {
            [self setCellLayout:NO];
        }
        [self setTFHeightWithImage:NO
                haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO];//计算cell的高度，以及背景图的处理
    }
    
    //无转发
    else
    {
        self.retwitterMainV.hidden = YES;
        NSString *url = status.thumbnailPic;
//        self.contentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        haveImage = !self.contentImage.hidden;
        if (status.hasImage) {
            [self setCellLayout:YES];
        } else {
            [self setCellLayout:NO];
        }
        [self setTFHeightWithImage:url != nil && [url length] != 0 ? YES : NO 
                haveRetwitterImage:NO];//计算cell的高度，以及背景图的处理
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
        _line3Comment = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(76, 59, 230, 21)];
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
    _line1Comment.text = @"nice to meet you,beauty.";
    _line2Comment.text = @"@Echo924 可以讲中文吗？";
    _line3Comment.text = @"这个是要说西瓜小，还是要说...";
//    [self.CommentView setHidden:YES];
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
-(void)showTranslateTV:(CGFloat)height {
    self.translateContentTF.hidden = NO;
    NSLog(@"[levi]jscontentTF %f", self.JSContentTF.frame.size.height);
    self.translateContentTF.frame = CGRectMake(self.JSContentTF.frame.origin.x, self.JSContentTF.frame.origin.y + [self returnTranslateHeightWithJSContent:self.JSContentTF], self.JSContentTF.frame.size.width, [self returnTranslateHeight:self.translateContentTF]);
    
    CGRect frame = self.retwitterMainV.frame;
    
    frame.origin.y = frame.origin.y + [self returnTranslateHeightWithJSContent:self.JSContentTF];
    self.retwitterMainV.frame = frame;

    frame = self.retwitterContentImage.frame;
    frame.origin.y = frame.origin.y + [self returnTranslateHeightWithJSContent:self.JSContentTF];
    self.retwitterContentImage.frame = frame;
}

-(CGFloat)returnTranslateHeightWithJSContent:(JSCoreTextView*)originJSview {
    return [StatusCell getJSHeight:originJSview.text jsViewWith:originJSview.frame.size.width];
}

-(CGFloat)returnTranslateHeight:(UITextView*)translateView {
    return [StatusCell getJSHeight:translateView.text jsViewWith:translateView.frame.size.width];
}

//计算cell的高度，以及背景图的处理
-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage
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
    frame = retwitterContentImage.frame;
    frame.origin.y = self.JSRetitterContentTF.frame.size.height;
    frame.size.height = IMAGE_VIEW_HEIGHT;
//    frame.origin.x = -30;
//    frame.size.height = 300;
//    frame.size.width = 300;
    retwitterContentImage.frame = frame;
    
    //正文的图片
    frame = contentImage.frame;
    frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y - 5.0f;
    frame.size.height = IMAGE_VIEW_HEIGHT;
//    frame.origin.x = 10;
//    frame.size.height = 300;
//    frame.size.width = 300;
    contentImage.frame = frame;
    
    //背景设置
    if (bgImage.image == nil) {
        bgImage.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    if (retwitterBgImage.image == nil) {
        retwitterBgImage.image = [[UIImage imageNamed:@"timeline_rt_border.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:14];
    }
    if (retwitterMainV.hidden == NO) {
        return self.retwitterMainV.frame.size.height + self.retwitterMainV.frame.origin.y + 30 + 55;
    }
    else if(hasImage)
    {
        return self.contentImage.frame.size.height + self.contentImage.frame.origin.y + 40 + 55;
    }
    else {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 40 + 55;
    }
}

-(IBAction)tapDetected:(id)sender
{
    NSLog(@"[levi]tap...");
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    if ([imageView isEqual:contentImage]) {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)]) 
        {
            [delegate cellImageDidTaped:self image:contentImage.image];
        }
    } else if ([imageView isEqual:retwitterContentImage]) {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)])
        {
            [delegate cellImageDidTaped:self image:retwitterContentImage.image];
        }
    } else if ([imageView isEqual:mainImageView]) {
        if ([delegate respondsToSelector:@selector(cellExpandForTranslate:Height:)]) {
            [delegate cellExpandForTranslate:self Height:100];
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

- (void)dealloc {
}
@end
