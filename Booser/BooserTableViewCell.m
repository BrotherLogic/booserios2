//
//  BooserTableViewCell.m
//  Booser
//
//  Created by Simon Tucker on 25/05/2014.
//  Copyright (c) 2014 Brotherlogic. All rights reserved.
//

#import "BooserTableViewCell.h"

@implementation BooserTableViewCell
@synthesize breweryNameLabel;
@synthesize beerNameLabel;
@synthesize cellSpinner;
@synthesize scoreLabel;
@synthesize myScoreLabel;

-(void) setData: (NSDictionary *) data score: (NSString *) score{
    breweryNameLabel.text = [[data objectForKey:@"brewery"] objectForKey:@"brewery_name"];
    beerNameLabel.text = [[data objectForKey:@"beer"] objectForKey:@"beer_name"];
    NSString *myScoreText =[NSString stringWithFormat:@"%@",[[data objectForKey:@"beer"] objectForKey:@"auth_rating"]];
    if (![myScoreText isEqualToString:@"0"]) {
        myScoreLabel.text = myScoreText;
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
        myScoreLabel.text = @"";
        [self setBackgroundColor:[UIColor greenColor]];

    }
    scoreLabel.text = score;
  
    
    cellSpinner.hidesWhenStopped = true;
    [cellSpinner stopAnimating];
}


-(void) setData: (NSDictionary *) data {
    breweryNameLabel.text = [[data objectForKey:@"brewery"] objectForKey:@"brewery_name"];
    beerNameLabel.text = [[data objectForKey:@"beer"] objectForKey:@"beer_name"];
    
    cellSpinner.hidesWhenStopped = true;
    [cellSpinner startAnimating];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
