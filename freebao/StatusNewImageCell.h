//
//  StatusNewCell.h
//  freebao
//
//  Created by levi on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTwitterCoreTextView.h"
#import "StatusInfo.h"

@class EGOImageView;
@interface StatusNewImageCell : UITableViewCell <JSCoreTextViewDelegate> {
    EGOImageView* headImageView;
    EGOImageView* mainImageView;
    UILabel *nickNameLabel;
    JSTwitterCoreTextView *_contentTextView;
    JSTwitterCoreTextView *_forwordContentTextView;
    UIView *_upperView;
    UIView *_lowerView;
    UIImageView *_languageImageView;
    UIImageView *_transVoiceImageView;
    UILabel *_statusDateLabel;
    UIImageView *_soundImageView;
    
    UIImageView *_moreImageView;
    UIImageView *_likeImageView;
    UIImageView *_commentImageView;
    
    UIView *_middleView;
    UILabel *_likeCount;
    UILabel *_commentCount;
    
    UIView *_commentsView;
    UILabel *_line1label;
    JSTwitterCoreTextView *_line1TextView;
    UILabel *_line2Label;
    JSTwitterCoreTextView *_line2TextView;
    UILabel *_line3Label;
    JSTwitterCoreTextView *_line3TextView;
}

@property (nonatomic, retain) JSTwitterCoreTextView *contentTextView;
@property (nonatomic, retain) JSTwitterCoreTextView *forwordContentTextView;
@property (nonatomic, retain) UIView *upperView;
@property (nonatomic, retain) UIView *lowerView;
@property (nonatomic, retain) UIImageView *languageImageView;
@property (nonatomic, retain) UIImageView *transVoiceImageView;
@property (nonatomic, retain) UILabel *statusDateLabel;
@property (nonatomic, retain) UIImageView *soundImageView;

@property (nonatomic, retain) UIImageView *moreImageView;
@property (nonatomic, retain) UIImageView *likeImageView;
@property (nonatomic, retain) UIImageView *commentImageView;

@property (nonatomic, retain) NSIndexPath *indexPath;

- (void)setHeadPhoto:(NSString*)headPhoto;

-(void)setCellValue:(StatusInfo *)info;

+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with;

@end
