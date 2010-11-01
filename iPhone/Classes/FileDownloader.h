//
//  XMLController.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/13.
//  Copyright 2010 3di. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookCollection;

@interface FileDownloader : NSObject {
	NSUInteger _operate; // 0: getxmlurl 1: getzip
	NSString *_uuid;
	NSString *_path;
	NSString *_pathWithoutExtension;
	NSMutableData *_data;
}

- (void)download:(NSString*)uuid url:(NSString*)url;

@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSString *pathWithoutExtension;

@end
