//
//  FoursquareTableCellTableViewCell.h
//  Booser
//
//  Created by Simon Tucker on 10/06/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoursquareTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MainLabel;

- (void) setLabel: (NSString *) label;

@end
