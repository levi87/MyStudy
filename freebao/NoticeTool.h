//
//  NoticeTool.h
//  FreeBao
//
//  Created by freebao on 13-5-5.
//
//

#import <Foundation/Foundation.h>

@interface NoticeTool : NSObject
{
    NSString * _Message;
    int _NoticeID;
    int _NoticeType;
    NSString * _IsRead;
    NSString *_UserIdNotice;
    NSString *_NickName;
    NSString *_FacePath;
    NSString *_CreatTime;
    
}

@property (nonatomic, copy) NSString *Message;
@property (nonatomic, assign) int NoticeID;
@property (nonatomic, copy) NSString *IsRead;
@property (nonatomic, assign) int NoticeType;
@property (nonatomic, copy) NSString *UserIdNotice;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *FacePath;
@property (nonatomic, copy) NSString *CreatTime;


@end
