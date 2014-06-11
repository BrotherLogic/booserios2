//
//  BooserTableViewCell.h
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *breweryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cellSpinner;
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;

-(void) setData: (NSDictionary *) data;
-(void) setData: (NSDictionary *) data score: (NSString *) score;

@end
