//
//  XMLController.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/13.
//  Copyright 2010 3di. All rights reserved.
//

#import "XMLController.h"
#import "BookCollection.h"
#import "BookInfo.h"
#import "Util.h"
#import "Define.h"

@implementation XMLController

- (id)init {
	_outputFilePath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], XML_DIRECTORY, LIST_FILENAME];
	_userFilePath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], XML_DIRECTORY, USER_FILENAME];
	_savedData = [[NSData alloc] initWithContentsOfFile:_outputFilePath];
	_data = [[NSMutableData alloc] init];
	_savedBookCollection = [[BookCollection alloc] init];
	_bookCollection = [[BookCollection alloc] init];
	_updateRetryCount = 0;
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(onLoginFinishedAndXMLCheckSelect:) name:LOGIN_FINISHED_AND_XML_CHECK_EVENT object:nil];
	
//	// MD5 test
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
//	NSString *md5 = [Util getMD5ChecksumOfFile:path];
//	NSLog(@"%@", md5);
	
	return [super init];
}

- (void)update:(NSString*)url checlToServer:(BOOL)checlToServer {
	
	checlToServer_ = checlToServer;
	[_data setLength:0];
	[_bookCollection releaseAll];
	
	BOOL skippable = NO;
	if (!checlToServer) {
		if ([Util isExist:_userFilePath]) {
			NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:_userFilePath];
			if ([@"YES" isEqual:[userInfo objectForKey:USER_ADMITTED]]) {
				skippable = YES;
			}
			else {
				checlToServer_ = YES;
			}
		}
		else {
			checlToServer_ = YES;
		}
	}
	// リトライ回数を超えた
	if (_updateRetryCount > UPDATE_RETRY_COUNT || skippable) {
		[self alertIfDontExistData:AUTHENTICATION_ERROR_MESSAGE];
	}
	
	// 更新作業
	else {
		
		// First access only.
		if (!_url) {
			_url = [url retain];
		}

		// 初回
		if (_updateRetryCount == 0 && [Util isExist:_userFilePath]) {
			[self updateContinue];
		}
		else {
			// 認証
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			[notificationCenter postNotificationName:AUTHENTICATION_EVENT object:nil userInfo:nil];
		}
		
		_updateRetryCount++;
	}
}

- (BOOL)loadLocalXml {
	
	if ([Util isExist:_outputFilePath]) {
		_data = [_data initWithContentsOfFile:_outputFilePath];
		[self parse:_data savedXMLLoad:NO];
		return YES;
	}
	
	return NO;
}

- (void)updateContinue {
	
	NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:_userFilePath];
	NSString *mode = @"getxml";
	NSString *user = [userInfo objectForKey:USER_NAME];
	NSString *pass = [userInfo objectForKey:USER_PASS];
//	NSLog(@"updateContinue user: %@ pass: %@", user, pass);
	
	NSString *params = [[NSString alloc] initWithFormat:@"mode=%@&mypage_login_email=%@&mypage_login_pass=%@", mode, user, pass];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
									initWithURL:[NSURL URLWithString:_url]
									cachePolicy:NSURLRequestUseProtocolCachePolicy
									timeoutInterval:60.0
									];
	[request setHTTPMethod:@"POST"];	//メソッドをPOSTに指定します
	[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	[params release];
	[userInfo release];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		[_data setLength:0];
	}
	else {
		// Inform the user that the connection failed.
	}
	
	[request release];
}

- (void)saveXML {
	[_data writeToFile:_outputFilePath atomically:YES];
}

- (void)alertIfDontExistData:(NSString *)message {
	// Load loacal xml if old xml file exist in the local.
	BOOL loadLocalXmlFile = [self loadLocalXml];
	if (loadLocalXmlFile) {
	}
	
	// Show alert if old xml file don't exist in the local.
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		NSLog(@"Don't exits outputFilePath: %@", _outputFilePath);
	}	
}

