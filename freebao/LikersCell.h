//
//  LikersCell.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface LikersCell : UITableViewCell {
@private
    EGOImageView* headImageView;
}

- (void)setHeadPhoto:(NSString*)headPhoto;

@end
