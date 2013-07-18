//
//  CommentViewController.h
//  freebao
//
//  Created by freebao on 13-7-18.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ViewController.h"
#import "CommentsCell.h"
#import "AppDelegate.h"
#import "BlankCell.h"
#import "CustomActionSheet.h"
#import "WeiBoMessageManager.h"
#import "CommentInfo.h"
#import "FaceToolBar.h"

@class WeiBoMessageManager;
@interface CommentViewController : ViewController <UITableViewDataSource,UITableViewDelegate,RMSwipeTableViewCellDelegate,FaceToolBarDelegate> {
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *commentsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;
@end
