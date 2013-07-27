//
//  PageViewController.h
//  freebao
//
//  Created by freebao on 13-7-23.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusViewContrillerBase.h"
#import "TwitterVC.h"
#import "LikersViewController.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "UserLocationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "URBSegmentedControl.h"
#import "FansInfo.h"
#import "FansCell.h"
#import "FollowerCell.h"
#import "FollowerInfo.h"

#import "REPhotoObjectProtocol.h"
#import "REPhotoGroup.h"
#import "Photo.h"
#import "ThumbnailView.h"
#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface PageViewController : StatusViewContrillerBase <AVAudioPlayerDelegate>
{
    NSString *userID;
    int _page;
    long long _maxID;
    BOOL _shouldAppendTheDataArr;
    UILabel *tittleLabel;
    UIButton *backButton;
    
    LikersViewController *likeVC;
    CommentViewController *commentVC;
    StatusCell *tmpStatusCell;
    StatusCell *tmpStatusCellL;
    
    int currentView;
    
    
    //Fans
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
    NSMutableArray *headPhotos;
    NSMutableArray *likersArray;
    NSMutableArray *photoArray;
    int currentPage;
    int maxPage;
    
    //Follow
    NSString *_cellContentIdFollow;
    BOOL _isRefreshFollow;
    BOOL isFirstFollow;
    NSMutableArray *headPhotosFollow;
    NSMutableArray *followersArray;
    int currentPageFollow;
    int maxPageFollow;
    
    //Photo
    NSMutableArray *_ds;
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain) NSTimer *timer;

@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property (strong, nonatomic) IBOutlet UIView *profileHeaderView;

//Fans
@property NSString *cellContentId;
@property BOOL isRefresh;

//Follow
@property NSString *cellContentIdFollow;
@property BOOL isRefreshFollow;

//Photo
//@property (nonatomic, strong, setter = setDatasource:) NSMutableArray *photoDatasource;
@property (nonatomic, readwrite) BOOL groupByDate;
@property (nonatomic, readwrite) Class thumbnailViewClass;
@property (nonatomic, retain) NSMutableArray *ds;

-(void)clearCache;

- (void)reloadPhotoData;

@end
