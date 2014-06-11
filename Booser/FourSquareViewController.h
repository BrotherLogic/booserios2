//
//  FourSquareViewController.h
//  Booser
//
//  Created by Simon Tucker on 10/06/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourSquareViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (void) setFoursquareList: (NSArray *) list;

@property (weak, nonatomic) IBOutlet UITableView *FoursquareTable;

@end
