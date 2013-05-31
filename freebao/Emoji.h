//
//  Emoji.h
//  FreeBao
//
//  Created by ye bingwei on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoji : NSObject
{
@private
    NSString *text_;        // 对应的文字，如[qq]
    NSString *fileName_;    // 对应的名字，如88_thumb.gif
}

@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *fileName;

@end
