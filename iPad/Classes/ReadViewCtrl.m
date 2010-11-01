    //
//  ReadViewCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import "ReadViewCtrl.h"
#import "WindowModeType.h"
#import "ReadViewBaseCtrl.h"
#import "ReadViewACtrl.h"
#import "ReadViewBCtrl.h"
#import "DirectionType.h"
#import "Define.h"

#define CHANGE_ORIENTATION_ANIM_ID @"change_orientation_anim"

@implementation ReadViewCtrl
@synthesize slider = _slider;
@synthesize startLabel = startLabel_;
@synthesize endLabel = endLabel_;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  NSLog(@"view did load");
  [super viewDidLoad];
	
  _windowMode = MODE_NONE;
  [_slider addTarget:self action:@selector(onUpdateSlider:) forControlEvents:UIControlEventValueChanged];
  _slider.minimumValue = 1;
  _slider.maximumValue = _pageNum - _fakePage;
  _slider.value = _pageNum;
	
  NSInteger maxPage = _pageNum - _fakePage;
  //NSLog(@"initialize");
  _readViewACtrl = [[ReadViewACtrl alloc] initWithNibName:@"ReadViewA" bundle:0];

  [self.view insertSubview:_readViewACtrl.view atIndex:0];
  // [self.view setBackgroundColor:[UIColor blueColor]]; // FOR DEBUG
  [_readViewACtrl.view setAlpha:0];
  [_readViewACtrl setup:_uuid selectPage:_selectPage pageNum:maxPage direction:_direction windowMode:_windowMode];

  [self initAnimation:CHANGE_ORIENTATION_ANIM_ID duration:0.25f];

  [_readViewACtrl.view setAlpha:1];
  [UIView commitAnimations];

  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(onTouchImage:) name:@"imageTouchEvent" object:nil];
  [notificationCenter addObserver:self selector:@selector(onGoToNextPage:) name:@"goToNextPageEvent" object:nil];
  [notificationCenter addObserver:self selector:@selector(onGoToPrevPage:) name:@"goToPrevPageEvent" object:nil];
  [notificationCenter addObserver:self selector:@selector(onBookmarkSaveSelect:) name:BOOKMARK_SAVE_EVENT object:nil];
  [notificationCenter addObserver:self selector:@selector(onPageChangeSelect:) name:PAGE_CHANGE_EVENT object:nil];
}

- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum fakePage:(NSInteger)fakePage direction:(NSInteger)direction windowMode:(NSInteger)windowMode {
  _direction = direction;
  _uuid = [uuid retain];
  _pageNum = pageNum;
  _fakePage = fakePage;
  _selectPage = selectPage;
}

- (void)initAnimation:(NSString *)animationID duration:(NSTimeInterval)duration {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [UIView beginAnimations:animationID context:context];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationDelegate: self];
  [UIView setAnimationDidStopSelector:@selector(onAnimationEnd:finished:context:)];	
}

- (void)changeOrientation {
	NSInteger maxPage;

//	[_readViewACtrl changeOrientation:_windowMode];
	maxPage = _pageNum - _fakePage;
	
	_selectPage = _readViewACtrl.currentPage;
	
	[_readViewACtrl releaseAllBooks];
	//[self.view insertSubview:_readViewACtrl.view atIndex:0];

	[_readViewACtrl.view setAlpha:0];
	[_readViewACtrl setup:_uuid selectPage:_selectPage pageNum:maxPage direction:_direction windowMode:_windowMode];
	[self initAnimation:CHANGE_ORIENTATION_ANIM_ID duration:0.25f];

	[_readViewACtrl.view setAlpha:1];
	[UIView commitAnimations];
}

- (void)cleanupCurrentView:(NSInteger)requireMode {
	      if (_readViewACtrl)
	      {
			[_readViewACtrl releaseAllBooks];
			[_readViewACtrl.view removeFromSuperview];
			[_readViewACtrl release];
			_readViewACtrl = nil;
		}
}

- (void)pageNext {
	CGRect frame = self.view.frame;

	if (![_readViewACtrl isNext])
	  return;
		
	[_readViewACtrl next];
		
	//frame.size.width = WINDOW_AW;
	//frame.size.height = WINDOW_AH;
	
	self.view.frame = frame;
	
	[self initAnimation:nil duration:0.5f];
	//	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView commitAnimations];
}

- (void)pagePrev {
	
	if (![_readViewACtrl isPrev])
	  return;
	      
	[_readViewACtrl prev];
	
	[self initAnimation:nil duration:0.5f];
	//	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];	
	[UIView commitAnimations];
}

