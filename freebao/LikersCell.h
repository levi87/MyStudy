//
//  LikersCell.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikerInfo.h"

@class EGOImageView;
@interface LikersCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    UIImageView *sexImageV;
    UILabel *ageLabel;
    UILabel *city;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(LikerInfo*)info;

- (void)setCellLayout;

@end
