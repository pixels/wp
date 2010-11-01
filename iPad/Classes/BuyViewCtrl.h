//
//  BuyViewCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/11.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuyViewCtrl : UIViewController{
	UIWebView *_webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
