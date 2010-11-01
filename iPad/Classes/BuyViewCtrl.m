    //
//  BuyViewCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/11.
//  Copyright 2010 3di. All rights reserved.
//

#import "BuyViewCtrl.h"
#import "Define.h"

@implementation BuyViewCtrl
@synthesize webView = _webView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSString *url = [[NSString alloc] initWithFormat:TOP_URL];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
							  cachePolicy:NSURLRequestUseProtocolCachePolicy
							  timeoutInterval:60.0f
							  ];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
	}
	else {
		// network error
	}

	[request release];
	[url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Connection connection didReceiveResponse");
	
	NSString *url = [[NSString alloc] initWithFormat:@"http://wepublish.jp/"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
												  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:60.0f
							 ];
	
	[_webView loadRequest:request];
	[request release];
	[url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Connection connection didReceiveAuthenticationChallenge");
	
    if ([challenge proposedCredential]) {
        [connection cancel];
    }
	else {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:@"wpauth" password:@"ka08tbj3hZfa" persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection connection didFailWithError");
	
    [connection release];
	NSString *message = [[NSString alloc] initWithFormat:@"%@", NETWORK_ERROR_MESSAGE];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[message release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.webView release];
    [super dealloc];
}


@end
