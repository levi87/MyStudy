//
//  StatusCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"
#import "Status.h"
#import "User.h"
#import "JSTwitterCoreTextView.h"

#define IMAGE_VIEW_HEIGHT 80.0f
#define PADDING_TOP 8.0
#define PADDING_LEFT 6.0
#define FONT_SIZE 15.0
#define FONT @"Helvetica"

@class StatusCell;

@protocol StatusCellDelegate <NSObject>

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage*)image;
-(void)cellLinkDidTaped:(StatusCell *)theCell link:(NSString*)link;
-(void)cellTextDidTaped:(StatusCell *)theCell;

-(void)cellExpandForTranslate:(StatusCell *)theCell Height:(NSInteger)height;

-(void)cellLikerDidTaped:(StatusCell *)theCell;

-(void)cellCommentDidTaped:(StatusCell *)theCell;

@end

@interface StatusCell : LPBaseCell <JSCoreTextViewDelegate>
{
    id<StatusCellDelegate> delegate;
    
    UIImageView *avatarImage;
    JSTwitterCoreTextView *_JSContentTF;
    UITextView *contentTF;
    UITextView *translateContentTF;
    UILabel *userNameLB;
    UIImageView *bgImage;
    UIImageView *contentImage;
    UIView *retwitterMainV;
    UIImageView *retwitterBgImage;
    UITextView *retwitterContentTF;
    JSTwitterCoreTextView *_JSRetitterContentTF;
    UIImageView *retwitterContentImage;
    NSIndexPath *cellIndexPath;
    UIView *commentToolBarView;
    JSTwitterCoreTextView *_line1Comment;
    JSTwitterCoreTextView *_line2Comment;
    JSTwitterCoreTextView *_line3Comment;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextView *contentTF;
@property (retain, nonatomic) IBOutlet UITextView *translateContentTF;
@property (retain, nonatomic) IBOutlet UILabel *userNameLB;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;
@property (retain, nonatomic) IBOutlet UIView *retwitterMainV;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterBgImage;
@property (retain, nonatomic) IBOutlet UITextView *retwitterContentTF;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterContentImage;
@property (retain, nonatomic) id<StatusCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;
@property (retain, nonatomic) IBOutlet UILabel *fromLB;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *headBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (nonatomic,retain)JSTwitterCoreTextView *JSContentTF;
@property (nonatomic,retain)JSTwitterCoreTextView *JSRetitterContentTF;

@property (nonatomic,retain)JSTwitterCoreTextView *line1Comment;
@property (nonatomic,retain)JSTwitterCoreTextView *line2Comment;
@property (nonatomic,retain)JSTwitterCoreTextView *line3Comment;

@property (retain, nonatomic) IBOutlet UIView *commentToolBarView;
@property (retain, nonatomic) IBOutlet UIView *CommentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconLocationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconMoreImageView;

-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage;
-(void)updateCellTextWith:(Status*)status;
+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with;
-(void)showTranslateTV:(CGFloat)height;
-(void)adjustMainImagePosition:(CGFloat)height;
@property (retain, nonatomic) IBOutlet UIView *HeadView;
- (void)setCellLayout:(BOOL)value;

- (void)setCommentPosition:(CGFloat)height;
@end
