//
//  XMLController.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/13.
//  Copyright 2010 3di. All rights reserved.
//

#import "FileDownloader.h"
#import "Util.h"
#import "Define.h"

@implementation FileDownloader
@synthesize uuid = _uuid;
@synthesize path = _path;
@synthesize pathWithoutExtension = _pathWithoutExtension;

- (id)init {
	return [super init];
}

- (void)download:(NSString*)uuid url:(NSString*)url {

	_operate = 0;
	_uuid = [uuid retain];
	_pathWithoutExtension = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, uuid];
	_path = [[NSString alloc] initWithFormat:@"%@.zip", _pathWithoutExtension];
	NSString *userFilePath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], XML_DIRECTORY, USER_FILENAME];
	NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:userFilePath];
	NSString *mode = @"getzip";
	NSString *user = [userInfo objectForKey:USER_NAME];
	NSString *pass = [userInfo objectForKey:USER_PASS];
//	NSLog(@"updateContinue user: %@ pass: %@ path: %@", user, pass, _path);
	
	NSString *params = [[NSString alloc] initWithFormat:@"mode=%@&mypage_login_email=%@&mypage_login_pass=%@&book_id=%@", mode, user, pass, uuid];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
									initWithURL:[NSURL URLWithString:UPDATE_URL]
									cachePolicy:NSURLRequestUseProtocolCachePolicy
									timeoutInterval:60.0
									];
	[request setHTTPMethod:@"POST"];	//メソッドをPOSTに指定します
	[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	[params release];
	[userInfo release];
	[userFilePath release];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		if (_data) {
			[_data setLength:0];
		} else {
			_data = [[NSMutableData alloc] init];
		}
	}
	else {
		// Inform the user that the connection failed.
	}
	
	[request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  // NSLog(@"did receive response");
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  // NSLog(@"did receive data");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Connection connection didReceiveAuthenticationChallenge, host: %@", challenge.protectionSpace.host);
	
	if ([challenge proposedCredential]) {
		[connection cancel];
	}
	else {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:AUTH_USERNAME password:AUTH_PASSWORD persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error outputFilePath: %@ - %@ %@",
		  _path,
		  [error localizedDescription],
		  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);

    [connection release];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:DLBOOK_ERROR_EVENT object:self userInfo:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	// Debug
	// NSString* str;
	// str = [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
	// NSLog(@"Connection connectionDidFinishLoading byte len: %d path: %@ data: %@", [_data length], _path, str);
	// [str release];
	
	[connection release];
	[_data writeToFile:_path atomically:YES];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:DLBOOK_SUCCESS_EVENT object:self userInfo:nil];
}

- (void)dealloc {
	[_uuid release];
	[_path release];
	[_pathWithoutExtension release];
	[_data release];
	[super dealloc];
}

@end