- (void)checkVersion {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	BookInfo *info;
	BookInfo *savedInfo;
	NSDate* date;
	NSDate* savedDate;
	
	NSInteger length = [_bookCollection count];
	for (NSInteger i = 0; i < length; i++) {
		info = [_bookCollection getAt:i];
		savedInfo = [_savedBookCollection getByKey:info.uuid];
		
		if (!info || !savedInfo) {
			NSLog(@"[INFO] XMLController.m checkVersion: this is the new item!!");
			info.oldVersion = YES;
			continue;
		}
		
		date = [inputFormatter dateFromString:info.download];
		savedDate = [inputFormatter dateFromString:savedInfo.download];
		
		info.oldVersion = NO;
		switch ([date compare:savedDate]){
			case NSOrderedAscending: // 日付がsavedDateに比べて早い
				break;
			case NSOrderedSame: // 同じ
				break;
			case NSOrderedDescending: // 日付がsavedDateに比べて遅い
				info.oldVersion = YES;
				break;
		}
	}
}

- (void)parse:(NSData *)data savedXMLLoad:(BOOL)savedXMLLoad {
	_savedXMLLoad = savedXMLLoad;
	
	NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Connection connection didReceiveResponse");
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"Connection connection didReceiveData");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Connection connection didReceiveAuthenticationChallenge, host: %@", challenge.protectionSpace.host);
	
//	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//		if ([@"wepublish.jp" isEqualToString:challenge.protectionSpace.host])
//			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//		[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//	}
	
	if ([challenge proposedCredential]) {
		[connection cancel];
	}
	else {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:AUTH_USERNAME password:AUTH_PASSWORD persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	}
	
}

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    NSLog(@"Connection connection canAuthenticateAgainstProtectionSpace");
//	
//	if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
////		if(shouldAllowSelfSignedCert) {
////			return YES; // Self-signed cert will be accepted
////		} else {
////			return NO;  // Self-signed cert will be rejected
////		}
//		return YES;
//	}
//	
//	return NO;	
// }

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);

    [connection release];
	[self alertIfDontExistData:NETWORK_ERROR_LOGO_MESSAGE];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	// Debug
	NSString* str;
	str = [[NSString alloc] initWithData:_data encoding:NSASCIIStringEncoding];
//	NSLog(@"Connection connectionDidFinishLoading byte len: %d data: %@", [_data length], str);
//	[str release];
		
	[connection release];
	
	// 認証がうまくいった場合
	if ([_data length] > 0 && ([str compare:@"NG"] != NSOrderedSame)) {
		NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:_userFilePath];
		[userInfo setValue:@"YES" forKey:USER_ADMITTED];
		[userInfo writeToFile:_userFilePath atomically:YES];
		[userInfo release];
		
		_updateRetryCount = 0;
		[self saveXML];
		[self parse:_data savedXMLLoad:NO];
	}
	
	else {
		[self update:_url checlToServer:YES];
	}

}

