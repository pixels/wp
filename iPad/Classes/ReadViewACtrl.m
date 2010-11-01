//
//  ReadViewACtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import "ReadViewACtrl.h"
#import "WindowModeType.h"
#import "Util.h"
#import "Define.h"
#import "DirectionType.h"
#import "UIImageViewWithTouch.h"


@implementation ReadViewACtrl
@synthesize scrollView = _scrollView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];

  _scrollView = [[MyScrollView alloc] init];
  [_scrollView setMinimumZoomScale:MIN_ZOOM_SCALE];
  [_scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
  _scrollView.pagingEnabled = NO;
  _scrollView.delegate = self;
  _scrollView.delaysContentTouches = NO;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = NO;

  _bookView = [[UIView alloc] init];
  [_bookView setUserInteractionEnabled:NO];
  // [_bookView setBackgroundColor:[UIColor redColor]];
  // [_scrollView setBackgroundColor:[UIColor blueColor]];
  [_scrollView addSubview:_bookView];
  [_bookView release];

  bottomLayer = [[CALayer alloc] init];
  bottomLayer.masksToBounds = YES;
  [_bookView.layer addSublayer:bottomLayer];
  [bottomLayer release];

  centerPageLine = [[CAGradientLayer alloc] init];
  centerPageLine.backgroundColor = [[UIColor whiteColor] CGColor];
  [bottomLayer addSublayer:centerPageLine];
  [centerPageLine release];

  rightPageLayer = [[CALayer alloc] init];
  [bottomLayer addSublayer:rightPageLayer];
  rightPageLayer.masksToBounds = YES;
  rightPageImageLayer = [[CALayer alloc] init];
  [rightPageLayer addSublayer:rightPageImageLayer];
  [rightPageImageLayer release];
  [rightPageLayer release];

  leftPageLayer = [[CALayer alloc] init];
  [bottomLayer addSublayer:leftPageLayer];
  leftPageLayer.masksToBounds = YES;
  leftPageImageLayer = [[CALayer alloc] init];
  [leftPageLayer addSublayer:leftPageImageLayer];
  [leftPageImageLayer release];
  [leftPageLayer release];

  centerPageRightShadow = [[CAGradientLayer alloc] init];
  [bottomLayer addSublayer:centerPageRightShadow];
  centerPageLeftShadow = [[CAGradientLayer alloc] init];
  [bottomLayer addSublayer:centerPageLeftShadow];
  [centerPageLeftShadow release];
  [centerPageRightShadow release];

  middleLayer = [[CALayer alloc] init];
  middleLayer.masksToBounds = YES;
  [_bookView.layer addSublayer:middleLayer];
  middlePageLayer = [[CALayer alloc] init];
  middlePageLayer.masksToBounds = YES;
  // middlePageLayer.backgroundColor = [[UIColor redColor] CGColor];
  [middleLayer addSublayer:middlePageLayer];
  middlePageImageLayer = [[CALayer alloc] init];
  middlePageImageLayer.masksToBounds = YES;
  [middlePageLayer addSublayer:middlePageImageLayer];
  [middleLayer release];
  [middlePageLayer release];
  [middlePageImageLayer release];

  middlePageLeftShadowLayer = [[CAGradientLayer alloc] init];
  [middlePageLayer addSublayer:middlePageLeftShadowLayer];
  middlePageRightShadowLayer = [[CAGradientLayer alloc] init];
  [middlePageLayer addSublayer:middlePageRightShadowLayer];
  [middlePageLeftShadowLayer release];
  [middlePageRightShadowLayer release];

  topLayer = [[CALayer alloc] init];
  topLayer.masksToBounds = YES;
  [_bookView.layer addSublayer:topLayer];
  topPageLayer = [[CALayer alloc] init];
  topPageLayer.masksToBounds = YES;
  //topPageLayer.backgroundColor = [[UIColor blueColor] CGColor];
  [topLayer addSublayer:topPageLayer];
  topPageImageLayer = [[CALayer alloc] init];
  topPageImageLayer.masksToBounds = YES;
  topPageImageLayer.backgroundColor = [[UIColor whiteColor] CGColor];
  [topPageLayer addSublayer:topPageImageLayer];
  [topPageLayer release];
  [topPageImageLayer release];
  [topLayer release];

  topPageOverlayLayer = [[CALayer alloc] init];
  topPageOverlayLayer.masksToBounds = YES;
  topPageOverlayLayer.backgroundColor = [[UIColor whiteColor] CGColor];
  [topPageImageLayer addSublayer:topPageOverlayLayer];
  [topPageOverlayLayer release];

  topPageLeftOutShadowLayer = [[CAGradientLayer alloc] init];
  [topLayer addSublayer:topPageLeftOutShadowLayer];
  topPageCurlShadowLayer = [[CAGradientLayer alloc] init];
  [topLayer addSublayer:topPageCurlShadowLayer];
  topPageRightOutShadowLayer = [[CAGradientLayer alloc] init];
  [topLayer addSublayer:topPageRightOutShadowLayer];
  [topPageLeftOutShadowLayer release];
  [topPageCurlShadowLayer release];
  [topPageRightOutShadowLayer release];

  topPageLeftShadowLayer = [[CAGradientLayer alloc] init];
  [topPageImageLayer addSublayer:topPageLeftShadowLayer];
  topPageRightShadowLayer = [[CAGradientLayer alloc] init];
  [topPageImageLayer addSublayer:topPageRightShadowLayer];
  [topPageLeftShadowLayer release];
  [topPageRightShadowLayer release];

  _leftView = [[UIView alloc] init];
  [_leftView setUserInteractionEnabled:NO];
  //[_scrollView addSubview:_leftView];
  [_leftView release];

  _rightView = [[UIView alloc] init];
  [_rightView setUserInteractionEnabled:NO];
  //[_scrollView addSubview:_rightView];
  [_rightView release];

  [self.view addSubview:_scrollView];
  [_scrollView release];

  _pageCurlView = [[UIView alloc] initWithFrame:self.view.frame];
  //[_pageCurlView setBackgroundColor:[UIColor blueColor]];
  [_pageCurlView setUserInteractionEnabled:NO];
  //_pageCurlView.delegate = self;

  [self initLayout];
  //[self initLayers:_pageCurlView];

  [self.view addSubview:_pageCurlView];

  _mode = page_mode_none;

  image_margin_x = 0;
  image_margin_y = 0;

  if ( PAGING_BY_BUTTON ) {
    _nextButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _prevButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];

    _nextButton.enabled = false;
    _prevButton.enabled = false;

    // [_nextButton addTarget:self action:@selector(onNextButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    // [_prevButton addTarget:self action:@selector(onPrevButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setUserInteractionEnabled:YES];
    [_prevButton setUserInteractionEnabled:YES];
  }

  page_change_threshold = PAGE_CHANGE_THRESHOLD_MODE_A;
  curl_boost = CURL_BOOST_MODE_A;
}

