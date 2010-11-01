//
//  ReadViewBaseCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadViewBaseCtrl : UIViewController <UIScrollViewDelegate> {
	NSMutableDictionary *_pageList;
	NSMutableDictionary *_viewList;
	NSMutableDictionary *_imageList;
	NSMutableDictionary *_booksList;
	NSString *_uuid;
	NSInteger _direction;
	NSInteger _currentPage;
	NSInteger _maxPage;
	float _scrollOffsetX;
	int _pastWindowMode;
	int _windowMode;

	UIView *_pageView;
}

@property (assign) NSInteger currentPage;

- (BOOL)isNext;
- (void)next;
- (BOOL)isPrev;
- (void)prev;
- (void)requestPage:(NSInteger)targetPage;
- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum direction:(NSInteger)direction windowMode:(NSInteger)windowMode;
- (void)setPage:(NSInteger)selectPage windowMode:(NSInteger)windowMode;
- (void)saveBookmark;
- (void)releaseImage:(NSNumber*)pageNo removeFromList:(BOOL)removeFromList;
- (void)releaseBook:(NSNumber*)pageNo removeFromList:(BOOL)removeFromList;
- (void)releaseAllBooks;
- (void)removeAllSubviewsFrom:(UIView *)targetView;

@end
