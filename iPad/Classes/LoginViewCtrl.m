    //
//  LoginViewCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/18.
//  Copyright 2010 3di. All rights reserved.
//

#import "LoginViewCtrl.h"
#import "Define.h"
#import "Util.h"

@implementation LoginViewCtrl
@synthesize nameTI = _nameTI;
@synthesize passTI = _passTI;
@synthesize okButton = _okButton;
@synthesize cancelButton = _cancelButton;
@synthesize newButton = _newButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)loginFinish {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:LOGIN_FINISH_END_EVENT object:self userInfo:nil];
}

- (IBAction)onOKButton:(id)sender {
	
//	NSLog(@"name: %@ pass: %@", _nameTI.text, _passTI.text);

	// Save user info.
	NSString *admitted = [[NSString alloc] initWithFormat:@"NO"];
	NSString *save_path = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], XML_DIRECTORY, USER_FILENAME];
	if ([Util isExist:save_path]) {
		[admitted release];
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:save_path];
		admitted = [[dict objectForKey:USER_ADMITTED] retain];
		[dict release];
	}
	
	NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_nameTI.text, USER_NAME, _passTI.text, USER_PASS, admitted, USER_ADMITTED, nil];
	[userInfo writeToFile:save_path atomically:YES];
	[userInfo release];
	[admitted release];
	[save_path release];
	
	[self loginFinish];
}

- (IBAction)onCancelButton:(id)sender {
	[self loginFinish];
}

- (IBAction)onNewButton:(id)sender {
	NSURL *url = [[NSURL alloc] initWithString:NEW_ACCOUNT_URL];
	UIApplication *app = [UIApplication sharedApplication];
	[app openURL:url];
	[url release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:LOGIN_FINISHED_AND_XML_CHECK_EVENT object:nil userInfo:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.nameTI release];
	[self.passTI release];
	[self.okButton release];
	[self.cancelButton release];
	[self.newButton release];
    [super dealloc];
}


@end
