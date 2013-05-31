//
//  SelectXYData.m
//  FreeBao
//
//  Created by qeeka on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectXYData.h"


static SelectXYData* s_SelectXYData;

@implementation SelectXYData
@synthesize moveX;
@synthesize moveY;
@synthesize m_moveX;
@synthesize m_moveY;
@synthesize movedx;
@synthesize movedy;
@synthesize movedz;
@synthesize m_movedx;
@synthesize m_movedy;
@synthesize tt;
@synthesize yy;
@synthesize userid;
@synthesize rowid;
@synthesize rowdelet;
@synthesize rowdeletone;
@synthesize change;
@synthesize deletwhich;
@synthesize access_token;
@synthesize openid;
@synthesize width;
@synthesize height;
@synthesize token;
@synthesize heightdd;
@synthesize changetheheight;
@synthesize chheheight;
@synthesize didchange;
@synthesize help;
@synthesize aruser;
@synthesize rowdeletHelp;
@synthesize MyPlace;
@synthesize toknow;
@synthesize path;
@synthesize voiceheight;
@synthesize voicelong;
@synthesize playMusicIndex;
@synthesize nickName;
@synthesize DidConnect;
@synthesize passwordKey;
@synthesize pointAtY;
@synthesize selffacePath = selffacePath_;
@synthesize nackname = nackname_;
@synthesize joinTime = joinTime_;
@synthesize haveFollow =haveFollow_;
+ (SelectXYData*)shareData{
    
    @synchronized(self)
	{
		if (s_SelectXYData==nil)
		{
			s_SelectXYData = [[self alloc] init];
		}
	}
	return s_SelectXYData;
}

+(id) allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (s_SelectXYData == nil)
		{
            s_SelectXYData = [super allocWithZone:zone];
			
			return s_SelectXYData;
		}
	}
	
	return nil;
}



@end