- (void)onLoginFinishedAndXMLCheckSelect:(NSNotification *)notification {
	[self updateContinue];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
//	NSLog(@"parser didStartElement: %@ namespaceURI: %@ qName: %@", elementName, namespaceURI, qName);
	
	if ([elementName isEqualToString:@"book"]) {
		if (_currentBookInfo) {
			[_currentBookInfo release];
		}
		_currentBookInfo = [[BookInfo alloc] init];
	}
	
	_currentNodeType = [elementName retain];
} 

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	BookInfo *bi = _currentBookInfo;
	
	if ([_currentNodeType isEqualToString:@"id"]) {
		bi.uuid = [string retain];
	}
	
	else if ([_currentNodeType isEqualToString:@"download"]) {
		bi.download = [string retain];
	}
	
	else if ([_currentNodeType isEqualToString:@"url"]) {
		if (bi.url) {
			bi.url = [[NSString alloc] initWithFormat:@"%@%@", bi.url, string];
			[bi.url release];
		}
		else {
			bi.url = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"md5"]) {
		bi.md5 = [string retain];
	}
	
	else if ([_currentNodeType isEqualToString:@"category"]) {
		if (bi.category) {
			bi.category = [[NSString alloc] initWithFormat:@"%@%@", bi.category, string];
			[bi.category release];
		}
		else {
			bi.category = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"categoryword"]) {
		if (bi.categoryword) {
			bi.categoryword = [[NSString alloc] initWithFormat:@"%@%@", bi.categoryword, string];
			[bi.categoryword release];
		}
		else {
			bi.categoryword = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"title"]) {
		if (bi.title) {
			bi.title = [[NSString alloc] initWithFormat:@"%@%@", bi.title, string];
			[bi.title release];
		}
		else {
			bi.title = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"titleword"]) {
		if (bi.titleword) {
			bi.titleword = [[NSString alloc] initWithFormat:@"%@%@", bi.titleword, string];
			[bi.titleword release];
		}
		else {
			bi.titleword = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"author"]) {
		if (bi.author) {
			bi.author = [[NSString alloc] initWithFormat:@"%@%@", bi.author, string];
			[bi.author release];
		}
		else {
			bi.author = [string retain];
		}
	}
	
	else if ([_currentNodeType isEqualToString:@"authorword"]) {
		//		bi.author = [[NSString alloc] initWithFormat:@"%@", string];
	}
	
	else if ([_currentNodeType isEqualToString:@"length"]) {
		bi.length = [string intValue];
	}
	
	else if ([_currentNodeType isEqualToString:@"direction"]) {
		bi.direction = [string intValue];
	}
	
	else if ([_currentNodeType isEqualToString:@"review"]) {
		if (bi.review) {
			bi.review = [[NSString alloc] initWithFormat:@"%@%@", bi.review, string];
			[bi.review release];
		}
		else {
			bi.review = [[NSString alloc] initWithFormat:@"%@", string];
		}
	}
	
//	NSLog(@"foundCharacters currentNodeType: %@ string: %@", _currentNodeType, string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName   {  
//	NSLog(@"parser didEndElement: %@ namespaceURI: %@ qName: %@", elementName, namespaceURI, qName);
	
	if ([elementName isEqualToString:@"book"]) {
//		NSLog(@"didEndElement _savedXMLLoad: %d, uuid: %@ download: %@ url: %@ md5: %@ category: %@ title: %@ author: %@ length: %d direction: %d review: %@",
//			  _savedXMLLoad,
//			  _currentBookInfo.uuid,
//			  _currentBookInfo.download,
//			  _currentBookInfo.url,
//			  _currentBookInfo.md5,
//			  _currentBookInfo.category,
//			  _currentBookInfo.title,
//			  _currentBookInfo.author,
//			  _currentBookInfo.length,
//			  _currentBookInfo.direction,
//			  _currentBookInfo.review
//			  );
		
		if (_savedXMLLoad) {
			[_savedBookCollection addByInfo:_currentBookInfo];
		}
		else {
			[_bookCollection addByInfo:_currentBookInfo];
		}
	}
	
	if ([elementName isEqualToString:@"root"]) {
		if (_savedXMLLoad || !_savedData) {
			if (_savedData) {
				[self checkVersion];
			}
			NSNumber *checkToServerNum = [NSNumber numberWithBool:checlToServer_];
			NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  _bookCollection,
								  @"BOOK_COLLECTION",
								  checkToServerNum,
								  @"CHECK_TO_SERVER",
								  nil];
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			[notificationCenter postNotificationName:PARSE_END_EVENT object:nil userInfo:dict];
			[dict release];
		}
		else if (_savedData) {
			[self parse:_savedData savedXMLLoad:YES];
		}
	}
	
	if (_currentNodeType) {
		[_currentNodeType release];
		_currentNodeType = nil;
	}
}

- (void)dealloc {
	[_url release];
	[_currentBookInfo release];
	[_savedBookCollection release];
	[_bookCollection release];
	[_outputFilePath release];
	[_userFilePath release];
	[_data release];
	[super dealloc];
}

@end
