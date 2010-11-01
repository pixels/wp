    //
//  ReadViewBaseCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import "ReadViewBaseCtrl.h"
#import "Define.h"

@implementation ReadViewBaseCtrl
@synthesize currentPage = _currentPage;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_pageList = [[NSMutableDictionary alloc] init];
	_viewList = [[NSMutableDictionary alloc] init];
	_imageList = [[NSMutableDictionary alloc] init];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(onAppFinishEventSelect:) name:APP_FINISH_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onReadToSelectEventSelect:) name:READ_TO_SELECT_EVENT object:nil];
}

- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum direction:(NSInteger)direction windowMode:(NSInteger)windowMode {
	_uuid = [uuid retain];
	_direction = direction;
	_currentPage = -1;
	_maxPage = pageNum;
}

- (void)loadPages:(NSInteger)selectPage windowMode:(NSInteger)windowMode {
}

- (void)setPage:(NSInteger)selectPage windowMode:(NSInteger)windowMode {
	_currentPage = selectPage;
	
	if ( _currentPage > _maxPage ) {
	  _currentPage = _maxPage;
	} else if (_currentPage < 1) {
	  _currentPage = 1;
	}
	
//	NSLog(@"setPage selectPage: %d", selectPage);
//
	NSNumber *pageNumber;
	pageNumber = [NSNumber numberWithInt:selectPage];
	[[NSNotificationCenter defaultCenter] postNotificationName:PAGE_CHANGE_EVENT object:pageNumber userInfo:nil];
}

- (BOOL)isNext { return YES; }
- (void)next { }
- (BOOL)isPrev { return YES; }
- (void)prev { }
- (void)requestPage:(NSInteger)targetPage {}

- (void)saveBookmark {
	NSNumber *_page = [NSNumber numberWithInt:_currentPage];
	NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_uuid, BOOKMARK_UUID, _page, BOOKMARK_PAGE, nil];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:BOOKMARK_SAVE_EVENT object:nil userInfo:dic];
	[dic release];
}

- (void)releaseBook:(NSNumber*)pageNo removeFromList:(BOOL)removeFromList {
	UIImageView *iv = [_pageList objectForKey:pageNo];
	iv.image = nil;
	[iv removeFromSuperview];
	
	if (removeFromList) {
	  [_pageList removeObjectForKey:pageNo];
	}

//	NSLog(@"releaseBook pageNo: %d", [pageNo intValue]);
}

- (void)releaseImage:(NSNumber*)pageNo removeFromList:(BOOL)removeFromList {
	if (removeFromList) {
	  [_imageList removeObjectForKey:pageNo];
	}

//	NSLog(@"releaseBook pageNo: %d", [pageNo intValue]);
}

- (void)releaseAllBooks {
	for (id key in _pageList) {
		[self releaseBook:key removeFromList:NO];
	}
	[_pageList removeAllObjects];
	[_imageList removeAllObjects];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	NSLog(@"scrollViewWillBeginDragging %f", scrollView.contentOffset.x);
	_scrollOffsetX = scrollView.contentOffset.x;
}

- (void)onAppFinishEventSelect:(NSNotification *)notification {
	[self saveBookmark];
}

- (void)onReadToSelectEventSelect:(NSNotification *)notification {
	[self saveBookmark];
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

- (void)removeAllSubviewsFrom:(UIView *)targetView {
  for(UIView *aSubview in [targetView subviews]) {
    [aSubview removeFromSuperview];
  }
}

- (void)dealloc {
	if (_uuid != nil)
	{
		[_uuid release];
		_uuid = nil;
	}
	[self releaseAllBooks];
	[_pageList release];
    [super dealloc];
}


@end
