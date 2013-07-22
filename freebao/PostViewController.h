//
//  PostViewController.h
//  freebao
//
//  Created by freebao on 13-7-22.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"

@interface PostViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,MKMapViewDelegate,CLLocationManagerDelegate> {
    UIImagePickerController *_imagePicker;
    CustomActionSheet *_customActionSheet;
    MKMapView *_mkMap;
    BOOL _isLocation;
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}
@property (weak, nonatomic) IBOutlet UIButton *selectPictureButton;
@property (weak, nonatomic) IBOutlet UIView *upperView;
- (IBAction)getUserLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)SelectPictureAction:(id)sender;
@end
