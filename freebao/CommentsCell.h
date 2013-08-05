//
//  CommentsCell.h
//  freebao
//
//  Created by freebao on 13-7-4.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"
#import "JSTwitterCoreTextView.h"

@class EGOImageView;
@interface CommentsCell : UITableViewCell <UIGestureRecognizerDelegate, JSCoreTextViewDelegate>{
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    JSTwitterCoreTextView *_commentTextView;
    UIView *_upperView;
    UIImageView *_languageImageView;
    UIImageView *_transVoiceImageView;
    UILabel *_commentDateLabel;
    UIImageView *_soundImageView;
}

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@property (nonatomic, retain) JSTwitterCoreTextView *commentTextView;
@property (nonatomic, retain) UIView *upperView;
@property (nonatomic, retain) UIImageView *languageImageView;
@property (nonatomic, retain) UIImageView *transVoiceImageView;
@property (nonatomic, retain) UILabel *commentDateLabel;
@property (nonatomic, retain) UIImageView *soundImageView;

@property (nonatomic, retain) NSIndexPath *indexPath;

- (void)setHeadPhoto:(NSString*)headPhoto;


-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity;

- (void)setCellLayout;

- (void)initUILayout;

-(void)setCellValue:(CommentInfo *)info;

+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with;

@end
