//
//  AboutViewController.h
//  freebao
//
//  Created by levi on 13-7-28.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *itemsArray;
    UILabel *_tittleLabel;
    UIButton *backButton;
    UIButton *languageButton;
    UIView *tittleView;
    UIView *tittleLineView;
}

@property (weak, nonatomic) IBOutlet UITableView *aboutTableview;
@end
