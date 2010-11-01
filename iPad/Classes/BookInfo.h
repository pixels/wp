//
//  BookInfo.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/04.
//  Copyright 2010 3di. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookInfo : NSObject {
	NSString *_uuid;         // Book uuid
	NSString *_download;     // Download no
	NSString *_url;          // URL
	NSString *_md5;          // MD5
	NSString *_category;     // Category
	NSString *_categoryword; // Category
	NSString *_title;        // Book title name
	NSString *_titleword;    // Book title name
	NSString *_author;       // Book author name
	NSString *_authorword;   // Book author name
	NSInteger _length;       // Page count
	NSInteger _fake;         // Fake page
	NSInteger _direction;    // Page direction (0: Left 1: Right)
	NSString *_review;       // Book review
	BOOL     _oldVersion;    // This flag is true if the book released new version.
}

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *download;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *md5;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *categoryword;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *titleword;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *authorword;
@property (nonatomic, assign, readonly) NSInteger length;
@property (nonatomic, assign, readonly) NSInteger fake;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, assign) BOOL oldVersion;

- (void)setLength:(NSUInteger)pageLength;

@end
