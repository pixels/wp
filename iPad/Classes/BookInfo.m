//
//  BookInfo.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/04.
//  Copyright 2010 3di. All rights reserved.
//

#import "BookInfo.h"


@implementation BookInfo
@synthesize uuid = _uuid;
@synthesize download = _download;
@synthesize url = _url;
@synthesize md5 = _md5;
@synthesize category = _category;
@synthesize categoryword = _categoryword;
@synthesize title = _title;
@synthesize titleword = _titleword;
@synthesize author = _author;
@synthesize authorword = _authorword;
@synthesize length = _length;
@synthesize fake = _fake;
@synthesize direction = _direction;
@synthesize review = _review;
@synthesize oldVersion = _oldVersion;

- (void)setLength:(NSUInteger)pageLength {
	// _length = (pageLength % 2 == 0) ? pageLength : (pageLength + 1);
	_length = pageLength;
	_fake = pageLength % 2;
}

@end
