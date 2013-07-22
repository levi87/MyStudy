//
//  PostViewController.m
//  freebao
//
//  Created by freebao on 13-7-22.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "PostViewController.h"
#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define FONT @"HelveticaNeue-Light"

@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _customActionSheet = [[CustomActionSheet alloc] init];
    [_customActionSheet addButtonWithTitle:@"Take Photo"];
    [_customActionSheet addButtonWithTitle:@"Library"];
    [_customActionSheet addButtonWithTitle:@"Cancel"];
    _customActionSheet.delegate = self;
    _mkMap = [[MKMapView alloc] init];
    _mkMap.delegate = self;
    _isLocation = NO;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@" x, %f y, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    [_geocoder reverseGeocodeLocation:tmpLocation completionHandler:^(NSArray *placeMarks, NSError *error) {
//        NSLog(@"[levi] place Marks %@", placeMarks);
        for (CLPlacemark *placeMark in placeMarks)  {
            NSString *country = placeMark.country;
            NSString *city = placeMark.locality;
            NSString *thoroughfare = placeMark.thoroughfare;
            NSString *subLocality = placeMark.subLocality;
            NSString *subThoroughfare = placeMark.subThoroughfare;
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", country, city, subLocality , thoroughfare, subThoroughfare];
            }
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TABBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSelectPictureButton:nil];
    [self setUpperView:nil];
    [self setUserLocationButton:nil];
    [self setAddressLabel:nil];
    [super viewDidUnload];
}

- (IBAction)getUserLocationAction:(id)sender {
    NSLog(@"show user location,,,");
    if (_isLocation) {
        self.addressLabel.text = @"";
        _mkMap.showsUserLocation = NO;
        _isLocation = NO;
        [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_off"] forState:UIControlStateNormal];
    } else {
        [SVProgressHUD showWithStatus:@"Locating..."];
        _mkMap.showsUserLocation = YES;
        _isLocation = YES;
        [self.userLocationButton setImage:[UIImage imageNamed:@"icon_postedit_location_on"] forState:UIControlStateNormal];
    }
}


- (IBAction)backButtonAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)SelectPictureAction:(id)sender {
    [_customActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 1:
            NSLog(@"1");
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:_imagePicker animated:YES];
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"[levi]take photo...");
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSData *pictureData = UIImageJPEGRepresentation(editedImage,1);
    [self.selectPictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
}
@end
