//
//  BooserAppDelegate.m
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "BooserAppDelegate.h"
#import "UICKeyChainStore.h"

@implementation BooserAppDelegate

@synthesize mainView;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [[url query] class] );
    NSRange ranger = [[url query] rangeOfString:@"code="];
    if (ranger.location != NSNotFound){
        NSString *code = [[url query] substringFromIndex:ranger.location + ranger.length];
        
        NSString *newURL = [NSString stringWithFormat:@"https://untappd.com/oauth/authorize/?client_id=7611889A7239B8DBB5A91C4AF567EED2BEBF18D1&client_secret=18790ABFE479B1EDB40CD0174061069392AC6DD5&response_type=code&redirect_url=booserapp://blah.com&code=%@",code];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newURL]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *error = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *token = [[jsonDict objectForKey:@"response"] objectForKey:@"access_token"];
            
            [self loginWithToken:token];
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

-(void)loginWithToken:(NSString *) token {
    //Store the token in the keychain
    [UICKeyChainStore setString:token forKey:@"untappd_token"];
    NSLog(@"Stored Token %@",token);
    [mainView performSegueWithIdentifier:@"GetBeerList" sender:self];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