- (void)onUpdateSlider:(UISlider *)aSlider {
	int number = floor(_slider.value);

//	if (_direction == DIRECTION_LEFT)
//		number = _pageNum - number + 1;
	
      [_readViewACtrl requestPage:number];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	NSInteger requireMode;
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
	  NSLog(@"require mode A");
		requireMode = MODE_A;
	} else {
	  NSLog(@"require mode B");
		requireMode = MODE_B;
	}
	
	if (requireMode != _windowMode)
	{
		_windowMode = requireMode;
		[self changeOrientation];
	}
    return YES;
}

-(void)onAnimationEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if ([animationID isEqualToString:CHANGE_ORIENTATION_ANIM_ID]) {
	  CGRect frame;
	  if (_windowMode == MODE_A) {
	    //[_lButton setFrame:CGRectMake((_direction == DIRECTION_LEFT) ? 20 : 408, 844, 340, 140)];
	    //[_rButton setFrame:CGRectMake((_direction == DIRECTION_LEFT) ? 408 : 20, 844, 340, 140)];
	    frame = _slider.frame;
	    //			frame.origin.x = WINDOW_AW - frame.size.width - 20;
//	    frame.origin.y = 30;
	    _slider.frame = frame;

	    //[self cleanupCurrentView:MODE_B];
	    self.view.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
	  } else {
	    //[_lButton setFrame:CGRectMake((_direction == DIRECTION_LEFT) ? 20 : 664, 588, 340, 140)];
	    //[_rButton setFrame:CGRectMake((_direction == DIRECTION_LEFT) ? 664 : 20, 588, 340, 140)];
	    frame = _slider.frame;
	    //			frame.origin.x = WINDOW_BW - frame.size.width - 20;
//	    frame.origin.y = 30;
	    _slider.frame = frame;

	    //[self cleanupCurrentView:MODE_A];
	    self.view.frame = CGRectMake(0, 0, WINDOW_BW, WINDOW_BH);
	  }
	  endLabel_.text = (_direction == DIRECTION_LEFT) ? @"始め" : @"終わり";
	  startLabel_.text = (_direction == DIRECTION_LEFT) ? @"終わり" : @"始め";
	  if (_direction == DIRECTION_LEFT) {
	    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 180 / 180.0f);
	    _slider.transform = trans;
	  }
	}
}

- (IBAction)onBackClick:(id)sender {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotificationName:READ_TO_SELECT_EVENT object:nil userInfo:nil];
}

- (void)onTouchImage:(NSNotification *)notification {
	//	NSLog(@"touchesEnded tapCount: %d x: %f y: %f", tapCount, point.x, point.y);
  NSArray *dic = [notification object];
  NSNumber *index = [dic objectAtIndex:0];
  NSNumber *px = [dic objectAtIndex:1];
  //	NSNumber *py = [dic objectAtIndex:2];
  //	NSLog(@"onTouchImage index: %d px: %f py: %f", [index intValue], [px floatValue], [py floatValue]);

  if ([px floatValue] < (self.view.frame.size.width / 2)) {
    if (_direction == DIRECTION_LEFT) {
      [self pageNext];
    } else {
      [self pagePrev];
    }
  } else {
    if (_direction == DIRECTION_LEFT) {
      [self pagePrev];
    } else {
      [self pageNext];
    }
  }
}

- (void)onGoToNextPage:(NSNotification *)notification {
  [self pageNext];
}

- (void)onGoToPrevPage:(NSNotification *)notification {
  [self pagePrev];
}

- (void)onPageChangeSelect:(NSNotification *)notification {
  NSNumber *pageNumber = (NSNumber *)[notification object];

  float rate = [pageNumber floatValue] / _pageNum;
  _slider.value = _slider.maximumValue * rate;

  //NSLog(@"value: %f rate: %f %d", _slider.value, rate, _pageNum);
}

- (void)onBookmarkSaveSelect:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSNumber *currentPage = [userInfo objectForKey:BOOKMARK_PAGE];
  _selectPage = [currentPage intValue];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  if (_windowMode == MODE_A) {
    [self cleanupCurrentView:MODE_A];
  } else {
    [self cleanupCurrentView:MODE_B];
  }

  [self.slider release];
  //[self.lButton release];
  //[self.rButton release];
  [self.startLabel release];
  [self.endLabel release];
  [_uuid release];
  [super dealloc];
}

@end
