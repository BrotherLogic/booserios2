//
//  FoursquareTableCellTableViewCell.m
//  Booser
//
//  Created by Simon Tucker on 10/06/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "FoursquareTableCell.h"

@implementation FoursquareTableCell

@synthesize MainLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setLabel: (NSString *) label{
    MainLabel.text = label;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
