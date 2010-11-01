    //
//  UIImageViewWithTouch.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/07.
//  Copyright 2010 3di. All rights reserved.
//

#import "UIImageViewWithTouch.h"


@implementation UIImageViewWithTouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSInteger tapCount = [[touches anyObject] tapCount];
//	NSLog(@"touchesBegin tapCount: %d", tapCount);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSInteger tapCount = [[touches anyObject] tapCount];
//	NSLog(@"touchesMoved tapCount: %d", tapCount);
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSInteger tapCount = [touch tapCount];
	CGPoint point = [touch locationInView:self];

	if (tapCount > 0)
	{
//		NSLog(@"touchesEnded tapCount: %d x: %f y: %f", tapCount, point.x, point.y);
		NSNumber *index = [NSNumber numberWithInt:self.tag];
		NSNumber *px = [NSNumber numberWithFloat:point.x];
		NSNumber *py = [NSNumber numberWithFloat:point.y];

		NSArray *dic = [NSArray arrayWithObjects:index, px, py, nil];
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter postNotificationName:@"imageTouchEvent" object:dic userInfo:nil];
	}
}

@end
