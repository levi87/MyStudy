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
