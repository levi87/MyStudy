//
//  CommentsViewController.h
//  freebao
//
//  Created by freebao on 13-7-3.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsCell.h"
#import "AppDelegate.h"
#import "BlankCell.h"
#import "CustomActionSheet.h"
#import "WeiBoMessageManager.h"
#import "CommentInfo.h"
#import "FaceToolBar.h"

@class WeiBoMessageManager;
@interface CommentsViewController : UITableViewController <FaceToolBarDelegate>{
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *commentsArray;
}

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;

@end
