//
//  NoticesCell.h
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeInfo.h"

@class EGOImageView;
@interface NoticesCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(NoticeInfo*)info;
@end
