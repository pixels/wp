//
//  DetailViewCtrl.h
//  iTestRotation
//
//  Created by Yusuke Kikkawa on 10/06/25.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewCtrl : UIViewController {
	UIImageView *_frontImage;
//	UILabel *_titleText;
//	UILabel *_authorText;
	UITextView *_titleText;
	UITextView *_authorText;
	UITextView *_reviewView;
}

@property (nonatomic, retain) IBOutlet UIImageView *frontImage;
//@property (nonatomic, retain) IBOutlet UILabel *titleText;
//@property (nonatomic, retain) IBOutlet UILabel *authorText;
@property (nonatomic, retain) IBOutlet UITextView *titleText;
@property (nonatomic, retain) IBOutlet UITextView *authorText;
@property (nonatomic, retain) IBOutlet UITextView *reviewView;

- (IBAction)clickBack:(UIButton*)sender;
- (IBAction)clickRead:(UIButton*)sender;

@end
