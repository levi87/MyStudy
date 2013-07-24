//
//  FansCell.h
//  freebao
//
//  Created by freebao on 13-7-24.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansInfo.h"

@class EGOImageView;
@interface FansCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    UIImageView *sexImageV;
    UILabel *ageLabel;
    UILabel *city;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(FansInfo*)info;

@end
