//
//  FourSquareViewController.m
//  Booser
//
//  Created by Simon Tucker on 10/06/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "FourSquareViewController.h"
#import "FoursquareTableCell.h"
#import "BooserViewController.h"

@interface FourSquareViewController ()

@end

@implementation FourSquareViewController

@synthesize FoursquareTable;
NSArray *venues;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
}

- (void) setFoursquareList:(NSArray *)list {
    NSLog(@"Arrived");
    venues = list;
    NSLog(@"Received venues");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Running Segue %@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"chosenLocation"]){
        BooserViewController *vc = [segue destinationViewController];
        NSLog(@"Sending %@",[venues class]);
        NSString *tableId = [venues[FoursquareTable.indexPathForSelectedRow.item] objectForKey:@"id"];
        NSLog(@"Got id = %@",tableId);
        [vc setLocation:tableId];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Requested number of sections");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *MyIdentifier = @"foursquareCell";
    
    FoursquareTableCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[FoursquareTableCell alloc] init];
    }
    NSLog(@"Setting name = %@", [venues[indexPath.item] objectForKey:@"name"]);
    [cell setLabel:[venues[indexPath.item] objectForKey:@"name" ]];
    
    return cell;
}

@end
