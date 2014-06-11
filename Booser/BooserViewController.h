//
//  BooserViewController.h
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BooserViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *booserTableView;
@property (weak, nonatomic) IBOutlet UIButton *locateLabel;

-(void)setLocation: (NSString *)location;

@end
