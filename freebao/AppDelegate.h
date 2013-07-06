//
//  AppDelegate.h
//  freebao
//
//  Created by freebao on 13-5-28.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "XMPPReconnect.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,XMPPStreamDelegate,XMPPReconnectDelegate>
{
    NSManagedObjectContext         *_managedObjContext;
    NSManagedObjectModel           *_managedObjModel;
    NSPersistentStoreCoordinator   *_persistentStoreCoordinator;

    XMPPStream *_xmppStream;
    XMPPReconnect *_xmppReconnect;
    GCDAsyncSocket *_gSocket;
    
    BOOL isOpen;
    NSString *password;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic,retain,readonly) NSManagedObjectContext         *managedObjContext;
@property (nonatomic,retain,readonly) NSManagedObjectModel           *managedObjModel;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator   *persistentStoreCoordinator;

@property (nonatomic,readonly) XMPPStream *xmppStream;
@property (nonatomic,readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic,readonly) GCDAsyncSocket *gSocket;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disConnect;
//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;
@end
