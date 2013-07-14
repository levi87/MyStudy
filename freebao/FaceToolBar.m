//
//  FaceToolBar.m
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//

#import "FaceToolBar.h"

#define HIDE_KEYBOARD @"fb_hide_keyboard"

@interface FaceToolBar() {
    OCExpandableButton *button;
}

@end

@implementation FaceToolBar
@synthesize theSuperView,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化为NO
        keyboardIsShow=NO;
        self.theSuperView=superView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAndFaceView) name:HIDE_KEYBOARD object:nil];
        //OCExpandButton
        NSMutableArray *subviews = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 4; i++) {
            UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.f, 30.f)];
            numberButton.backgroundColor = [UIColor clearColor];
            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            numberButton.tag = i;
            numberButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            numberButton.titleLabel.textColor = [UIColor colorWithRed:0.494 green:0.498 blue:0.518 alpha:1];
            [numberButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            [subviews addObject:numberButton];
        }
        button = [[OCExpandableButton alloc] initWithFrame:CGRectMake(-39, superView.bounds.size.height - 57, 39, 39) subviews:subviews];
        //You can change the alignment with:
        button.alignment = OCExpandableButtonAlignmentLeft;
        [superView addSubview:button];
        //默认toolBar在视图最下方
        toolBar = [[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f,superView.bounds.size.height - toolBarHeight,superView.bounds.size.width,toolBarHeight)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
//        [toolBar setBackgroundImage:[[UIImage imageNamed:@"keyBoardBack"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
//        [toolBar setBarStyle:UIBarStyleDefault];
       
        //可以自适应高度的文本输入框
        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 5, 210, 36)];
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        [textView.internalTextView setReturnKeyType:UIReturnKeySend];
        textView.delegate = self;
        textView.maximumNumberOfLines=5;
        [toolBar addSubview:textView];
        //音频按钮
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
        [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
        voiceButton.frame = CGRectMake(5,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        [toolBar addSubview:voiceButton];
        
        UILongPressGestureRecognizer *longGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(voiceBtnLongPress:)];
        [voiceButton addGestureRecognizer:longGesture];
        
        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        faceButton.frame = CGRectMake(toolBar.bounds.size.width - 70.0f,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
//        [toolBar addSubview:faceButton];
        
        //表情按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [sendButton setTitle:@"send" forState:UIControlStateNormal];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        sendButton.enabled=NO;
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(toolBar.bounds.size.width - 70.0f,toolBar.bounds.size.height-38.0f,buttonWh+34,buttonWh);
        [toolBar addSubview:sendButton];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        //创建表情键盘
        if (scrollView==nil) {
            scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];
            [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
            for (int i=0; i<9; i++) {
                FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
                [fview setBackgroundColor:[UIColor clearColor]];
                [fview loadFacialView:i size:CGSizeMake(33, 43)];
                fview.delegate=self;
                [scrollView addSubview:fview];
            }
        }
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.contentSize=CGSizeMake(320*9, keyboardHeight);
        scrollView.pagingEnabled=YES;
        scrollView.delegate=self;
        [superView addSubview:scrollView];
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(82, superView.frame.size.height-40, 150, 30)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
        pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = 9;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.hidden=YES;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [superView addSubview:pageControl];
        
        [superView addSubview:toolBar];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}

-(void)voiceBtnLongPress:(UILongPressGestureRecognizer *)recogonizer {
    if ([delegate respondsToSelector:@selector(voiceLongPressAction:)])
    {
        [delegate voiceLongPressAction:recogonizer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}


#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = toolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    toolBar.frame = r;
    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
        NSLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
    }
    
}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    [self sendAction];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    NSLog(@"文本的长度%d",textView.text.length);
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        sendButton.enabled = YES;
    else
        sendButton.enabled = NO;
}
#pragma mark -
#pragma mark ActionMethods  发送sendAction 音频 voiceChange  显示表情 disFaceKeyboard
-(void)sendAction{
    if (textView.text.length>0) {
        NSLog(@"点击发送");
        NSString *tmpStr = textView.text;
        [textView clearText];
        if ([delegate respondsToSelector:@selector(sendTextAction:Frame:)])
        {
            [delegate sendTextAction:tmpStr Frame:toolBar.frame];
        }
    }
}
-(void)showKb:(CGRect)frame {
    CGRect tmpFrame = button.frame;
    tmpFrame.origin.y = toolBar.frame.origin.y - tmpFrame.size.height;
    button.frame = tmpFrame;
    if ([delegate respondsToSelector:@selector(showKeyboard:)])
    {
        [delegate showKeyboard:frame];
    }
}

-(void)hideKb:(CGRect)frame {
    CGRect tmpFrame = button.frame;
    tmpFrame.origin.y = toolBar.frame.origin.y - tmpFrame.size.height;
    button.frame = tmpFrame;
    if ([delegate respondsToSelector:@selector(hideKeyboard:)])
    {
        [delegate hideKeyboard:frame];
    }
}
-(void)voiceChange{
//    [self dismissKeyBoard];
//    [self showEb:toolBar.frame];
    NSLog(@"[levi]show expand button");
    CGRect tmpFrame = button.frame;
    tmpFrame.origin.y = toolBar.frame.origin.y - tmpFrame.size.height;
    button.frame = tmpFrame;
    [button open];
}

- (void)tapped:(id)sender {
    NSLog(@"tapped");
    [button close];
    UIButton *tmpButton = sender;
    if (tmpButton.tag == 0) {
        NSLog(@"tag 1");
        [self disFaceKeyboard];
    }
    if ([delegate respondsToSelector:@selector(expandButtonAction:)])
    {
        [delegate expandButtonAction:sender];
    }
}

-(void)hideKeyboardAndFaceView {
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
    }];
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    [textView resignFirstResponder];
    [pageControl setHidden:YES];
    [button close];
    if ([delegate respondsToSelector:@selector(hideKeyboardAndFaceV)])
    {
        [delegate hideKeyboardAndFaceV];
    }
}

-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if (toolBar.frame.origin.y== self.theSuperView.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight) {
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [pageControl setHidden:NO];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
        [self showKb:toolBar.frame];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [textView becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [self hideKb:toolBar.frame];
        [pageControl setHidden:NO];
        [textView resignFirstResponder];
    }
    
}
#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    [pageControl setHidden:YES];
    [textView resignFirstResponder];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [self hideKb:toolBar.frame];
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        if (toolBar.frame.size.height>45) {
            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-20-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
        }else{
            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-65,  self.theSuperView.bounds.size.width,toolBarHeight);
        }
    }];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
    [pageControl setHidden:YES];
    [self showKb:toolBar.frame];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSLog(@"进代理了");
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (textView.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr=[textView.text substringToIndex:textView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[textView.text substringFromIndex:textView.text.length-1]);
                newStr=[textView.text substringToIndex:textView.text.length-1];
            }
            textView.text=newStr;
        }
        NSLog(@"删除后更新%@",textView.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",textView.text,str];
        [textView setText:newStr];
        NSLog(@"点击其他后更新%d,%@",str.length,textView.text);
    }
    NSLog(@"出代理了");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HIDE_KEYBOARD
                                                  object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
