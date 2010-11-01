//
//  ReadViewBCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadViewBaseCtrl.h"

@interface ReadViewBCtrl : ReadViewBaseCtrl {
	UIScrollView *_scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)setPage:(NSInteger)selectPage;
- (void)releaseFarBooks:(NSInteger)targetPage;

@end
