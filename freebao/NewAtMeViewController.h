//
//  HomePageNewViewController.h
//  freebao
//
//  Created by xxl on 13-7-29.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoMessageManager.h"
#import "CommentInfo.h"
#import "StatusNewCell.h"
#import "StatusNewImageCell.h"
#import "StatusInfo.h"
#import "CustomActionSheet.h"
#import "LikersViewController.h"
#import "CommentViewController.h"
#import "UserLocationViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define FONT @"HelveticaNeue"

@class WeiBoMessageManager;
@interface NewAtMeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,StatusNewCellDelegate,StatusNewImageCellDelegate,AVAudioPlayerDelegate,UIActionSheetDelegate> {
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *statusArray;
    
    LikersViewController *likeVC;
    CommentViewController *commentVC;
    
    UILabel *tittleLabel;
    UIButton *backButton;
    NSIndexPath *tmpIndexPath;
    
    NSString *currentTransLanguage;
    
    int currentPage;
    int maxPage;
    CustomActionSheet *_actionSheet;
}

@property (strong, nonatomic) UITableView *homeTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (retain, nonatomic) AVAudioPlayer *avPlay;

@property NSString *cellContentId;
@property BOOL isRefresh;
@end
