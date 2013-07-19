//
//  ConversationCell.h
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationInfo.h"

#define FONT_SIZE 15.0
#define FONT @"HelveticaNeue-Light"
#define PADDING_TOP 8.0
#define PADDING_LEFT 0.0

@class EGOImageView;
@interface ConversationCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *userNameLabel;
    UILabel *createDateLabel;
    UILabel *contentLabel;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(ConversationInfo*)value;

@end
