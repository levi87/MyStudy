//
//  NoticeTool.m
//  FreeBao
//
//  Created by freebao on 13-5-5.
//
//

#import "NoticeTool.h"

@implementation NoticeTool
@synthesize Message = _Message;
@synthesize IsRead = _IsRead;
@synthesize NoticeID = _NoticeID;
@synthesize NoticeType = _NoticeType;
@synthesize UserIdNotice = _UserIdNotice;
@synthesize NickName = _NickName;
@synthesize FacePath = _FacePath;
@synthesize CreatTime = _CreatTime;

- (id)init{
    if (self = [super init]) {
        self.Message = @"";
        self.IsRead  = @"";
        self.UserIdNotice  = @"";
        self.NickName = @"";
        self.FacePath = @"";
        self.CreatTime = @"";
        self.NoticeID = 0;
        self.NoticeType = 0;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<The NoticeID = %d Text = %@  NoticeType = %d IsRead = %@ userid = %@ nicename = %@,createtime = %@ facepath = %@>",self.NoticeID,self.Message,self.NoticeType,self.IsRead,self.UserIdNotice,self.NickName,self.CreatTime,self.FacePath];
}

- (void)dealloc
{
}

@end
