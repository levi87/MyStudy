//
//  FaceToolBar.m
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//

#import "FaceToolBar.h"

#define HIDE_KEYBOARD @"fb_hide_keyboard"

#define INIT_FACEVIEW_POSITION @"init_faceview_position"

@interface FaceToolBar() {
    OCExpandableButton *button;
}

@end

@implementation FaceToolBar
@synthesize theSuperView,delegate;
@synthesize isComment = _isComment;
@synthesize textView = _textView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView IsCommentView:(BOOL)value IsPostView:(BOOL)isPostValue{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化为NO
        keyboardIsShow=NO;
        self.theSuperView=superView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAndFaceView) name:HIDE_KEYBOARD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initFaceViewPosition) name:INIT_FACEVIEW_POSITION object:nil];

        //默认toolBar在视图最下方
        toolBar = [[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f,superView.bounds.size.height - toolBarHeight,superView.bounds.size.width,toolBarHeight)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        if (!value) {
            
            //OCExpandButton
            NSMutableArray *subviews = [[NSMutableArray alloc] init];
            
            UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37.f, 37.f)];
            faceBtn.backgroundColor = [UIColor clearColor];
            [faceBtn setBackgroundImage:[UIImage imageNamed:@"i_edit_phiz"] forState:UIControlStateNormal];
            //            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            faceBtn.tag = 0;
            faceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            faceBtn.titleLabel.textColor = [UIColor colorWithRed:0.494 green:0.498 blue:0.518 alpha:1];
            [faceBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            [subviews addObject:faceBtn];
            
            UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37.f, 37.f)];
            cameraBtn.backgroundColor = [UIColor clearColor];
            [cameraBtn setBackgroundImage:[UIImage imageNamed:@"i_edit_photo"] forState:UIControlStateNormal];
            //            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            cameraBtn.tag = 1;
            cameraBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            cameraBtn.titleLabel.textColor = [UIColor colorWithRed:0.494 green:0.498 blue:0.518 alpha:1];
            [cameraBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            [subviews addObject:cameraBtn];
            
            UIButton *pictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37.f, 37.f)];
            pictureBtn.backgroundColor = [UIColor clearColor];
            [pictureBtn setBackgroundImage:[UIImage imageNamed:@"i_edit_picture"] forState:UIControlStateNormal];
            //            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            pictureBtn.tag = 2;
            pictureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            pictureBtn.titleLabel.textColor = [UIColor colorWithRed:0.494 green:0.498 blue:0.518 alpha:1];
            [pictureBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            [subviews addObject:pictureBtn];
            
            UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37.f, 37.f)];
            locationBtn.backgroundColor = [UIColor clearColor];
            [locationBtn setBackgroundImage:[UIImage imageNamed:@"i_edit_Location"] forState:UIControlStateNormal];
            //            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            locationBtn.tag = 3;
            locationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            locationBtn.titleLabel.textColor = [UIColor colorWithRed:0.494 green:0.498 blue:0.518 alpha:1];
            [locationBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
            [subviews addObject:locationBtn];
            
            button = [[OCExpandableButton alloc] initWithFrame:CGRectMake(-39, superView.bounds.size.height - 57, 39, 39) subviews:subviews];
            //You can change the alignment with:
            button.alignment = OCExpandableButtonAlignmentLeft;
            [superView addSubview:button];
            //音频按钮
            voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            [voiceButton setBackgroundImage:[UIImage imageNamed:@"i_edit_more+"] forState:UIControlStateNormal];
            [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
            voiceButton.frame = CGRectMake(3,toolBar.bounds.size.height-40.0f,buttonWh,buttonWh);
            [toolBar addSubview:voiceButton];
        } else {
            UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(3,toolBar.bounds.size.height-40.0f,buttonWh,buttonWh)];
            faceBtn.backgroundColor = [UIColor clearColor];
            [faceBtn setBackgroundImage:[UIImage imageNamed:@"i_edit_phiz"] forState:UIControlStateNormal];
            //            [numberButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [faceBtn addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
            [toolBar addSubview:faceBtn];
        }
//        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
//        [toolBar setBackgroundImage:[[UIImage imageNamed:@"keyBoardBack"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
//        [toolBar setBarStyle:UIBarStyleDefault];
       
        //可以自适应高度的文本输入框
        _textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 5, 210, 36)];
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        [_textView.internalTextView setReturnKeyType:UIReturnKeySend];
        _textView.delegate = self;
        _textView.maximumNumberOfLines=5;
        currentMode = isPostValue;
        if (!isPostValue) {
            [toolBar addSubview:_textView];
        }
        
        UILongPressGestureRecognizer *longGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(voiceBtnLongPress:)];
