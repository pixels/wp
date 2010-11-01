//
//  ListCellCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/10.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListCellCtrl : UITableViewCell {
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *authorLabel;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@end
