//
//  LogoViewCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/09.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogoViewCtrl : UIViewController {
	UIImageView *_logoView;
}

@property (nonatomic, retain) IBOutlet UIImageView *logoView;

- (void)requestEnd;
- (void)initAnimation:(NSString *)animationID duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end
