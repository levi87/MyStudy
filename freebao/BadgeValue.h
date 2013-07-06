//
//  BadgeValue.h
//  FreeBao
//
//  Created by freebao on 13-5-23.
//
//

#import <Foundation/Foundation.h>

@interface BadgeValue : NSObject {
    NSString *_atValue;
    NSString *_commentValue;
    NSString *_messageValue;
    NSString *_noticeValue;
}

@property (nonatomic, retain) NSString *atValue;
@property (nonatomic, retain) NSString *commentValue;
@property (nonatomic, retain) NSString *messageValue;
@property (nonatomic, retain) NSString *noticeValue;

@end
