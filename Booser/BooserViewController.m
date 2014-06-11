//
//  BooserViewController.m
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "BooserViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BooserTableViewCell.h"
#import "UICKeyChainStore.h"
#import "FourSquareViewController.h"

@interface BooserViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locateSpinner;

@end

@implementation BooserViewController

@synthesize locateSpinner;
@synthesize locateLabel;
@synthesize booserTableView;

CLLocationManager *locationManager;
NSOperationQueue *queue;
NSMutableDictionary *beerScore;
NSMutableDictionary *beerDetails;
NSMutableArray *beerKeys;
NSString *token;
bool gotLoc;
NSString *oldLocation;
NSArray *venues;
NSString *currentLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSLog(@"View did load");
    
    token = [UICKeyChainStore stringForKey:@"untappd_token"];
    oldLocation = @"";
    
    //Prepare the queue and UI
    queue = [NSOperationQueue mainQueue];
    beerScore = [[NSMutableDictionary alloc]init];
    beerDetails = [[NSMutableDictionary alloc] init];
    beerKeys = [[NSMutableArray alloc] init];
    
    //Start the spinner spinning
    locateSpinner.hidesWhenStopped = TRUE;
    [locateSpinner startAnimating];
    gotLoc = false;
    
    //Grab the location
    NSLog(@"Current location = %@",currentLocation);
    if (currentLocation == nil  ){
        [self grabLocation];
    } else {
        [self resolveVenue:currentLocation];
    }
}

- (void) setLocation:(NSString *)location {
    currentLocation = location;
}

- (void) grabLocation
{
    locationManager = [[CLLocationManager alloc] init];
    NSLog(@"Grabbing Location %d", [CLLocationManager authorizationStatus]);
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager requestAlwaysAuthorization];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    NSLog(@"Updating Location %@",locationManager);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed with error %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"Finished with error %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Received location %d",gotLoc);
    if (!gotLoc && locations.count > 0) {
        
        [locationManager stopUpdatingLocation];
        
        CLLocation *loc = locations[0];
        [locateLabel setTitle:[NSString stringWithFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude] forState:UIControlStateNormal];
        gotLoc = true;
        [self runLocate:loc];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Running Segue %@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"relocate"]){
        FourSquareViewController *vc = [segue destinationViewController];
        NSLog(@"Sending %@",[venues class]);
        [vc setFoursquareList: venues];
    }
}

- (void) getBeerList: (NSString *) untappdID {
    NSURL *untappdBeerListURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.untappd.com/v4/venue/checkins/%@?access_token=%@",untappdID,token]];
    
    NSLog(@"Trying %@",untappdBeerListURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:untappdBeerListURL];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [locateSpinner stopAnimating];
       
        
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if([[[jsonDict objectForKey:@"meta"] objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:500]]){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      @"Error" message:@"Cannot reach untappd" delegate:self
                                                     cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            NSArray *beerList = [[[jsonDict objectForKey:@"response"] objectForKey:@"checkins"] objectForKey:@"items"];
            
            //Process the beer list
            for (int i = 0 ; i < beerList.count ; i++) {
                NSString *beerID = [NSString stringWithFormat:@"%@",[[beerList[i] objectForKey:@"beer"] valueForKey:@"bid"]];
                if (![beerDetails objectForKey:beerID]) {
                    [beerDetails setValue:beerList[i] forKey:beerID];
                    [booserTableView reloadData];
                    [beerKeys addObject:beerID];
            
                    //Load up the beer info
                    NSURL *untappdVenueURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.untappd.com//v4/beer/info/%@?access_token=%@",beerID,token]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:untappdVenueURL];
                    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        NSError *error = nil;
                        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                        if([[[jsonDict objectForKey:@"meta"] objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:500]]){
                            //Ignore this
                            NSLog(@"Cannot get for %@",beerID);
                            [beerScore setValue:@"-1" forKey:beerID];
                        } else {
                            NSString *score = [NSString stringWithFormat:@"%@", [[[jsonDict objectForKey:@"response"] objectForKey:@"beer"] objectForKey:@"rating_score"]]  ;
                            NSString *bID = [NSString stringWithFormat:@"%@", [[[jsonDict objectForKey:@"response"] objectForKey:@"beer"]   objectForKey:@"bid"]];
                            [beerScore setValue:score forKey:bID];
                            [booserTableView reloadData];
                        }
                    }];
                }
            }
            [booserTableView reloadData];
        }
    }];
}

- (void) resolveVenue: (NSString *) fourSquareID {
    
    [beerKeys removeAllObjects];
    [booserTableView reloadData];
    
    NSURL *untappdVenueURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.untappd.com/v4/venue/foursquare_lookup/%@?access_token=%@",fourSquareID,token]];
    NSURLRequest *request = [NSURLRequest requestWithURL:untappdVenueURL];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if([[[jsonDict objectForKey:@"meta"] objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:500]]){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Location?" message:@"Cannot identify location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [message show];
        }
        else {
            NSArray *venues = [[[jsonDict objectForKey:@"response"] objectForKey:@"venue"] objectForKey:@"items"];
            if (venues.count > 0) {
                [locateLabel setTitle:[venues[0] objectForKey:@"venue_name"] forState:UIControlStateNormal];
                [self getBeerList:[venues[0] objectForKey:@"venue_id"]];
                //[self getBeerList:@"1057107"];
            }
        }
    }];
}

- (void)runLocate:(CLLocation *) location {
    
    NSURL *foursquareURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=URIPWMO3ATOEUUNCITC3UIXDQ1CHHTJCSRG4ZKGA0T3ZQJCO&client_secret=DFAX5L1JU2U3LPW22KIX3AHZCTP32PVIHEBA32QULTMS0HJX&v=20130815&ll=%f,%f",location.coordinate.latitude,location.coordinate.longitude]];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:foursquareURL];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       
        venues = [[jsonDict objectForKey:@"response"] objectForKey:@"venues"];
        if (venues.count > 0) {
            NSLog(@"Got Location from foursquare %@ => %d",oldLocation,[oldLocation isEqualToString:[venues[0] objectForKey:@"id"]]);
            if (![oldLocation isEqualToString:[venues[0] objectForKey:@"id"]]) {
                oldLocation =[venues[0] objectForKey:@"id"];
                [locateLabel setTitle:[venues[0] objectForKey:@"name"] forState:UIControlStateNormal];
                //[self resolveVenue:[venues[0] objectForKey:@"id"]];
            } else {
                [locateSpinner stopAnimating];
            }
        }
    }];
}

#pragma tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (beerKeys.count > 0){
        return beerKeys.count;
    } else {
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Sort the beer keys
    NSArray *sortedArray;
    sortedArray = [beerKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [beerScore objectForKey:a];
        NSString *second = [beerScore objectForKey:b];
        return -[first compare:second];
    }];
    
    static NSString *MyIdentifier = @"booserCell";
    
    BooserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[BooserTableViewCell alloc] init];
    }
    
    NSDictionary *data = [beerDetails objectForKey: sortedArray[indexPath.item]];
    if ([beerScore objectForKey:sortedArray[indexPath.item]]){
       // NSLog(@"Running update");
        [cell setData:data score:[beerScore objectForKey:sortedArray[indexPath.item]]];
    } else {
        [cell setData:data];
    }
        
    return cell;
}

@end
