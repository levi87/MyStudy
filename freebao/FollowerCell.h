//
//  FollowerCell.h
//  freebao
//
//  Created by levi on 13-7-27.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowerInfo.h"

@class EGOImageView;
@interface FollowerCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    UIImageView *sexImageV;
    UILabel *ageLabel;
    UILabel *city;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(FollowerInfo*)info;

@end
