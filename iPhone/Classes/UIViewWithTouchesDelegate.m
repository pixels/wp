//
//  UIViewWithTouchesDelegate.m
//  WePublish
//
//  Created by NEO on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewWithTouchesDelegate.h"

@implementation UIViewWithTouchesDelegate

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [delegate view:self touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     [delegate view:self touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
     [delegate view:self touchesEnded:touches withEvent:event];
}

-(void)touchesCanceled:(NSSet *)touches withEvent:(UIEvent *)event {
     [delegate view:self touchesCanceled:touches withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
