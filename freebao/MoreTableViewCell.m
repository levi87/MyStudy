//
//  MoreTableViewCell.m
//  freebao
//
//  Created by freebao on 13-7-12.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "NewLoginViewController.h"

@implementation MoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = CGRectMake(10, 20, 300, 44);
        logoutButton.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        [logoutButton setTitle:NSLocalizedString(@"MENU_Logout", nil) forState:UIControlStateNormal];
        [logoutButton.titleLabel setFont:[UIFont fontWithName:FONT size:18]];
        [logoutButton setTitleColor:[UIColor colorWithRed:255/255.0 green:44/255.0 blue:44/255.0 alpha:1] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:logoutButton];
        tmpImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more_chevron.png"]];
        self.accessoryView = tmpImageV;
        [self.textLabel setFont:[UIFont fontWithName:FONT size:15]];
//        CGRect frame = self.textLabel.frame;
//        frame.size.height = 42;
//        frame.origin.y = 10;
//        self.textLabel.frame = frame;

    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height - 1, rect.size.width - 20, 0.5));
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonHide:(BOOL)value {
    logoutButton.hidden = value;
}

- (void)setAccessoryViewHide:(BOOL)value {
    tmpImageV.hidden = value;
}

-(void)logOutButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MENU_Logout", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"cancel",nil];
    alert.delegate = self;
    
    [alert show];
    [[NSUserDefaults standardUserDefaults] setObject:FB_LOGIN forKey:FB_LOGIN_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"ok");
        NewLoginViewController *loginVC = [[NewLoginViewController alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:FB_LOGOFF forKey:FB_LOGIN_STATUS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController *navNewlogin = [[UINavigationController alloc]initWithRootViewController:loginVC];

        [self.window.rootViewController presentViewController:navNewlogin animated:YES completion:nil];
        
    }
}

@end
