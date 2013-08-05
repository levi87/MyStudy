//
//  FaceToolBar.h
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//
#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 216
#define  toolBarHeight 45
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  buttonWh 37
#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "UIExpandingTextView.h"
#import "OCExpandableButton.h"
#import "CustomToolbar.h"

@protocol FaceToolBarDelegate <NSObject>
-(void)sendTextAction:(NSString *)inputText Frame:(CGRect)frame;

-(void)showKeyboard:(CGRect)frame;
-(void)hideKeyboard:(CGRect)frame;
-(void)expandButtonAction:(id)sender;
-(void)voiceLongPressAction:(UILongPressGestureRecognizer *)recogonizer;

-(void)hideKeyboardAndFaceV;

-(void)inputText:(NSString*)str;


-(void)hideKeyboardPost;
-(void)showKeyboardPost;
@end
@interface FaceToolBar : UIToolbar<facialViewDelegate,UIExpandingTextViewDelegate,UIScrollViewDelegate>
{
    CustomToolbar *toolBar;//工具栏
    UIExpandingTextView *_textView;//文本输入框
    UIButton *faceButton ;
    UIButton *voiceButton;
    UIButton *sendButton;
    
    BOOL keyboardIsShow;//键盘是否显示
    
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    
    UIView *theSuperView;

    NSObject <FaceToolBarDelegate> *delegate;
    
    BOOL currentMode;
}
@property(nonatomic,retain)UIView *theSuperView;
@property (retain) NSObject<FaceToolBarDelegate> *delegate;
@property (nonatomic, retain) UIExpandingTextView *textView;
@property BOOL isComment;
-(void)dismissKeyBoard;
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView IsCommentView:(BOOL)value IsPostView:(BOOL)isPostValue;
@end