//        [voiceButton addGestureRecognizer:longGesture];
        
        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        if (!isPostValue) {
            faceButton.frame = CGRectMake(toolBar.bounds.size.width - 70.0f,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        } else {
            faceButton.frame = CGRectMake(toolBar.bounds.size.width - 150.0f,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        }
//        [toolBar addSubview:faceButton];
        
        //表情按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
//        sendButton.enabled=NO;
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
//        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [sendButton addGestureRecognizer:longGesture];
        sendButton.frame = CGRectMake(toolBar.bounds.size.width - 65.0f,toolBar.bounds.size.height-40.0f,buttonWh+25,buttonWh);
        [sendButton setBackgroundImage:[UIImage imageNamed:@"i_edit_voice2"] forState:UIControlStateNormal];
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
//        pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
//        pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = 9;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.hidden=YES;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [superView addSubview:pageControl];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [toolBar addGestureRecognizer:recognizer];
        [superView addSubview:toolBar];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_KEYBOARD object:nil];
    }
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
    float diff = (_textView.frame.size.height - height);
    CGRect r = toolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    toolBar.frame = r;
    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
        NSLog(@"最后输入的是表情%@",[_textView.text substringFromIndex:_textView.text.length-2]);
        _textView.internalTextView.contentOffset=CGPointMake(0,_textView.internalTextView.contentSize.height-_textView.internalTextView.frame.size.height );
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
    NSLog(@"文本的长度%d",_textView.text.length);
    /* Enable/Disable the button */
//    if ([expandingTextView.text length] > 0)
//        sendButton.enabled = YES;
//    else
//        sendButton.enabled = NO;
}
#pragma mark -
#pragma mark ActionMethods  发送sendAction 音频 voiceChange  显示表情 disFaceKeyboard
-(void)sendAction{
    if (_textView.text.length>0) {
        NSLog(@"点击发送");
        NSString *tmpStr = _textView.text;
        [_textView clearText];
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
    if (button.tag == 1) {
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"i_edit_more+"] forState:UIControlStateNormal];
        button.tag = 0;
        [button close];
        return;
    }
    CGRect tmpFrame = button.frame;
    tmpFrame.origin.y = toolBar.frame.origin.y - tmpFrame.size.height;
    button.frame = tmpFrame;
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"i_edit_more-"] forState:UIControlStateNormal];
    button.tag = 1;
    [button open];
}

- (void)tapped:(id)sender {
    NSLog(@"tapped");
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"i_edit_more+"] forState:UIControlStateNormal];
    button.tag = 0;
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

-(void)initFaceViewPosition {
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
    }];
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    [_textView resignFirstResponder];
    [pageControl setHidden:YES];
}

-(void)hideKeyboardAndFaceView {
    [UIView animateWithDuration:Time animations:^{
        toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
    }];
    [UIView animateWithDuration:Time animations:^{
        [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    [_textView resignFirstResponder];
    [pageControl setHidden:YES];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"i_edit_more+"] forState:UIControlStateNormal];
    button.tag = 0;
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
        if ([delegate respondsToSelector:@selector(showKeyboardPost)])
        {
            [delegate showKeyboardPost];
        }
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_textView becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        if ([delegate respondsToSelector:@selector(hideKeyboardPost)])
        {
            [delegate hideKeyboardPost];
        }
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.theSuperView.bounds.size.width,toolBar.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [self hideKb:toolBar.frame];
        [pageControl setHidden:NO];
        [_textView resignFirstResponder];
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
    [_textView resignFirstResponder];
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
    if (currentMode) {
        if ([delegate respondsToSelector:@selector(inputText:)])
        {
            [delegate inputText:str];
        }
    } else {
        NSLog(@"进代理了");
        NSString *newStr;
        if ([str isEqualToString:@"删除"]) {
            if (_textView.text.length>0) {
                if ([[Emoji allEmoji] containsObject:[_textView.text substringFromIndex:_textView.text.length-2]]) {
                    NSLog(@"删除emoji %@",[_textView.text substringFromIndex:_textView.text.length-2]);
                    newStr=[_textView.text substringToIndex:_textView.text.length-2];
                }else{
                    NSLog(@"删除文字%@",[_textView.text substringFromIndex:_textView.text.length-1]);
                    newStr=[_textView.text substringToIndex:_textView.text.length-1];
                }
                _textView.text=newStr;
            }
            NSLog(@"删除后更新%@",_textView.text);
        }else{
            NSString *newStr=[NSString stringWithFormat:@"%@%@",_textView.text,str];
            [_textView setText:newStr];
            NSLog(@"点击其他后更新%d,%@",str.length,_textView.text);
        }
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
