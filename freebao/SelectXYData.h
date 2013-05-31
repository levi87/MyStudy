//
//  SelectXYData.h
//  FreeBao
//
//  Created by qeeka on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSelectXYData [SelectXYData shareData]

@interface SelectXYData : NSObject{
    
    float moveX;
    float moveY;
    
    float movedx;
    float movedy;
    float movedz;
    
    int tt;
    int yy;
    int change;
    int  heightdd;
    int  playMusicIndex;
    int  aruser;
    int   toknow;
    
    float height;
    float width;
    
    
    float voiceheight;
     NSString * voicelong;
    
    NSString * pointAtY;
    NSInteger userid;
    NSInteger   rowid;
    NSInteger   rowdelet;
    NSInteger   rowdeletone;
    NSInteger   rowdeletHelp;
    NSInteger   MyPlace;
    
    NSString * path;
    NSString * m_movedx;
    NSString * m_movedy;
    NSString *access_token;
    NSString *openid;
    
    NSInteger changetheheight;
    NSInteger chheheight;
    NSInteger didchange;
    
    NSString* m_moveX;
    NSString* m_moveY;
    NSString* nickName;
    
    NSInteger help;
    NSString *token;
    //区分删除的是分类广告里面的还是all里面的信息
    BOOL  helpOrno;
    NSInteger  deletwhich;
    
    int  DidConnect;
    NSString *passwordKey;
    
    NSString *selffacePath_;
    NSString *nackname_;
    NSString *joinTime_;
    NSString *haveFollow_;
    
}
@property(nonatomic, retain)NSString *haveFollow;
@property(nonatomic, retain)NSString *nackname;
@property(nonatomic,retain)NSString * selffacePath;
@property(nonatomic,retain)NSString * pointAtY;
@property(nonatomic,retain) NSString* passwordKey;
@property(nonatomic,assign) int DidConnect;
@property(nonatomic,retain) NSString* nickName;
@property(nonatomic,retain) NSString* m_moveX;
@property(nonatomic,retain) NSString* m_moveY;
@property(nonatomic,retain)NSString *access_token;
@property(nonatomic,retain)NSString *openid;
@property(nonatomic,retain)NSString *token;
@property(nonatomic,retain)NSString *path;
@property(nonatomic,assign) int tt;
@property(nonatomic,assign) int changetheheight;
@property(nonatomic,assign) int chheheight;
@property(nonatomic,assign) int heightdd;
@property(nonatomic,assign) int playMusicIndex;
@property(nonatomic,assign) int didchange;
@property(nonatomic,assign) int yy;
@property(nonatomic,assign) int toknow;
@property(nonatomic,assign) float width;
@property(nonatomic,assign) float height;
@property(nonatomic,assign) float voiceheight;
@property(nonatomic,retain) NSString * voicelong;
@property(nonatomic,assign) int change;
@property(nonatomic,assign) int aruser;
@property(nonatomic,assign) NSInteger userid;
@property(nonatomic,assign) NSInteger  rowid;
@property(nonatomic,assign) NSInteger  rowdelet;
@property(nonatomic,assign) NSInteger  rowdeletone;
@property(nonatomic,assign) NSInteger  rowdeletHelp;
@property(nonatomic,assign) NSInteger  MyPlace;
@property(nonatomic,retain) NSString* m_movedx;
@property(nonatomic,retain) NSString* m_movedy;
@property(nonatomic,retain) NSString* joinTime;
@property(nonatomic,assign) NSInteger  help;

@property(nonatomic,assign) NSInteger deletwhich;
@property(nonatomic,assign)  float movedz;

@property(nonatomic,assign) float moveX;
@property(nonatomic,assign) float moveY;

@property(nonatomic,assign) float movedx;
@property(nonatomic,assign) float movedy;

+ (SelectXYData*)shareData;


@end
