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
@interface CommentViewController : ViewController <UITableViewDataSource,UITableViewDelegate,FaceToolBarDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,CommentsCellDelegate> {
    WeiBoMessageManager *manager;
    NSString *_cellContentId;
    BOOL _isRefresh;
    BOOL isFirst;
    __weak IBOutlet UIImageView *recordPowerImageView;
    __weak IBOutlet UIView *recordPowerView;
    __weak IBOutlet UILabel *recordViewLabel;
    __weak IBOutlet UILabel *recordLengthLabel;
    __weak IBOutlet UIView *recordBackgroundView;
    NSInteger fingerX;
    NSInteger fingerY;
    AVAudioRecorder *recorder;
    NSTimer *recordtTimer;
    NSTimer *playTimer;
    NSString *voiceRecordLength;
    NSString *tmpVoicePath;
@private
    NSMutableArray *headPhotos;
    NSMutableArray *commentsArray;
    FaceToolBar* bar;
    NSIndexPath *tmpIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (retain, nonatomic) AVAudioPlayer *avPlay;

@property NSString *cellContentId;
@property BOOL isRefresh;

-(void)clearCache;
@end