- (void)initLayout {
  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  if ( _windowMode == MODE_A ) {
    if ( _direction == DIRECTION_LEFT ) {
      leftPageLayer.opacity = 1.0f;
      rightPageLayer.opacity = 0.0f;

      if ( PAGING_BY_BUTTON ) {
	[_nextButton setTitle:@"<<" forState:UIControlStateNormal];
	[_prevButton setTitle:@">>" forState:UIControlStateNormal];
	_nextButton.frame = CGRectMake(PAGING_BUTTON_MARGIN, WINDOW_AH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
	_prevButton.frame = CGRectMake(WINDOW_AW - (PAGING_BUTTON_WIDTH + PAGING_BUTTON_MARGIN), WINDOW_AH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
      }
    } else {
      leftPageLayer.opacity = 0.0f;
      rightPageLayer.opacity = 1.0f;

      if ( PAGING_BY_BUTTON ) {
	[_nextButton setTitle:@">>" forState:UIControlStateNormal];
	[_prevButton setTitle:@"<<" forState:UIControlStateNormal];
	_prevButton.frame = CGRectMake(PAGING_BUTTON_MARGIN, WINDOW_AH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
	_nextButton.frame = CGRectMake(WINDOW_AW - (PAGING_BUTTON_WIDTH + PAGING_BUTTON_MARGIN), WINDOW_AH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
      }
    }

    image_width = WINDOW_AW - PAGE_MARGIN_LEFT - PAGE_MARGIN_RIGHT;
    image_height = WINDOW_AH - PAGE_MARGIN_TOP - PAGE_MARGIN_BOTTOM;

    self.view.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
    _scrollView.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
    _scrollView.contentSize = CGSizeMake(WINDOW_AW, WINDOW_AH);

    if ( _direction == DIRECTION_LEFT ) {
      [_bookView setFrame:CGRectMake(PAGE_MARGIN_LEFT, PAGE_MARGIN_BOTTOM, 2 * image_width, image_height)];
    } else {
      [_bookView setFrame:CGRectMake(PAGE_MARGIN_LEFT - image_width, PAGE_MARGIN_BOTTOM, 2 * image_width, image_height)];
    }

    bottomLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    middleLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    topLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    rightPageLayer.frame = CGRectMake(image_width + 1, 0, image_width, image_height);
    leftPageLayer.frame = CGRectMake(0, 0, image_width, image_height);
  } else {
    image_width = (WINDOW_BW - PAGE_MARGIN_LEFT - PAGE_MARGIN_RIGHT)/2;
    image_height = WINDOW_BH - PAGE_MARGIN_TOP - PAGE_MARGIN_BOTTOM;

    leftPageLayer.opacity = 1.0f;
    rightPageLayer.opacity = 1.0f;

    self.view.frame = CGRectMake(0, 0, WINDOW_BW, WINDOW_BH);
    _scrollView.frame = CGRectMake(0, 0, WINDOW_BW, WINDOW_BH);
    _scrollView.contentSize = CGSizeMake(WINDOW_BW, WINDOW_BH);

    [_bookView setFrame:CGRectMake(PAGE_MARGIN_LEFT, PAGE_MARGIN_BOTTOM, image_width * 2, image_height)];

    bottomLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    middleLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    topLayer.frame = CGRectMake(0, 0, 2 * image_width, image_height);
    rightPageLayer.frame = CGRectMake(image_width + 1, 0, image_width, image_height);
    leftPageLayer.frame = CGRectMake(0, 0, image_width, image_height);

    if (_direction == DIRECTION_LEFT ) {
      if ( PAGING_BY_BUTTON ) {
	[_nextButton setTitle:@"<<" forState:UIControlStateNormal];
	[_prevButton setTitle:@">>" forState:UIControlStateNormal];
	_nextButton.frame = CGRectMake(PAGING_BUTTON_MARGIN, WINDOW_BH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
	_prevButton.frame = CGRectMake(WINDOW_BW - (PAGING_BUTTON_WIDTH + PAGING_BUTTON_MARGIN), WINDOW_BH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
      }
    } else {
      if ( PAGING_BY_BUTTON ) {
	[_nextButton setTitle:@">>" forState:UIControlStateNormal];
	[_prevButton setTitle:@"<<" forState:UIControlStateNormal];
	_prevButton.frame = CGRectMake(PAGING_BUTTON_MARGIN, WINDOW_BH - (PAGING_BUTTON_HEIGHT + PAGING_BUTTON_MARGIN), PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
	_nextButton.frame = CGRectMake(WINDOW_BW - (PAGING_BUTTON_WIDTH + PAGING_BUTTON_MARGIN), WINDOW_BH - PAGING_BUTTON_HEIGHT, PAGING_BUTTON_WIDTH, PAGING_BUTTON_HEIGHT);
      }
    }
  }
  //(id)[[[UIColor alloc] initWithRed:SHADOW_RED green:SHADOW_GREEN blue:SHADOW_BLUE alpha:SHADOW_ALPHA] CGColor], 
  centerPageRightShadow.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    nil];
  centerPageRightShadow.startPoint = CGPointMake(1, 0.5);
  centerPageRightShadow.endPoint = CGPointMake(0, 0.5);
  centerPageRightShadow.frame = CGRectMake(image_width - CENTER_SHADOW_WIDTH, 0, CENTER_SHADOW_WIDTH, WINDOW_BH);

  centerPageLeftShadow.colors = [NSArray arrayWithObjects:
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    (id)[[UIColor clearColor] CGColor],
    nil];
  centerPageLeftShadow.startPoint = CGPointMake(1, 0.5);
  centerPageLeftShadow.endPoint = CGPointMake(0, 0.5);
  centerPageLeftShadow.frame = CGRectMake(CENTER_SHADOW_WIDTH, 0, CENTER_SHADOW_WIDTH, WINDOW_BH);


  middlePageRightShadowLayer.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    nil];
  middlePageRightShadowLayer.startPoint = CGPointMake(1, 0.5);
  middlePageRightShadowLayer.endPoint = CGPointMake(0, 0.5);

  middlePageLeftShadowLayer.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    nil];
  middlePageLeftShadowLayer.startPoint = CGPointMake(0, 0.5);
  middlePageLeftShadowLayer.endPoint = CGPointMake(1, 0.5);

  topPageRightOutShadowLayer.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    nil];
  topPageRightOutShadowLayer.startPoint = CGPointMake(1, 0.5);
  topPageRightOutShadowLayer.endPoint = CGPointMake(0, 0.5);

  topPageLeftOutShadowLayer.colors = [NSArray arrayWithObjects:
	 (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    (id)[[UIColor clearColor] CGColor],
    nil];
  topPageLeftOutShadowLayer.startPoint = CGPointMake(1, 0.5);
  topPageLeftOutShadowLayer.endPoint = CGPointMake(0, 0.5);

  topPageCurlShadowLayer.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:TOP_SHADOW_ALPHA] CGColor],
    (id)[[UIColor clearColor] CGColor],
    nil];
  topPageCurlShadowLayer.startPoint = CGPointMake(0, 0.5);
  topPageCurlShadowLayer.endPoint = CGPointMake(1, 0.5);

  topPageRightShadowLayer.colors = [NSArray arrayWithObjects:
    (id)[[UIColor clearColor] CGColor],
    (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    nil];
  topPageRightShadowLayer.startPoint = CGPointMake(1, 0.5);
  topPageRightShadowLayer.endPoint = CGPointMake(0, 0.5);

  topPageLeftShadowLayer.colors = [NSArray arrayWithObjects:
	 (id)[[[UIColor blackColor] colorWithAlphaComponent:SHADOW_ALPHA] CGColor],
    (id)[[UIColor clearColor] CGColor],
    nil];
  topPageLeftShadowLayer.startPoint = CGPointMake(1, 0.5);
  topPageLeftShadowLayer.endPoint = CGPointMake(0, 0.5);

  rightPageImageLayer.frame = rightPageLayer.frame;
  leftPageImageLayer.frame = leftPageLayer.frame;

  //[_bookView setBackgroundColor:[UIColor blueColor]];

  // rightPageLayer.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:0.0f alpha:0.1f];
  // leftPageLayer.backgroundColor = [[UIColor blueColor] CGColor];

  [CATransaction commit];
}

- (void) startFor:(int)curling from:(int)from {
  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  float center = image_width;

  topPageRightOutShadowLayer.opacity = 0.0f;
  topPageLeftOutShadowLayer.opacity = 0.0f;
  topPageRightOutShadowLayer.opacity = 0.0f;
  if ( curling == right ) {
    if ( _windowMode == MODE_A ) {
      topPageRightShadowLayer.opacity = 0.0f;
      topPageLeftShadowLayer.opacity = 0.0f;
      middlePageRightShadowLayer.opacity = 0.0f;
      middlePageLeftShadowLayer.opacity = 0.0f;
      if ( curling == from ) {
	if ( _direction == DIRECTION_LEFT ) {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];

	} else {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	}
	middlePageLayer.frame = CGRectMake(center + 1, 0, image_width , image_height);
	topPageLayer.frame = CGRectMake(center + 1, 0, 0, image_height);

	//middlePageRightShadowLayer.opacity = 1;
	middlePageRightShadowLayer.frame = CGRectMake(0, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

	topPageRightOutShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageCurlShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageLeftOutShadowLayer.frame = CGRectMake(center - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      } else {
	if ( _direction != DIRECTION_LEFT ) {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	} else {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	}
	middlePageLayer.frame = CGRectMake(center - image_width, 0, image_width , image_height);
	topPageLayer.frame = CGRectMake(center - image_width, 0, 0, image_height);

	topPageRightOutShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageCurlShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageLeftOutShadowLayer.frame = CGRectMake(center - image_width - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));

	//middlePageLeftShadowLayer.opacity = 1;
      }
    } else {
      if ( _direction == DIRECTION_LEFT ) {
	//if ((![self isNext] && (2 * floor(_currentPage / 2) != _currentPage)) || ((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	if (((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else if (_currentPage < 4){
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 0.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else if (_currentPage > _maxPage - 1){
	  centerPageLeftShadow.opacity = 0.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else {
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	}
      } else {
	//if ((![self isNext] && (2 * floor(_currentPage / 2) != _currentPage)) || ((_currentPage < _maxPage - 1) &&  (_currentPage > 3))) {
	if (((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else if (_currentPage < 2){
	  centerPageLeftShadow.opacity = 0.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else if (_currentPage > _maxPage - 3){
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 0.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;
	  topPageRightShadowLayer.opacity = 0.0f;
	} else {
	  centerPageLeftShadow.opacity = 1.0f;
	  centerPageRightShadow.opacity = 1.0f;

	  middlePageLeftShadowLayer.opacity = 0.0f;
	  middlePageRightShadowLayer.opacity = 1.0f;

	  topPageLeftShadowLayer.opacity = 1.0f;
	  topPageRightShadowLayer.opacity = 0.0f;
	}

      }

      topPageLeftShadowLayer.frame = CGRectMake(image_width - CENTER_SHADOW_WIDTH, 0, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

      middlePageLayer.frame = CGRectMake(center + 1, 0, image_width, image_height);
      middlePageImageLayer.frame = CGRectMake(center, 0, image_width , image_height);
      topPageLayer.frame = CGRectMake(center + image_width, 0, 0, image_height);
      topPageImageLayer.frame = CGRectMake(center + image_width, 0, 0, image_height);

      topPageRightOutShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      topPageCurlShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      topPageLeftOutShadowLayer.frame = CGRectMake(center - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));

      middlePageRightShadowLayer.frame = CGRectMake(0, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

      middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
      topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:1]]];
    }
  } else if ( curling == left ) { // TODO
    middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];

    middlePageLayer.frame = CGRectMake(center - image_width, 0, image_width , image_height);
    topPageLayer.frame = CGRectMake(center - image_width, 0, 0 , image_height);
    if ( _windowMode == MODE_A ) {
      topPageRightShadowLayer.opacity = 0.0f;
      topPageLeftShadowLayer.opacity = 0.0f;
      middlePageRightShadowLayer.opacity = 0.0f;
      middlePageLeftShadowLayer.opacity = 0.0f;
      if ( curling == from ) {
	if ( _direction != DIRECTION_LEFT ) {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	} else {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	}

	middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];

	middlePageLayer.frame = CGRectMake(center - image_width, 0, image_width , image_height);
	topPageLayer.frame = CGRectMake(center - image_width, 0, 0, image_height);

	topPageRightOutShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageCurlShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageLeftOutShadowLayer.frame = CGRectMake(center - image_width - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      } else {
	if ( _direction != DIRECTION_LEFT ) {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
	} else {
	  middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	  topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
	}

	middlePageLayer.frame = CGRectMake(center + image_width, 0, image_width , image_height);
	topPageLayer.frame = CGRectMake(center + image_width, 0, 0, image_height);

	topPageRightOutShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageCurlShadowLayer.frame = CGRectMake(center + image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
	topPageLeftOutShadowLayer.frame = CGRectMake(center + image_width - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));

//	middlePageRightShadowLayer.opacity = 1;
      }
    } else {
      middlePageRightShadowLayer.frame = CGRectMake(0, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

      if ( _direction != DIRECTION_LEFT ) {
	// if ((![self isNext] && (2 * floor(_currentPage / 2) != _currentPage)) || ((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	if (((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else if (_currentPage < 4){
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 0.0f;

	  middlePageRightShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = 0.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else if (_currentPage > _maxPage - 1){
	  centerPageRightShadow.opacity = 0.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else {
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	}
      } else {
	// if ((![self isNext] && (2 * floor(_currentPage / 2) != _currentPage)) || ((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	if (((_currentPage < _maxPage - 2) &&  (_currentPage > 3))) {
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else if (_currentPage < 2){
	  centerPageRightShadow.opacity = 0.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else if (_currentPage > _maxPage - 1){
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 0.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = FACE_PAGE_SHADOW_ALPHA;
	  topPageLeftShadowLayer.opacity = 0.0f;
	} else {
	  centerPageRightShadow.opacity = 1.0f;
	  centerPageLeftShadow.opacity = 1.0f;

	  middlePageRightShadowLayer.opacity = 0.0f;
	  middlePageLeftShadowLayer.opacity = 1.0f;

	  topPageRightShadowLayer.opacity = 1.0f;
	  topPageLeftShadowLayer.opacity = 0.0f;
	}
      }


      topPageRightShadowLayer.frame = CGRectMake(0, 0, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

      middlePageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
      topPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:1]]];

      middlePageLayer.frame = CGRectMake(center - image_width, 0, image_width , image_height);
      topPageLayer.frame = CGRectMake(center - image_width, 0, 0, image_height);

      topPageRightOutShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      topPageCurlShadowLayer.frame = CGRectMake(center - image_width, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
      topPageLeftOutShadowLayer.frame = CGRectMake(center - image_width - BOTTOM_SHADOW_WIDTH * 1.2, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
    }
  }

  middlePageImageLayer.transform = CATransform3DMakeScale(1, 1, 1);
  middlePageImageLayer.frame = [self getAspectFittingImageRect:[[_pageList objectForKey:[NSNumber numberWithInteger:_currentPage]] image]];
  topPageImageLayer.frame = [self getAspectFittingImageRect:[[_pageList objectForKey:[NSNumber numberWithInteger:_currentPage]] image]];
  topPageOverlayLayer.frame = CGRectMake(0, 0, image_width - (2 * image_margin_x), image_height);

  if ( _windowMode == MODE_A ) {
    topPageImageLayer.transform = CATransform3DMakeScale(-1, 1, 1);
    topPageOverlayLayer.opacity = TOP_OVERLAY_ALPHA;
  } else {
    topPageImageLayer.transform = CATransform3DMakeScale(1, 1, 1);
    topPageOverlayLayer.opacity = 0.0f;
  }

  [CATransaction commit];

  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 
  topLayer.opacity = 1.0f;
  middleLayer.opacity = 1.0f;
  [CATransaction commit];

  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 
  if ( curling == right ) {
    if ( _windowMode == MODE_A ) {
      if ( curling == from ) {
	rightPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:1]]];
      }
    } else {
      rightPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:2]]];
    }
  } else if ( curling == left ) {
    if ( _windowMode == MODE_A ) {
      if ( curling == from ) {
	leftPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:1]]];
      }
    } else {
      leftPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:2]]];
    }
  }
  [CATransaction commit];
}

