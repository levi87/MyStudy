//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize mapView = _mapView;
@synthesize isMap = _isMap;
@synthesize isVoice = _isVoice;
@synthesize isPic = _isPic;
@synthesize isSelf = _isSelf;
@synthesize voiceButton = _voiceButton;
@synthesize voiceData = _voiceData;
@synthesize voiceLength = _voiceLength;
@synthesize isPlayAnimation = _isPlayAnimation;
@synthesize positionPoint = _positionPoint;
@synthesize cellRow = _cellRow;
@synthesize textContent = _textContent;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
#endif    
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    _isMap = FALSE;
    _isPic = FALSE;
    _isVoice = FALSE;
    _textContent = text;
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    _isMap = FALSE;
    _isPic = TRUE;
    _isVoice = FALSE;
    CGSize size = image.size;
    if (size.width > 220)
    {
        size.height /= (size.width / 220);
        size.width = 220;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
        _isMap = FALSE;
        _isVoice = FALSE;
        _isPic = FALSE;
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

+(id)dataWithPosition:(NSString *)position Point:(CGPoint)cgPoint date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets Language:(NSString*)language {
    return [[NSBubbleData alloc] initWithPosition:position Point:cgPoint date:date type:type insets:insets Language:language];
}

-(id)initWithPosition:(NSString *)position Point:(CGPoint)cgPoint date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets Language:(NSString *)language{
    self = [super init];
    if (self)
    {
        EGOImageView *mapImageView = [[EGOImageView alloc] init];
        _isMap = TRUE;
        _isPic = FALSE;
        _isVoice = FALSE;
        mapImageView.frame = CGRectMake(0, 0, 220, 220);
//        NSString *myPositionUrl=@"http://maps.google.com/maps/api/staticmap?center=30.2094,120.204&zoom=14&size=220x220&sensor=false&markers=30.2094,120.204&language=zh_CN";
        NSString *myPositionUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&zoom=14&size=220x220&sensor=false&markers=%f,%f&language=%@", cgPoint.x, cgPoint.y, cgPoint.x, cgPoint.y, language];
        mapImageView.imageURL = [NSURL URLWithString:myPositionUrl];
        _mapView = mapImageView;
        _date = date;
        _type = type;
        _insets = insets;
        _positionPoint = cgPoint;
    }
    return self;
}

+(id)dataWithVoice:(NSData *)voiceData VoiceLength:(NSString*)voiceLength date:(NSDate *)date IsSelf:(BOOL)isSelf type:(NSBubbleType)type insets:(UIEdgeInsets)insets {
    return [[NSBubbleData alloc] initWithVoice:voiceData VoiceLength:voiceLength date:date IsSelf:isSelf type:type insets:insets];
}

-(id)initWithVoice:(NSData *)voiceData VoiceLength:(NSString*)voiceLength date:(NSDate *)date IsSelf:(BOOL)isSelf type:(NSBubbleType)type insets:(UIEdgeInsets)insets {
    self = [super init];
    if (self)
    {
        UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _isVoice = TRUE;
        _isPic = FALSE;
        _isMap = FALSE;
        _isSelf = isSelf;
        _voiceLength = voiceLength;
        [voiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        voiceButton.frame = CGRectMake(0, 0, 80, 30);
        _voiceButton = voiceButton;
        _date = date;
        _type = type;
        _insets = insets;
        _voiceData = voiceData;
        _isPlayAnimation = NO;
    }
    return self;
}

@end
