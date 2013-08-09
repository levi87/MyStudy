//
//  ContactCommonCell.h
//  freebao
//
//  Created by 许 旭磊 on 13-8-9.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCommonCell : UITableViewCell{
    UIImageView *_headImageView;
    UILabel *_typeLabel;
    UILabel *_detailLabel;
    UIImageView *_rightImageView;
    UILabel *_numLabel;
}

- (void)setType:(NSString *)type;
- (void)setHeadImage:(UIImage *) headImage;
- (void)setDetail:(NSString *) detail;
- (void)setRightImage:(UIImage *) rightImage;
- (void)setNum:(NSString *)num;
@end
