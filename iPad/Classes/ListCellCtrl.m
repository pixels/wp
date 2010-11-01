//
//  ListCellCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/10.
//  Copyright 2010 3di. All rights reserved.
//

#import "ListCellCtrl.h"


@implementation ListCellCtrl
@synthesize imageView;
@synthesize titleLabel;
@synthesize authorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[imageView release];
	[titleLabel release];
	[authorLabel release];
    [super dealloc];
}


@end
