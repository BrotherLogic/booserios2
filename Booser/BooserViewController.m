//
//  BooserViewController.m
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "BooserViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BooserViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locateSpinner;
@property (weak, nonatomic) IBOutlet UITextField *locateLabel;

@end

@implementation BooserViewController

@synthesize locateSpinner;
@synthesize locateLabel;

CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Start the spinner spinning
    locateSpinner.hidesWhenStopped = TRUE;
    [locateSpinner startAnimating];
    
    //Grab the location
    [self grabLocation];
}

- (void) grabLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        [locationManager stopUpdatingLocation];
        
        CLLocation *loc = locations[0];
        locateLabel.text = [NSString stringWithFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude];
    }
}

@end
