//
//  UserLocationViewController.h
//  freebao
//
//  Created by freebao on 13-7-16.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface UserLocationViewController : ViewController
@property (weak, nonatomic) IBOutlet MKMapView *userLocationMap;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;

@end
