//
//  ReadViewACtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "ReadViewBaseCtrl.h"
#import "UIViewWithTouchesDelegate.h"
#import "MyScrollView.h"

enum {
  page_mode_none,
  page_mode_curl_start,
  page_mode_curling,
  page_mode_release,
  page_mode_curl_right,
  page_mode_curl_left,
  page_mode_tap_on_zoom,
  page_mode_zoom,
  page_mode_wait
};

enum {
  left,
  right
};

enum {
  right_page,
  left_page,
  middle_page,
  bottom_page
};

@interface ReadViewACtrl : ReadViewBaseCtrl <UIScrollViewDelegate> {
	MyScrollView *_scrollView;

	UIView * _bookView;
	UIView * _rightView;
	UIView * _leftView;
	UIViewWithTouchesDelegate * _pageCurlView;

	float image_width, image_height;

	NSInteger _mode;
	NSInteger _curl_side;
	NSInteger _curl_from;
	NSInteger _curl_to;
	float _curl_ratio;

	UIButton * _nextButton;
	UIButton * _prevButton;

	NSMutableArray * fingers;

	CGPoint touchStartPoint;
	
	CAGradientLayer * centerPageRightShadow;
	CAGradientLayer * centerPageLeftShadow;
	CAGradientLayer * middlePageRightShadowLayer;
	CAGradientLayer * middlePageLeftShadowLayer;

	CAGradientLayer * topPageRightOutShadowLayer;
	CAGradientLayer * topPageCurlShadowLayer;
	CAGradientLayer * topPageLeftOutShadowLayer;
	CAGradientLayer * topPageOverlayLayer;

	CAGradientLayer * topPageRightShadowLayer;
	CAGradientLayer * topPageLeftShadowLayer;

	CAGradientLayer * rightPageShadow;

	CALayer *centerPageLine;
	CALayer *bottomLayer;
	CALayer *leftPageLayer;
	CALayer *leftPageImageLayer;
	CALayer *rightPageLayer;
	CALayer *rightPageImageLayer;

	CALayer *middleLayer;
	CALayer *middlePageLayer;
	CALayer *middlePageImageLayer;

	CALayer *topLayer;
	CALayer *topPageLayer;
	CALayer *topPageImageLayer;

	float image_margin_x, image_margin_y;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)resetContentsSize;
- (void)setPage:(NSInteger)selectPage windowMode:(NSInteger)windowMode;
- (void)setPageForSingleFace:(NSInteger)selectPage;
- (void)setPageForDoubleFace:(NSInteger)selectPage;
- (void)releaseFarBooks:(NSInteger)targetPage;
- (CGRect)getAspectFittingImageRect:(UIImage *)im0;
- (void)curlPageToLeft:(float)curlRatio;
- (void)curlPageToRight:(float)curlRatio;
- (void)notifyGoToNextPage;
- (void)notifyGoToPrevPage;
- (float) getAnotherSide:(NSInteger) side;
- (CGImageRef)getImageRefFromUIImage:(UIImage *)im0;

@end
