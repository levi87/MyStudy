//
//  PeopleMayKnowCell.h
//  freebao
//
//  Created by freebao on 13-8-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleMayKnowInfo.h"

@class EGOImageView;
@interface PeopleMayKnowCell : UITableViewCell {
@private
    EGOImageView* headImageView;
    UILabel *nickNameLabel;
    UIImageView *sexImageV;
    UILabel *ageLabel;
    UILabel *cityLabel;
    UILabel *commLabel;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

- (void)setCellValue:(PeopleMayKnowInfo*)info;

@end
