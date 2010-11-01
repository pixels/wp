//
//  BookCollection.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/04.
//  Copyright 2010 3di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortType.h"

@class BookInfo;

@interface BookCollection : NSObject {
	NSMutableArray *_books;
	NSMutableDictionary *_booksDic; // value is BookInfo key is uuid.
}

- (NSUInteger)count;
- (void)add:(NSString *)uuid
   download:(NSString *)download
		url:(NSString *)url
		md5:(NSString *)md5
   category:(NSString *)category
categoryword:(NSString *)categoryword
	  title:(NSString *)title
  titleword:(NSString *)titleword
	 author:(NSString *)author
 authorword:(NSString *)authorword
	 length:(NSUInteger)length
  direction:(NSUInteger)direction
	 review:(NSString *)review;
- (void)addByInfo:(BookInfo *)info;
- (BookInfo *)getByKey:(NSString *)key;
- (BookInfo *)getAt:(NSUInteger)index;
- (void)sort:(SortType)type;
- (void)releaseAll;
NSInteger alphabeticTitleSort(BookInfo *obj1, BookInfo *obj2, void *reverse);
NSInteger alphabeticAuthorSort(BookInfo *obj1, BookInfo *obj2, void *reverse);
NSInteger alphabeticDonwloadSort(BookInfo *obj1, BookInfo *obj2, void *reverse);
NSInteger alphabeticCategorySort(BookInfo *obj1, BookInfo *obj2, void *reverse);

@end
