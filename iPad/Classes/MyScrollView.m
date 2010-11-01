//
//  MyScrollView.m
//  WePublish
//
//  Created by NEO on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"


@implementation MyScrollView

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
  [self.delegate touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent*)event {
  [self.delegate touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent*)event {
  [self.delegate touchesEnded:touches withEvent:event];
}

- (void) touchesCanceled:(NSSet *)touches withEvent:(UIEvent*)event {
  [self.delegate touchesCanceled:touches withEvent:event];
}
@end