- (void) curlFor:(int)curling from:(int)from ratio:(float)ratio{
  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  float center = image_width;

  ratio = MIN(1.0f, ratio);
  ratio = MAX(0.0f, ratio);

  topPageRightOutShadowLayer.opacity = MAX((1.0f - 4 * (ratio - 0.5)*(ratio - 0.5)), 0);
  topPageCurlShadowLayer.opacity = MAX((1.0f - 4 * (ratio - 0.5)*(ratio - 0.5)), 0);
  topPageLeftOutShadowLayer.opacity = MAX((1.0f - 4 * (ratio - 0.5)*(ratio - 0.5)), 0);

  if ( curling == left ) {
    middlePageLayer.frame = CGRectMake(center - image_width + image_width * ratio, 0, image_width * (1.0f - ratio) , image_height);
    middlePageImageLayer.frame = CGRectMake(-1.0f * image_width * ratio + image_margin_x, image_margin_y, middlePageImageLayer.frame.size.width , middlePageImageLayer.frame.size.height);

    middlePageLeftShadowLayer.frame = CGRectMake(image_width * (1.0f - ratio) - CENTER_SHADOW_WIDTH, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

    topPageLayer.frame = CGRectMake(center - image_width + image_width * ratio + 1, 0, image_width * ratio, image_height);
    topPageImageLayer.frame = CGRectMake((image_width * (ratio - 1.0f)) + image_margin_x, image_margin_y, topPageImageLayer.frame.size.width, topPageImageLayer.frame.size.height);

    topPageRightOutShadowLayer.frame = CGRectMake(center - image_width + 2 * image_width * ratio - image_margin_x, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
    topPageCurlShadowLayer.frame = CGRectMake(center - image_width + image_width * ratio + TOP_SHADOW_WIDTH * 0.2f, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
    topPageLeftOutShadowLayer.frame = CGRectMake(center - image_width + image_width * ratio - BOTTOM_SHADOW_WIDTH, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
  } else {
    middlePageLayer.frame = CGRectMake(center + 1, 0, image_width * (1.0f - ratio) , image_height);
    middlePageImageLayer.frame = CGRectMake(image_margin_x, image_margin_y, middlePageImageLayer.frame.size.width , middlePageImageLayer.frame.size.height);

    middlePageRightShadowLayer.frame = CGRectMake(0, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

    topPageLayer.frame = CGRectMake(center + image_width * (1.0f - 2.0f * ratio), 0, image_width * ratio, image_height);
    topPageImageLayer.frame = CGRectMake(image_margin_x, image_margin_y, topPageImageLayer.frame.size.width, topPageImageLayer.frame.size.height);

    topPageRightOutShadowLayer.frame = CGRectMake(center + image_width * (1.0f - ratio ), image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
    topPageCurlShadowLayer.frame = CGRectMake(center + image_width * (1.0f - ratio ) - TOP_SHADOW_WIDTH * 1.2f, image_margin_y, TOP_SHADOW_WIDTH, image_height - (2 * image_margin_y));
    topPageLeftOutShadowLayer.frame = CGRectMake(center + image_width * (1.0f - 2.0f * ratio) + image_margin_x - BOTTOM_SHADOW_WIDTH, image_margin_y, BOTTOM_SHADOW_WIDTH, image_height - (2 * image_margin_y));
  }
  [CATransaction commit];

  if ( _windowMode == MODE_B ) {
    if (([self isNext] && [self isPrev])) {
	centerPageLine.opacity = 0.4f;
    } else if (![self isNext] && (_direction == DIRECTION_LEFT) && (curling == right) && (ratio > 0.5)) {
	centerPageLine.opacity = 0.4f;
    } else if ((_direction == DIRECTION_LEFT) && (curling != right) && (ratio > 0.5)) {
	centerPageLine.opacity = 0.4f;
    } else if (![self isNext] && (_direction != DIRECTION_LEFT) && (curling == left) && (ratio > 0.5)) {
	centerPageLine.opacity = 0.4f;
    } else if ((_direction != DIRECTION_LEFT) && (curling != left) && (ratio > 0.5)) {
	centerPageLine.opacity = 0.4f;
    } else {
	centerPageLine.opacity = 0.0f;
    }
  } else {
    centerPageLine.opacity = 0.0f;
  }
}

- (void) autoCurlAnimation {
  if ( _mode == page_mode_release ) {
    if ( _windowMode == MODE_A ) {
      if (( _direction != DIRECTION_LEFT && _curl_from == left ) || (_direction == DIRECTION_LEFT && _curl_from == right) ) {
	if ( _curl_ratio < page_change_threshold ) {
	  if ( (_curl_ratio -= CURL_SPAN) > 0.0f ) {
	    [self curlFor:_curl_side from:_curl_from ratio:1.0f - _curl_ratio];
	    [self performSelector:@selector(autoCurlAnimation)
		       withObject:nil 
		       afterDelay:PAGING_WAIT_TIME];
	  } else {
	    [self endFor:_curl_side from:_curl_from to:_curl_to];
	    [self setPages];
	  }
	} else {
	  if ( (_curl_ratio += CURL_SPAN) < 1.0f ) {
	    [self curlFor:_curl_side from:_curl_from ratio:1.0f - _curl_ratio];
	    [self performSelector:@selector(autoCurlAnimation)
		       withObject:nil 
		       afterDelay:PAGING_WAIT_TIME];
	  } else {
	    [self endFor:_curl_side from:_curl_from to:_curl_to];
	    [self setPages];
	  }
	}
      } else {
	if ( _curl_ratio >= page_change_threshold ) {
	  if ( (_curl_ratio += CURL_SPAN) < 1.0f ) {
	    [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	    [self performSelector:@selector(autoCurlAnimation)
		       withObject:nil 
		       afterDelay:PAGING_WAIT_TIME];
	  } else {
	    [self endFor:_curl_side from:_curl_from to:_curl_to];
	    [self setPages];
	  }
	} else {
	  if ( (_curl_ratio -= CURL_SPAN) > 0.0f ) {
	    [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	    [self performSelector:@selector(autoCurlAnimation)
		       withObject:nil 
		       afterDelay:PAGING_WAIT_TIME];
	  } else {
	    [self endFor:_curl_side from:_curl_from to:_curl_to];
	    [self setPages];
	  }
	}
      }
    } else {
      if ( _curl_ratio < page_change_threshold ) {
	if ( (_curl_ratio -= CURL_SPAN) > 0.0f ) {
	  [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	  [self performSelector:@selector(autoCurlAnimation)
		     withObject:nil 
		     afterDelay:PAGING_WAIT_TIME];
	} else {
	  [self endFor:_curl_side from:_curl_from to:_curl_to];
	  [self setPages];
	}
      } else {
	if ( (_curl_ratio += CURL_SPAN) < 1.0f ) {
	  [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	  [self performSelector:@selector(autoCurlAnimation)
		     withObject:nil 
		     afterDelay:PAGING_WAIT_TIME];
	} else {
	  [self endFor:_curl_side from:_curl_from to:_curl_to];
	  [self setPages];
	}
      }
    }
  }
}

- (void) endFor:(int)curling from:(int)from to:(int)to{
  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  if (_windowMode == MODE_A) {
    if ( from == to) {
      if ( curling == right && curling == from ) {
	rightPageImageLayer.contents = middlePageImageLayer.contents;
      } else if ( curling == left && curling == from) {
	leftPageImageLayer.contents = middlePageImageLayer.contents;
      }
    } else {
      if ( curling == right && curling == to ) {
	rightPageImageLayer.contents = middlePageImageLayer.contents;
      } else if ( curling == left && curling == to) {
	leftPageImageLayer.contents = middlePageImageLayer.contents;
      }
    }
  } else {
    if ( curling == left ) {
      if ( from != to ) {
	rightPageImageLayer.contents = topPageImageLayer.contents;
      } else {
	leftPageImageLayer.contents = topPageImageLayer.contents;
      }
    } else {
      if ( from == to ) {
	rightPageImageLayer.contents = topPageImageLayer.contents;
      } else {
	leftPageImageLayer.contents = topPageImageLayer.contents;
      }
    }
  }

  [CATransaction commit];

  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 
  topLayer.opacity = 0.0f;
  middlePageLeftShadowLayer.opacity = 1.0f;
  middlePageRightShadowLayer.opacity = 1.0f;
  [CATransaction commit];

  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  middleLayer.opacity = 0.0f;

  topPageLeftOutShadowLayer.opacity = 0.0f;
  topPageCurlShadowLayer.opacity = 0.0f;
  topPageRightOutShadowLayer.opacity = 0.0f;

  [CATransaction commit];

  //_mode = page_mode_none;
}

- (NSInteger) getRightPageNumberWithDistance:(NSInteger)d {
  NSInteger page_num;
  if ( _windowMode == MODE_A ) {
    page_num = _currentPage;
  } else {
    page_num = 2 * floor(_currentPage / 2) + 1;
  }

  if ( _direction == DIRECTION_LEFT ) {
    return page_num - d - 1;
  } else {
    return page_num + d;
  }
}

- (NSInteger) getLeftPageNumberWithDistance:(NSInteger)d {
  NSInteger page_num;
  if ( _windowMode == MODE_A ) {
    page_num = _currentPage;
  } else {
    page_num = 2 * floor(_currentPage / 2) + 1;
  }

  if ( _direction == DIRECTION_LEFT ) {
    return page_num + d;
  } else {
    return page_num - d - 1;
  }
}

- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum direction:(NSInteger)direction windowMode:(NSInteger)windowMode {
 // NSLog(@"set up");
 [super setup:uuid selectPage:selectPage pageNum:pageNum direction:direction windowMode:windowMode];

 _windowMode = windowMode;
 if ( _windowMode == MODE_A ) {
  page_change_threshold = PAGE_CHANGE_THRESHOLD_MODE_A / 2;
  curl_boost = CURL_BOOST_MODE_A;
 } else {
  page_change_threshold = PAGE_CHANGE_THRESHOLD_MODE_B;
  curl_boost = CURL_BOOST_MODE_B;
 }

 [self initLayout];

 [self loadPages:selectPage windowMode:_windowMode];

 [self setPages];
}

- (BOOL)isNext {
  if (_currentPage < _maxPage)
    return YES;

  return NO;
}

- (void)onNextButtonPushed:(UIButton *)sender {
  [self next];
  [self setPages];
}

- (void)next {
  [super next];

  //NSLog(@"next");

  NSInteger targetPage;
  if ( _windowMode == MODE_A ) { //TODO
    targetPage = _currentPage + 1;
  } else {
    targetPage = _currentPage + 2;
  }

  // if (targetPage > _maxPage)
    // return;

  [self loadPages:targetPage windowMode:_windowMode];

  // [self setPages];

  [self resetContentsSize];

  [self releaseFarBooks:targetPage];
}

- (BOOL)isPrev {
  if (_currentPage > 1)
    return YES;

  return NO;
}

- (void)onPrevButtonPushed:(UIButton *)sender {
  [self prev];
  [self setPages];
}

- (void)prev {
  [super prev];

  NSInteger targetPage;
  if ( _windowMode == MODE_A ) { //TODO
    targetPage = _currentPage - 1;
  } else {
    targetPage = _currentPage - 2;
  }
  // if (targetPage < 1)
    // return;

  [self loadPages:targetPage windowMode:_windowMode];

  // [self setPages];

  [self resetContentsSize];

  [self releaseFarBooks:targetPage];
}

- (void)resetContentsSize {
  //_scrollView.contentOffset = CGPointMake(0, 0);
  //_scrollView.zoomScale = 1.0f;
  if ( _windowMode == MODE_A ) {
    if( TOP_ALIGN_ON_ZOOM && (_scrollView.zoomScale > 1.0f) ) {
	if( _direction == DIRECTION_LEFT ) {
		  _scrollView.contentOffset = CGPointMake(image_width * (1.0f - (1.0f / _scrollView.zoomScale)) - image_margin_x, image_margin_y);
	} else {
		  _scrollView.contentOffset = CGPointMake(image_margin_x, image_margin_y);
	}
    } else {
	if( _direction == DIRECTION_LEFT ) {
		  _scrollView.contentOffset = CGPointMake(image_width * (1.0f - (1.0f / _scrollView.zoomScale)), 0);
	} else {
		  _scrollView.contentOffset = CGPointMake(0, 0);
	}
    }
  //  _scrollView.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
  //  _scrollView.contentSize = CGSizeMake(WINDOW_AW, WINDOW_AH);
  } else {
      if( _direction == DIRECTION_LEFT ) {
		_scrollView.contentOffset = CGPointMake(image_width * (1.0f - (1.0f / _scrollView.zoomScale)), 0);
      } else {
		_scrollView.contentOffset = CGPointMake(0, 0);
	}
  }
}

- (void)requestPage:(NSInteger)targetPage {
  // NSLog(@"%d", targetPage);
  [super requestPage:targetPage];

  //if (_direction == DIRECTION_LEFT)
  // targetPage = _maxPage - targetPage;

  [self loadPages:targetPage windowMode:_windowMode];

  [self setPages];

  [self releaseFarBooks:targetPage];

  _scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  /*
     CGFloat pageWidth = _scrollView.frame.size.width;  
     NSInteger targetPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

     if (_direction == DIRECTION_LEFT)
     targetPage = _maxPage - targetPage;
     else {
     targetPage = targetPage + 1;
     }

     [self setPage:targetPage windowMode:_windowMode];
     */
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)sender {
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)sender {
}

/*
   - (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate{
   CGFloat pageWidth = _scrollView.frame.size.width;  
   NSInteger targetPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
   NSLog(@"end dragging");

   if (_direction == DIRECTION_LEFT)
   targetPage = _maxPage - targetPage;
   else {
   targetPage = targetPage + 1;
   }

   if(_currentPage != targetPage) {
   [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * targetPage, 0) animated:YES];
   }

   [self setPage:targetPage];
   }
   */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (_scrollOffsetX > scrollView.contentOffset.x) {
    if (_direction == DIRECTION_LEFT) {
      //			NSLog(@"scrollViewDidEndScrollingAnimation Next");
    } else {
      //			NSLog(@"scrollViewDidEndScrollingAnimation Prev");
    }
  } else {
    if (_direction == DIRECTION_LEFT) {
      //			NSLog(@"scrollViewDidEndScrollingAnimation Prev");
    } else {
      //			NSLog(@"scrollViewDidEndScrollingAnimation Next");
    }
  }

  /*
  [self loadPages:_currentPage windowMode:_windowMode];

  [self initLayout];
  */

  [self setPages];

  /*
  [self releaseFarBooks:_currentPage];
  */
}

-(void)scrollViewDidEndZooming:(UIScrollView *)sv withView:(UIView*)v0 atScale:(float)scale {
  _scrollView.zoomScale = scale;
  if (_windowMode == MODE_A) {
    //_scrollView.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
    _scrollView.frame = CGRectMake(0, 0, WINDOW_AW, WINDOW_AH);
    //_scrollView.contentSize = CGSizeMake(WINDOW_AW, WINDOW_AH);
    _scrollView.contentSize = CGSizeMake(WINDOW_AW, WINDOW_AH);
    //_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
  } else {
    // _scrollView.frame = CGRectMake(0, 0, WINDOW_BW, WINDOW_BH);
    //_scrollView.contentSize = CGSizeMake(WINDOW_BW * scale, WINDOW_BH * scale);
    _scrollView.frame = CGRectMake(0, 0, WINDOW_BW, WINDOW_BH);
    _scrollView.contentSize = CGSizeMake(WINDOW_BW, WINDOW_BH);
  }
  _mode = page_mode_none;
  [self setPages];

  if ( PAGING_BY_BUTTON && scale > 1.0f) {
    if(!_nextButton.superview){
      [self.view addSubview:_nextButton];
    }
    if(!_prevButton.superview){
      [self.view addSubview:_prevButton];
    }
  } else {
    [_nextButton removeFromSuperview];
    [_prevButton removeFromSuperview];
  }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate {
  float w;
  if ( _windowMode == MODE_A ) {
    w = WINDOW_AW;
  } else {
    w = WINDOW_BW;
  }
  //NSLog(@"%f, %f", sv.contentOffset.x + w , sv.contentSize.width + PAGE_CHANGE_TRIGGER_MARGIN);
/*
  if (sv.contentOffset.x < -1.0f * PAGE_CHANGE_TRIGGER_MARGIN) {
    if (_direction == DIRECTION_LEFT) {
      [self notifyGoToNextPage];
    } else {
      [self notifyGoToPrevPage];
    }
  } else if (sv.contentOffset.x + w > sv.contentSize.width + PAGE_CHANGE_TRIGGER_MARGIN) {
    if (_direction == DIRECTION_LEFT) {
      [self notifyGoToPrevPage];
    } else {
      [self notifyGoToNextPage];
    }
  }
 [self setPages];
*/
  //NSLog(@"release %f, %f", sv.contentOffset.x, sv.contentOffset.y);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _scrollView;
}

- (void)releaseFarBooks:(NSInteger)targetPage {
  for (NSInteger i = 1; i < _maxPage + 1; i++) {
    if (((_windowMode == MODE_A) && ((i < (targetPage - 1)) || ((targetPage + 1) < i))) ||
	((_windowMode == MODE_B) && ((i < (targetPage - 3)) || ((targetPage + 3) < i)))) {
      NSNumber *number = [NSNumber numberWithInteger:i];
      if ([_pageList objectForKey:number]) {
	       [super releaseBook:number removeFromList:YES];
      }
      if ([_imageList objectForKey:number]) {
	// NSLog(@"release image %d", i);
	[super releaseImage:number removeFromList:YES];
      }
    }
  }
}

- (void)releaseAllBooks {
  for (NSInteger i = 1; i < _maxPage + 1; i++) {
    NSNumber *number = [NSNumber numberWithInteger:i];
    if ([_pageList objectForKey:number]) {
	     [super releaseBook:number removeFromList:YES];
    }
    if ([_imageList objectForKey:number]) {
	     [super releaseImage:number removeFromList:YES];
    }
  }
}

- (void)loadPages:(NSInteger)selectPage windowMode:(NSInteger)windowMode {
   [super setPage:selectPage windowMode:_windowMode];
   //[super loadPages:selectPage windowMode:_windowMode];

   NSInteger selectPageWithOffset;
   for (NSInteger i = 0; i < 7; i++) {
     selectPageWithOffset = selectPage + (i - 3);

     NSNumber *number = [NSNumber numberWithInteger:selectPageWithOffset];
     if ([_imageList objectForKey:number]) {
     } else {
       NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, _uuid];
       NSString *image_path = [Util makeBookPathFormat:documentDir pageNo:selectPageWithOffset extension:BOOK_EXTENSION];
       UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
       if (image)
       {
	 UIImageViewWithTouch *imageView = [[UIImageViewWithTouch alloc] initWithImage:image];
	 [_pageList setObject:imageView forKey:number];
	 [_imageList setObject:[self getImageRefFromUIImage:image] forKey:number];
	 [imageView release];
       }
       [image release];
       [image_path release];
       [documentDir release];
     }
   }
}

- (void)setPages {
  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  leftPageImageLayer.opacity = 1.0f;
  leftPageImageLayer.transform = CATransform3DMakeScale(1, 1, 1); //TODO
  leftPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getLeftPageNumberWithDistance:0]]];
  leftPageImageLayer.frame = [self getAspectFittingImageRect:[[_pageList objectForKey:[NSNumber numberWithInteger:_currentPage]] image]];

  rightPageImageLayer.opacity = 1.0f;
  rightPageImageLayer.transform = CATransform3DMakeScale(1, 1, 1);
  rightPageImageLayer.contents = [_imageList objectForKey:[NSNumber numberWithInteger:[self getRightPageNumberWithDistance:0]]];
  rightPageImageLayer.frame = [self getAspectFittingImageRect:[[_pageList objectForKey:[NSNumber numberWithInteger:_currentPage]] image]];

  centerPageLine.frame = CGRectMake(image_width, image_margin_y, 1, image_height - (2 * image_margin_y));
  if (_windowMode == MODE_B) {
    if ((![self isNext] && (2 * floor(_currentPage / 2) != _currentPage)) || ([self isNext] && [self isPrev])) {
      centerPageRightShadow.opacity = 1.0f;
      centerPageLeftShadow.opacity = 1.0f;

      centerPageLine.opacity = 0.4f;
    } else {
      centerPageLine.opacity = 0.0f;
      if (![self isNext]) {
	if ( _direction == DIRECTION_LEFT ) {
	  centerPageLeftShadow.opacity = 0.0f;
	  centerPageRightShadow.opacity = FACE_PAGE_SHADOW_ALPHA;
	} else {
	  centerPageLeftShadow.opacity = FACE_PAGE_SHADOW_ALPHA;
	  centerPageRightShadow.opacity = 0.0f;
	}
      } else if(![self isPrev]) {
	if ( _direction != DIRECTION_LEFT ) {
	  centerPageLeftShadow.opacity = 0.0f;
	  centerPageRightShadow.opacity = FACE_PAGE_SHADOW_ALPHA;
	} else {
	  centerPageLeftShadow.opacity = FACE_PAGE_SHADOW_ALPHA;
	  centerPageRightShadow.opacity = 0.0f;
	}
      }
    }
  } else {
    centerPageLeftShadow.opacity = 0.0f;
    centerPageRightShadow.opacity = 0.0f;
    centerPageLine.opacity = 0.0f;
  }

  [CATransaction commit];

  [CATransaction begin];
  [CATransaction setDisableActions:YES]; 

  centerPageLeftShadow.frame = CGRectMake(image_width - CENTER_SHADOW_WIDTH, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));
  centerPageRightShadow.frame = CGRectMake(image_width + 1, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));
  middlePageLeftShadowLayer.opacity = 0.0f;
  middlePageLeftShadowLayer.frame = CGRectMake(image_width - CENTER_SHADOW_WIDTH, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));
  middlePageRightShadowLayer.opacity = 0.0f;
  middlePageRightShadowLayer.frame = CGRectMake(image_width, image_margin_y, CENTER_SHADOW_WIDTH, image_height - (2 * image_margin_y));

  [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  NSLog(@"did unload");
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [_nextButton release];
  [_prevButton release];

  // [self releaseAllLayers];
  // [self releaseAllViews];

  [super dealloc];
}

- (void) releaseAllLayers {
  [bottomLayer release];
  [centerPageLine release];
  [rightPageImageLayer release];
  [rightPageLayer release];
  [leftPageImageLayer release];
  [leftPageLayer release];
  [centerPageLeftShadow release];
  [centerPageRightShadow release];
  [middleLayer release];
  [middlePageLayer release];
  [middlePageImageLayer release];
  [middlePageLeftShadowLayer release];
  [middlePageRightShadowLayer release];
  [topPageLayer release];
  [topPageImageLayer release];
  [topLayer release];
  [topPageOverlayLayer release];
  [topPageLeftOutShadowLayer release];
  [topPageCurlShadowLayer release];
  [topPageRightOutShadowLayer release];
  [topPageLeftShadowLayer release];
  [topPageRightShadowLayer release];
}

- (void) releaseAllViews {
  [_bookView release];
  [_leftView release];
  [_rightView release];
  [_scrollView release];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  /* mode check
  */
  /*
  if ( _mode == page_mode_none ) {
    NSLog(@"mode none");
  } else if ( _mode == page_mode_release ) {
    NSLog(@"mode release");
  } else if ( _mode == page_mode_curl_start ) {
    NSLog(@"mode start");
  } else if ( _mode == page_mode_curling ) {
    NSLog(@"mode curling");
  }
  */
  touchStartPoint = [[touches anyObject] locationInView:self.view];
  if ( _mode == page_mode_release ) {
    [self endFor:_curl_side from:_curl_from to:_curl_to];
    [self setPages];
    _mode = page_mode_none;
  }

  if ( [touches count] == 1 && _scrollView.zoomScale == 1.0f) {
    if ( _mode == page_mode_none ) {
      _mode = page_mode_curl_start;
    }

    [_scrollView setScrollEnabled:NO];
    [_scrollView setCanCancelContentTouches:NO];
  } else {
    if ( _mode == page_mode_none ) {
      _mode = page_mode_tap_on_zoom;
      [self endFor:_curl_side from:_curl_from to:_curl_to];
      [self setPages];
    }
  }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
  CGPoint point;
  point = [[touches anyObject] locationInView:self.view];
  float delta_x = point.x - touchStartPoint.x;
  _curl_ratio = 0.0f;

  NSInteger _curl_side;
  if ( _mode == page_mode_curl_start ) {
    _mode = page_mode_curling;
    if ( delta_x >= 0) {
	_curl_from = left;

	if ( _windowMode == MODE_A ) {
	  if ( _direction == DIRECTION_LEFT ) {
	    _curl_side = left;
	  } else {
	    _curl_side = right;
	  }
	} else {
	  _curl_side = left;
	}

      if (((_direction == DIRECTION_LEFT) && [self isNext]) || ((_direction != DIRECTION_LEFT) && [self isPrev])) {
	[self setPages];
	[self startFor:_curl_side from:_curl_from];
      }
    } else {
      _curl_from = right;

      if ( _windowMode == MODE_A ) {
	if ( _direction == DIRECTION_LEFT ) {
	  _curl_side = left;
	} else {
	  _curl_side = right;
	}
      } else {
	_curl_side = right;
      }

      if (((_direction != DIRECTION_LEFT) && [self isNext]) || ((_direction == DIRECTION_LEFT) && [self isPrev])) {
	[self setPages];
	[self startFor:_curl_side from:_curl_from];
      }
    }
  } else if ( _mode == page_mode_curling ) {
    if ( _curl_from == right) {
      if ( delta_x >= 0) {
	if ( _windowMode == MODE_A ) {
	  if ( _direction == DIRECTION_LEFT ) {
	    _curl_side = left;
	  } else {
	    _curl_side = right;
	  }
	} else {
	  _curl_side = left;
	}

	_curl_from = left;
	[self setPages];
	if (((_direction == DIRECTION_LEFT) && [self isNext]) || ((_direction != DIRECTION_LEFT) && [self isPrev])) {
	  [self startFor:_curl_side from:_curl_from];
	}
      } else {
	if ( _windowMode == MODE_A ) {
	  if ( _direction == DIRECTION_LEFT ) {
	    _curl_side = left;
	  } else {
	    _curl_side = right;
	  }

	  if ( _curl_side  == _curl_from ) {
	    _curl_ratio = -1.0f * curl_boost * delta_x / WINDOW_AW;
	  } else {
	    _curl_ratio = 1.0f - ( -1.0f * curl_boost * delta_x / WINDOW_AW);
	  }
	} else {
	  _curl_side = right;
	  _curl_ratio = -1.0f * curl_boost * delta_x / WINDOW_BW;
	}
	if ( ((_direction != DIRECTION_LEFT) && [self isNext]) || ((_direction == DIRECTION_LEFT) && [self isPrev])) {
	  [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	}
      }
    } else {
      if ( delta_x < 0) {
	if ( _windowMode == MODE_A ) {
	  if ( _direction == DIRECTION_LEFT ) {
	    _curl_side = left;
	  } else {
	    _curl_side = right;
	  }
	} else {
	  _curl_side = right;
	}

	_curl_from = right;
	[self setPages];
	if ( ((_direction != DIRECTION_LEFT) && [self isNext]) || ((_direction == DIRECTION_LEFT) && [self isPrev])) {
	  [self startFor:_curl_side from:_curl_from];
	}
      } else {
	if ( _windowMode == MODE_A ) {
	  if ( _direction == DIRECTION_LEFT ) {
	    _curl_side = left;
	  } else {
	    _curl_side = right;
	  }

	  if ( _curl_side  == _curl_from ) {
	    _curl_ratio = delta_x * curl_boost / WINDOW_AW;
	  } else {
	    _curl_ratio = 1.0f - ( delta_x * curl_boost / WINDOW_AW);
	  }
	} else {
	  _curl_side = left;
	  _curl_ratio = delta_x * curl_boost / WINDOW_BW;
	}
	if (((_direction == DIRECTION_LEFT) && [self isNext]) || ((_direction != DIRECTION_LEFT) && [self isPrev])) {
	  [self curlFor:_curl_side from:_curl_from ratio:_curl_ratio];
	}
      }
    }
  }
  /*
     if([self isNext]) [self beginToCurlLeft];
     */
}

- (float) getAnotherSide:(NSInteger) side {
  if ( side == left ) {
    return right;
  } else {
    return left;
  }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
  UITouch *touch = [touches anyObject];
  CGPoint point = [touch locationInView:self.view];

  float delta_x = point.x - touchStartPoint.x;

  BOOL page_change_flag = false;

  if ( _mode == page_mode_curl_start || _mode == page_mode_tap_on_zoom ) {
    if ( PAGING_BY_TAP && ((!PAGING_BY_BUTTON) || (_scrollView.zoomScale == 1.0f))) {
      if ( point.x < self.view.frame.size.width / 2 ) {
	if ( _direction == DIRECTION_LEFT ) {
	  [self notifyGoToNextPage];
	} else {
	  [self notifyGoToPrevPage];
	}
      } else {
	if ( _direction == DIRECTION_LEFT ) {
	  [self notifyGoToPrevPage];
	} else {
	  [self notifyGoToNextPage];
	}
      }
    } else if( PAGING_BY_BUTTON ) {
      if ((PAGING_BUTTON_MARGIN < point.x) && (point.x < PAGING_BUTTON_MARGIN + PAGING_BUTTON_WIDTH ) && (point.y < WINDOW_AH - PAGING_BUTTON_MARGIN) && (point.y > WINDOW_AH - (PAGING_BUTTON_MARGIN + PAGING_BUTTON_HEIGHT))) {
	if ((_direction == DIRECTION_LEFT) && ([self isNext])) {
	  [self next];
	  [self setPages];
	} else if([self isPrev]){
	  [self prev];
	  [self setPages];
	}
      } else if ((WINDOW_AW - PAGING_BUTTON_MARGIN > point.x) && (point.x > WINDOW_AW - (PAGING_BUTTON_MARGIN + PAGING_BUTTON_WIDTH )) && (point.y < WINDOW_AH - PAGING_BUTTON_MARGIN) && (point.y > WINDOW_AH - (PAGING_BUTTON_MARGIN + PAGING_BUTTON_HEIGHT))) {
	if ((_direction != DIRECTION_LEFT) && ([self isNext])) {
	  [self next];
	  [self setPages];
	} else if([self isPrev]) {
	  [self prev];
	  [self setPages];
	}
      }
    }
    [self setPages];
    _mode = page_mode_none;
  } else if ( _mode == page_mode_curling ) {
    if ( _windowMode == MODE_A ) {
      if ( _direction == DIRECTION_LEFT) {
	_curl_side = left;
      } else {
	_curl_side = right;
      }

      if ( _curl_from == left ) {
	_curl_ratio = delta_x * curl_boost / WINDOW_AW;
      } else {
	_curl_ratio = -1.0f * delta_x * curl_boost / WINDOW_AW;
      }
    } else {
      if ( _curl_from == left) {
	_curl_ratio = delta_x * curl_boost / WINDOW_BW;
	_curl_side = left;
      } else {
	_curl_ratio = -1.0f * delta_x * curl_boost / WINDOW_BW;
	_curl_side = right;
      }
    }

    if ( _curl_ratio > page_change_threshold) {
      _curl_to = [self getAnotherSide:_curl_from];

      if ( _direction == DIRECTION_LEFT ) {
	if ( _curl_from == left ) {
	  if ([self isNext]) [self notifyGoToNextPage];
	} else { 
	  if ([self isPrev]) [self notifyGoToPrevPage];
	}
      } else {
	if ( _curl_from == right ) {
	  if ([self isNext]) [self notifyGoToNextPage];
	} else { 
	  if ([self isPrev]) [self notifyGoToPrevPage];
	}
      }
    } else {
      _curl_to = _curl_from;
    }
    _mode = page_mode_release;
    [self performSelector:@selector(autoCurlAnimation)
	       withObject:nil 
	       afterDelay:PAGING_WAIT_TIME];
  } else {
    _mode = page_mode_none;
  }

  [_scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
  if ( MAX_ZOOM_SCALE != MIN_ZOOM_SCALE ) [_scrollView setScrollEnabled:YES];
  [_scrollView setCanCancelContentTouches:YES];
}

- (void)touchesCanceled:(NSSet*)touches withEvent:(UIEvent*)event {
  _mode = page_mode_none;
  [_scrollView setMaximumZoomScale:MAX_ZOOM_SCALE];
  if ( MAX_ZOOM_SCALE != MIN_ZOOM_SCALE ) [_scrollView setScrollEnabled:YES];
  [_scrollView setCanCancelContentTouches:YES];
}

- (void)notifyGoToNextPage {
  //NSLog(@"next");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"goToNextPageEvent" object:nil userInfo:nil];
}

- (void)notifyGoToPrevPage {
  //NSLog(@"prev");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"goToPrevPageEvent" object:nil userInfo:nil];
}

- (void)setModeToNone {
  _mode = page_mode_none;
  //NSLog(@"set none");
}

- (CGImageRef)getImageRefFromUIImage:(UIImage *)im0 {
  UIImage *im = im0;
  CGSize pageSize = im0.size;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, 
      pageSize.width, 
      pageSize.height, 
      8,				/* bits per component*/
      pageSize.width * 4, 	/* bytes per row */
      colorSpace, 
      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

  CGColorSpaceRelease(colorSpace);

  CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width, pageSize.height));

  CGRect imageRect = CGRectMake(0, 0, im.size.width, im.size.height);
  CGAffineTransform transform = aspectFit(imageRect,
      CGContextGetClipBoundingBox(context));
  CGContextConcatCTM(context, transform);
  CGContextDrawImage(context, imageRect, [im CGImage]);

  CGImageRef image = CGBitmapContextCreateImage(context);
  CGContextRelease(context);

  [UIImage imageWithCGImage:image];
  CGImageRelease(image);

  return image;
}

- (CGRect) getAspectFittingImageRect:(UIImage *)im0 {
  UIImage * im = im0;

  if ( (image_width / image_height) > (im.size.width / im.size.height) ) {
    image_margin_y = 0;
    image_margin_x = (image_width - (image_height * (im.size.width / im.size.height))) / 2;
    return CGRectMake(image_margin_x, 0, floor(image_height * (im.size.width / im.size.height)) , image_height);
  } else {
    image_margin_x = 0;
    image_margin_y = (image_height - (image_width * (im.size.height / im.size.width))) / 2;
    return CGRectMake(0, image_margin_y, image_width, floor(image_width * (im.size.height / im.size.width)));
  }
}

@end
