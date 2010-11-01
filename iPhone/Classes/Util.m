//
//  Util.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/13.
//  Copyright 2010 3di. All rights reserved.
//

#import "CommonCrypto/CommonDigest.h"
#import "Util.h"
#import "Define.h"

@implementation Util

+ (NSString*)getLocalDocument {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (BOOL)isExist:(NSString *)path {
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)getMD5FromString:(NSString*)code {
	const char *cstr = [code UTF8String]; // C言語の文字列を取得する
	return [self getMD5OfByte:cstr];
}

+ (NSString *)getMD5ChecksumOfFile:(NSString*)pathOfFile {
	const char *cstr = [[NSData dataWithContentsOfFile:pathOfFile] bytes];
	return [self getMD5OfByte:cstr];
}

+ (NSString *)getMD5OfByte:(const char *)bytes {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(bytes, strlen(bytes), result);
	
	return [self array2hexForMD5:result];
}

+ (NSString *)array2hexForMD5:(unsigned char *)value {
	return [NSString
			stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			value[0], value[1],
			value[2], value[3],
			value[4], value[5],
			value[6], value[7],
			value[8], value[9],
			value[10], value[11],
			value[12], value[13],
			value[14], value[15]];
}

+ (NSString *)makeBookPathFormat:(NSString *)dir pageNo:(NSUInteger)pageNo extension:(NSString *)extension {
	return [[NSString alloc] initWithFormat:@"%@/%04d.%@", dir, pageNo, extension];
}

+ (CGSize)makeAspectFitCGSize:(CGSize)origin target:(CGSize)target {
	float xRate = origin.width / target.width;
	float yRate = origin.height / target.height;
	
	CGSize tmp;
	if (xRate < yRate) {
		tmp = CGSizeMake(origin.width / yRate, origin.height / yRate);
	}
	else {
		tmp = CGSizeMake(origin.width / xRate, origin.height / xRate);
	}
	
	return tmp;
}

@end
