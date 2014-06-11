//
//  MainViewController.m
//  Booser
//
//  Created by Simon Tucker on 28/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "MainViewController.h"
#import "BooserAppDelegate.h"
#import "UICKeyChainStore.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clickedUntappd:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://untappd.com"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BooserAppDelegate *appDelegate = (BooserAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mainView = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *token = [UICKeyChainStore stringForKey:@"untappd_token"];
    NSLog(@"GERE = %@",token);
    /*if (token){
        NSLog(@"Running segue");
        [self runBeerList];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runLogin:(id)sender {
    
    NSString *loginURL = @"https://untappd.com/oauth/authenticate/?client_id=7611889A7239B8DBB5A91C4AF567EED2BEBF18D1&response_type=code&redirect_url=booserapp://blah.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loginURL]];
}

- (void) runBeerList {
    NSLog(@"Trans");
    [self performSegueWithIdentifier:@"GetBeerList" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
