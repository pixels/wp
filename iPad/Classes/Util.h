//
//  Util.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/13.
//  Copyright 2010 3di. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {

}

+ (NSString*)getLocalDocument;
+ (BOOL)isExist:(NSString *)path;
+ (NSString *)getMD5ChecksumOfFile:(NSString*)pathOfFile;
+ (NSString *)getMD5OfByte:(const char *)bytes;
+ (NSString *)array2hexForMD5:(unsigned char *)value;
+ (NSString *)makeBookPathFormat:(NSString *)dir pageNo:(NSUInteger)pageNo extension:(NSString *)extension;
+ (NSUInteger)realMemory;
+ (CGSize)makeAspectFitCGSize:(CGSize)origin target:(CGSize)target;

@end
