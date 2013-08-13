//
//  CityUserCell.h
//  freebao
//
//  Created by freebao on 13-8-13.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityUserInfo.h"

@class EGOImageView;
@interface CityUserCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    UIImageView *sexImageV;
    UILabel *ageLabel;
    UILabel *city;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(CityUserInfo*)info;

@end
