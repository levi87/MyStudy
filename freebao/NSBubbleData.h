//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>
#import "EGOImageView.h"

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@class EGOImageView;
@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (readonly, nonatomic, strong) EGOImageView *mapView;
@property (readonly, nonatomic, strong) NSData *voiceData;
@property (readonly, nonatomic, strong) NSString *voiceLength;
@property (nonatomic, strong) UIButton *voiceButton;
@property BOOL isMap;
@property BOOL isVoice;
@property BOOL isSelf;
@property BOOL isPic;
@property BOOL isPlayAnimation;
@property (nonatomic) CGPoint positionPoint;
@property NSString *cellRow;
@property NSString *textContent;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

- (id)initWithPosition:(NSString*)position Point:(CGPoint)cgPoint date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets Language:(NSString*)language;
+ (id)dataWithPosition:(NSString*)position Point:(CGPoint)cgPoint date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets Language:(NSString*)language;

- (id)initWithVoice:(NSData*)voiceData VoiceLength:(NSString*)voiceLength date:(NSDate *)date IsSelf:(BOOL)isSelf type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithVoice:(NSData*)voiceData VoiceLength:(NSString*)voiceLength date:(NSDate *)date IsSelf:(BOOL)isSelf type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

@end
