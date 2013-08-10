//
//  NoticeCell.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-10.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
}

- (void)setName:(NSString *)name;
- (void)setHeadImage:(UIImage *) headImage;
- (void)setDetail:(NSString *) detail;
- (void)setTime:(NSString *)time;
@end
