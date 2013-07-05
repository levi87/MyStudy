//
//  ConversationCell.h
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface ConversationCell : UITableViewCell {
@private
    EGOImageView* headImageView;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

@end
