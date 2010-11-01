    //
//  ReadViewBCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import "ReadViewBCtrl.h"
#import "Util.h"
#import "Define.h"
#import "DirectionType.h"
#import "UIImageViewWithTouch.h"

#define PAGE_MARGIN_W  2
#define PAGE_MARGIN_WC 2
#define PAGE_MARGIN_H  0

@implementation ReadViewBCtrl
@synthesize scrollView = _scrollView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_scrollView.delegate = self;
}

- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum direction:(NSInteger)direction {
	[super setup:uuid selectPage:selectPage pageNum:pageNum direction:direction];
	
	CGRect frame;
	frame = _scrollView.frame;
	frame.size.width = WINDOW_BW;
	frame.size.height = WINDOW_BH;
	frame.origin.x = 0;
	frame.origin.y = 0;
	_scrollView.frame = frame;
	_scrollView.contentSize = CGSizeMake(WINDOW_BW * (pageNum / 2), WINDOW_BH);
//	if (direction == DIRECTION_LEFT)
//		_scrollView.contentOffset = CGPointMake(WINDOW_BW * (pageNum / 2 - 1), 0);

	NSInteger scrollPointX = selectPage;
	if (_direction == DIRECTION_LEFT)
		scrollPointX = _maxPage - (selectPage - 2);
	else {
		scrollPointX = selectPage + (selectPage % 2);
	}

	_scrollView.contentOffset = CGPointMake(WINDOW_BW * (scrollPointX / 2 - 1), 0);
	[self setPage:selectPage];
}

- (BOOL)isNext {
	NSInteger tmp = _maxPage - ((_maxPage + 1) % 2);
	
	if (_currentPage < tmp)
		return YES;
	
	return NO;
}

- (void)next {
	[super next];

	NSInteger targetPage = 	_currentPage + 2;
	if (targetPage > _maxPage)
		return;
	
	NSInteger scrollPointX = targetPage;
	if (_direction == DIRECTION_LEFT)
		scrollPointX = _maxPage - targetPage;
	
	_scrollView.contentOffset = CGPointMake(WINDOW_BW * (scrollPointX / 2), 0);
	[self releaseFarBooks:targetPage];
}

- (BOOL)isPrev {
	if (_currentPage > 1)
		return YES;
	
	return NO;
}

- (void)prev {
	[super prev];
	
	NSInteger targetPage = 	_currentPage - 2;
	if (targetPage < 1)
		return;
	
	NSInteger scrollPointX = targetPage;
	if (_direction == DIRECTION_LEFT)
		scrollPointX = _maxPage - targetPage;
	
	_scrollView.contentOffset = CGPointMake(WINDOW_BW * (scrollPointX / 2), 0);
	[self releaseFarBooks:targetPage];
}

- (void)requestPage:(NSInteger)targetPage {
	[super requestPage:targetPage];
	
	if (_direction == DIRECTION_LEFT)
		targetPage = _maxPage - targetPage;
	
	_scrollView.contentOffset = CGPointMake(WINDOW_BW * (targetPage / 2), 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	CGFloat pageWidth = _scrollView.frame.size.width;  
	NSInteger tmp = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
    NSInteger targetPage = tmp + 1;

	if (_direction == DIRECTION_LEFT)
		targetPage = _maxPage - (targetPage * 2 + 1);
	else {
		targetPage = targetPage * 2 + 1;
	}
	
	[self setPage:targetPage];
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//- (void)scrollViewDidEndDragging:willDeclerate:(UIScrollView *)scrollView {
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
	
	[self setPage:_currentPage];
	[self releaseFarBooks:_currentPage];
}

- (void)releaseFarBooks:(NSInteger)targetPage {
	for (NSInteger i = 1; i < _maxPage; i++) {
		if (i < (targetPage - 4) || (targetPage + 4) < i) {
			NSNumber *number = [NSNumber numberWithInteger:i];
			if ([_booksList objectForKey:number]) {
				[super releaseBook:number removeFromList:YES];
			}
		}
	}
}

- (void)setPage:(NSInteger)selectPage {

	NSLog(@"page: %d", selectPage);
	
	if (selectPage == _currentPage)
		return;
	
	[super setPage:selectPage small:NO];
	
	NSInteger i;
	NSInteger selectPageWithOffset;
	for (i = 0; i < 6; i++) {
		selectPageWithOffset = selectPage + (i - 2);
		NSInteger pagePosition = selectPageWithOffset;
		if (_direction == DIRECTION_LEFT)
			pagePosition = _maxPage - pagePosition;
		else {
			pagePosition = pagePosition - 1;
		}
		
		NSNumber *number = [NSNumber numberWithInteger:selectPageWithOffset];
		if ([_booksList objectForKey:number]) {
//			NSLog(@"already exist page: %d", selectPageWithOffset);
		} else {
			NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, _uuid];
			NSString *image_path = [Util makeBookPathFormat:documentDir pageNo:selectPageWithOffset extension:BOOK_EXTENSION];
			UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
//			NSLog(@"path: %@", image_path);
			if (image) {
				UIImageViewWithTouch *imageView = [[UIImageViewWithTouch alloc] initWithImage:image];
				[imageView setContentMode:UIViewContentModeScaleAspectFit];
				[imageView setUserInteractionEnabled:YES];
				[imageView setTag:selectPageWithOffset];
				CGFloat w = (WINDOW_BW / 2) - (PAGE_MARGIN_W * 2);
				CGFloat h = WINDOW_BH - PAGE_MARGIN_H;
				CGFloat x;
				if (pagePosition % 2) {
					x = WINDOW_BW * (pagePosition / 2) + (WINDOW_BW / 2) * (pagePosition % 2) + PAGE_MARGIN_WC;
				}
				else {
					x = WINDOW_BW * (pagePosition / 2) + (WINDOW_BW / 2) * (pagePosition % 2) + (PAGE_MARGIN_W * 2);
				}
				CGFloat y = (PAGE_MARGIN_H / 4);
				[imageView setFrame:CGRectMake(x, y, w, h)];
				[_scrollView addSubview:imageView];
				[imageView release];
				[image release];
				[_booksList setObject:imageView forKey:number];
				
//				NSLog(@"add page: %d", selectPageWithOffset);
			}
			[image_path release];
			[documentDir release];
		}
	}
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
	[self.scrollView release];
    [super dealloc];
}


@end
