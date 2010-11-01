//
//  BookCollection.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/04.
//  Copyright 2010 3di. All rights reserved.
//

#import "BookCollection.h"
#import "BookInfo.h"

@implementation BookCollection

- (id) init {
	
	_books = [[NSMutableArray alloc] init];
	_booksDic = [[NSMutableDictionary alloc] init];
	return [super init];
}

- (NSUInteger)count {
	return [_books count];
}

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
  review:(NSString *)review {
	
	// return this function if uuid is empty.
	if ([uuid isEqual:@""])
		return;
	
	BookInfo *bi = [[BookInfo alloc] init];
	bi.uuid = uuid;
	bi.download = download;
	bi.url = url;
	bi.md5 = md5;
	bi.category = category;
	bi.categoryword = categoryword;
	bi.title = title;
	bi.titleword = titleword;
	bi.author = author;
	bi.authorword = authorword;
	bi.direction = direction;
	bi.review = review;
	[bi setLength:length];
	
	[_books addObject:bi];
	[_booksDic setObject:bi forKey:bi.uuid];
	
//	NSLog(@"BookCollection.m add info key: %@", bi.uuid);
	[bi release];
}

- (void)addByInfo:(BookInfo *)info {
	BookInfo *bi = [[BookInfo alloc] init];
	bi.uuid = info.uuid;
	bi.download = info.download;
	bi.url = info.url;
	bi.md5 = info.md5;
	bi.category = info.category;
	bi.categoryword = info.categoryword;
	bi.title = info.title;
	bi.titleword = info.titleword;
	bi.author = info.author;
	bi.authorword = info.authorword;
	[bi setLength:info.length];
	bi.direction = info.direction;
	bi.review = info.review;
	
	[_books addObject:bi];
	[_booksDic setObject:bi forKey:bi.uuid];
	
//	NSLog(@"BookCollection.m add info key: %@", bi.uuid);
	[bi release];
}

- (BookInfo *)getByKey:(NSString *)key {
	return [_booksDic objectForKey:key];
}

- (BookInfo *)getAt:(NSUInteger)index {
	if (index < [_books count]) {
		return [_books objectAtIndex:index];
	}
	
	return nil;
}

- (void)sort:(SortType)type {
	int reverseSort = NO;
	
	switch (type) {
		case SORT_TITLE:
			[_books sortUsingFunction:alphabeticTitleSort context:&reverseSort];
			break;
			
		case SORT_AUTHOR:
			[_books sortUsingFunction:alphabeticAuthorSort context:&reverseSort];
			break;
			
		case SORT_DOWNLOAD:
			[_books sortUsingFunction:alphabeticDonwloadSort context:&reverseSort];
			break;
			
		case SORT_CATEGORY:
			[_books sortUsingFunction:alphabeticCategorySort context:&reverseSort];
			break;
	}
}

NSInteger alphabeticTitleSort(BookInfo *obj1, BookInfo *obj2, void *reverse){
	if ((NSInteger *)reverse == NO) 
		return [[obj2 titleword] localizedCaseInsensitiveCompare:[obj1 titleword]];
	else
		return [[obj1 titleword] localizedCaseInsensitiveCompare:[obj2 titleword]];
}

NSInteger alphabeticAuthorSort(BookInfo *obj1, BookInfo *obj2, void *reverse){
	if ((NSInteger *)reverse == NO) 
		return [[obj2 authorword] localizedCaseInsensitiveCompare:[obj1 authorword]];
	else
		return [[obj1 authorword] localizedCaseInsensitiveCompare:[obj2 authorword]];
}

NSInteger alphabeticDonwloadSort(BookInfo *obj1, BookInfo *obj2, void *reverse){ 
	if ((NSInteger *)reverse == NO) 
		return [[obj2 download] localizedCaseInsensitiveCompare:[obj1 download]];
	else
		return [[obj1 download] localizedCaseInsensitiveCompare:[obj2 download]];
}

NSInteger alphabeticCategorySort(BookInfo *obj1, BookInfo *obj2, void *reverse){ 
	if ((NSInteger *)reverse == NO) 
		return [[obj2 categoryword] localizedCaseInsensitiveCompare:[obj1 categoryword]];
	else
		return [[obj1 categoryword] localizedCaseInsensitiveCompare:[obj2 categoryword]];
}

- (void)releaseAll {
	BookInfo *info;
	for (info in _books) {
		[info release];
	}
	[_books removeAllObjects];
	
	_booksDic = [[NSMutableDictionary alloc] init];
}

- (void)dealloc {
	[self releaseAll];
	[_booksDic release];
	[_books release];
	[super dealloc];
}

@end
