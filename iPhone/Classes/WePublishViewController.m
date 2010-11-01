//
//  WePublishViewController.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/26.
//  Copyright 3di 2010. All rights reserved.
//

#import "WePublishAppDelegate.h"
#import "WePublishViewController.h"
#import "BookCollection.h"
#import "BookInfo.h"
#import "LogoViewCtrl.h"
#import "XMLController.h"
#import "ListViewCtrl.h"
#import "BuyViewCtrl.h"
#import "DetailViewCtrl.h"
#import "ReadViewCtrl.h"
#import "LoginViewCtrl.h"
#import "WindowModeType.h"
#import "Define.h"
#import "DirectionType.h"
#import "FileDownloader.h"
#import "ZipArchive.h"
#import "Util.h"

//#define BOOK_ANIMATION_SETUP
#define W_BOOK 72
#define H_BOOK 102
#define W_COUNT_A 3
#define H_COUNT_A 3
#define W_COUNT_B 3
#define H_COUNT_B 3
#define LOGO_ANIM_ID @"logo_anim"
#define SET_BOOK_ANIM_ID @"set_book_anim"
#define CHANGE_ORIENTATION_ANIM_ID @"change_orientation_anim"
#define DETAIL_ANIM_ID @"detail_anim"
#define DETAIL_TO_SELECT_ANIM_ID @"detail_to_select_anim"
#define DETAIL_TO_READ_ANIM_ID @"detail_to_anim_anim"
#define READ_TO_SELECT_ANIM_ID @"read_to_select_anim"

@implementation WePublishViewController
@synthesize scrollView = _scrollView;
@synthesize activitiyView = _activitiyView;
@synthesize bookBarButton = _bookBarButton;
@synthesize listBarButton = _listBarButton;
@synthesize buyBarButton = _buyBarButton;
@synthesize refreshBarButton = _refreshBarButton;
@synthesize trashBarButton = _trashBarButton;
@synthesize statusLabel = statusLabel_;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	_tmpDlDic = [[NSMutableDictionary alloc] init];
	_aBgList = [[NSMutableArray alloc] init];
	_bBgList = [[NSMutableArray alloc] init];
	_buttons = [[NSMutableArray alloc] init];
	_windowMode = MODE_NONE;
	_xmlCtrl = [[XMLController alloc] init];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(onLogoEndSelect:) name:LOGO_END_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onDetailDisappearSelect:) name:DETAIL_DISAPPEAR_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onReadToSelect:) name:READ_TO_SELECT_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onDetailToReadSelect:) name:DETAIL_TO_READ_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onListToDetailSelect:) name:LIST_TO_DETAIL_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onParseEndSelect:) name:PARSE_END_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onDLBookSuccessSelect:) name:DLBOOK_SUCCESS_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onDLBookErrorSelect:) name:DLBOOK_ERROR_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onAuthenticationSelect:) name:AUTHENTICATION_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onLoginFinishSelect:) name:LOGIN_FINISH_END_EVENT object:nil];
	[notificationCenter addObserver:self selector:@selector(onBookmarkSaveSelect:) name:BOOKMARK_SAVE_EVENT object:nil];

	[self initDirectory];
	
	LogoViewCtrl *ctrl = [[LogoViewCtrl alloc] initWithNibName:@"LogoView" bundle:nil];
	_logoView = [ctrl retain];
	[self.view addSubview:_logoView.view];
	[ctrl release];
	
	// Bookmarkがあるならロード
	_bookmarkPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], XML_DIRECTORY, BOOKMARK_FILENAME];
	if ([Util isExist:_bookmarkPath]) {
		_bookmarkDic = [[NSMutableDictionary alloc] initWithContentsOfFile:_bookmarkPath];
	}
	else {
		_bookmarkDic = [[NSMutableDictionary alloc] init];
	}
//	NSLog(@"Bookmark path: %@", _bookmarkPath);
	
	[self setMenuBarItems:NO list:NO buy:NO refresh:NO trash:NO];
	[self logoToTop];
}

- (void)initDirectory {
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSString *path;
	
	path = [[NSString alloc] initWithFormat:@"%@/%@", [Util getLocalDocument], XML_DIRECTORY];
	[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	[path release];
	
	path = [[NSString alloc] initWithFormat:@"%@/%@", [Util getLocalDocument], BOOK_DIRECTORY];
	[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	[path release];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
	if (currentPage_ != page) {
		currentPage_ = page;
		[self setImageToBooks];
//		NSLog(@"DidChange page: %d", page);
	}
}

- (void)initBooks {
	
	NSInteger book_count = [_bookCollection count];
	NSInteger i, page, h_line, w_line;
	NSInteger HxW = H_COUNT_A * W_COUNT_A;
	UIButton *btn;
	UIActivityIndicatorView *indicator;
	
	for (i = 0; i < book_count; i++) {
		page = i / HxW;
		w_line = (i % HxW) % W_COUNT_A;
		h_line = (i % HxW) / W_COUNT_A;
		
		btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
		[btn setShowsTouchWhenHighlighted:YES];
		[btn setFrame:CGRectMake(0, 0, W_BOOK, H_BOOK)];
		[btn setTitle:nil forState:UIControlStateNormal];
		[btn setTag:i];
		[btn addTarget:self action:@selector(onBookClick:) forControlEvents:UIControlEventTouchUpInside];
		
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[indicator setTag:BOOK_ACTIVITY_INDICATOR];
		[indicator startAnimating];
		[indicator setFrame:CGRectMake(
									   (btn.frame.size.width / 2) - (indicator.frame.size.width / 2),
									   (btn.frame.size.height / 2) - (indicator.frame.size.height / 2),
									   indicator.frame.size.width,
									   indicator.frame.size.height)
		 ];
		[indicator setHidden:NO];
		[btn addSubview:indicator];
		[indicator release];
		
		[_scrollView addSubview:btn];
		[_buttons addObject:btn];
	}
	
	[self setImageToBooks];
	
}

- (void)setImageToBooks {
	
	NSInteger book_count = [_bookCollection count];
	NSInteger i, page;
	NSInteger HxW = H_COUNT_A * W_COUNT_A;
	UIImage *image;
	NSString *documentDir;
	NSString *image_path;
	UIButton* btn;
	BookInfo *info;
	UIActivityIndicatorView *indicator;
	NSInteger h_line;
	float btnY, offY;
	for (i = 0; i < book_count; i++) {
		page = i / HxW;
		if ([_buttons count] <= i) {
			break;
		}
		
		btn = [_buttons objectAtIndex:i];
		
		if (currentPage_ == page) {
			info = [_bookCollection getAt:i];
			documentDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, info.uuid];
			image_path = [Util makeBookPathFormat:documentDir pageNo:1 extension:BOOK_EXTENSION];
			if (image_path) {
				image = [[UIImage alloc] initWithContentsOfFile:image_path];
				if (image) {
					CGSize imageSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
					imageSize = [Util makeAspectFitCGSize:imageSize target:btn.frame.size];
					h_line = (i % HxW) / W_COUNT_A;
					btnY = 137 * h_line + 65;
					offY = H_BOOK - imageSize.height;
					[btn setBackgroundImage:image forState:UIControlStateNormal];
					[btn setFrame:CGRectMake(btn.frame.origin.x, btnY + (offY / 2), imageSize.width, imageSize.height)];
					[image release];
					
					UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[btn viewWithTag:BOOK_ACTIVITY_INDICATOR];
					if (indicator) {
						[indicator setFrame:CGRectMake(
													   (btn.frame.size.width / 2) - (indicator.frame.size.width / 2),
													   (btn.frame.size.height / 2) - (indicator.frame.size.height / 2),
													   indicator.frame.size.width,
													   indicator.frame.size.height)
						 ];
						[indicator setHidden:YES];
					}
				}		
				[image_path release];
			}
			[documentDir release];
		}
		else {
			CGRect frame = btn.frame;
			btn.imageView.image = nil;
			[btn removeFromSuperview];
			[_buttons removeObject:btn];
			
			btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
			[btn setShowsTouchWhenHighlighted:YES];
			[btn setFrame:frame];
			[btn setTitle:nil forState:UIControlStateNormal];
			[btn setTag:i];
			[btn addTarget:self action:@selector(onBookClick:) forControlEvents:UIControlEventTouchUpInside];
			[_scrollView addSubview:btn];
			[_buttons insertObject:btn atIndex:i];
			indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			[indicator setTag:BOOK_ACTIVITY_INDICATOR];
			[indicator startAnimating];
			[indicator setFrame:CGRectMake(
										   (btn.frame.size.width / 2) - (indicator.frame.size.width / 2),
										   (btn.frame.size.height / 2) - (indicator.frame.size.height / 2),
										   indicator.frame.size.width,
										   indicator.frame.size.height)
			 ];
			[indicator setHidden:NO];
			[btn addSubview:indicator];
			[indicator release];
//			NSLog(@"release image: tag: %d", btn.tag);
		}

	}
}

- (void)initAnimation:(NSString *)animationID duration:(NSTimeInterval)duration {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:animationID context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(onAnimationEnd:finished:context:)];	
}

// Logo画面からTopへ
- (void)logoToTop {
	NSTimer *timer;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.00 * 3
											 target:self
										   selector:@selector(onLogoTimer:)
										   userInfo:nil
											repeats:NO];
}

// Alertを表示する
- (void)showAlert:(NSString *)title message:(NSString *)message btn1:(NSString *)btn1 btn2:(NSString *)btn2 tag:(NSUInteger)tag {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:self
										  cancelButtonTitle:btn1
										  otherButtonTitles:btn2, nil];
	[alert setTag:tag];
	[alert show];
	[alert release];
}

// 全てのデータを削除する
- (void)trashAllData {
	[self setMenuBarItems:NO list:NO buy:NO refresh:NO trash:NO];
	[self releaseBooks:NO];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *path = [[NSString alloc] initWithFormat:@"%@/%@", [Util getLocalDocument], XML_DIRECTORY];
	[fm removeItemAtPath:path error:nil];
	[path release];
	
	[self initDirectory];
	[self showAlert:nil message:RELOAD_DATA_WARNING_MESSAGE btn1:@"OK" btn2:nil tag:RELOAD_DATA_ALERT_TAG];
}

- (void)updateXML:(BOOL)checlToServer{
	_updating = YES;
	[self networkActivityIndicator:NO];
	[_activitiyView setHidden:NO];
	[statusLabel_ setHidden:NO];
	[statusLabel_ setText:STATUS_START_TO_UPDATE];

	[_xmlCtrl update:UPDATE_URL checlToServer:checlToServer];
}

// XMLの更新終了
- (void)updateXMLFinish {
	[self reloadBooks];
	[self setMenuBarItems:NO list:YES buy:YES refresh:YES trash:YES];
	
	[self networkActivityIndicator:YES];
	[_activitiyView setHidden:YES];
	[statusLabel_ setHidden:YES];
	_updating = NO;
}

- (BOOL)startToDownloadBookFromQueue {
	
	if ([_tmpDlDic count] > 0) {
		
		BookInfo *info;
		for (id key in _tmpDlDic) {
			updateTotalDownloadCount_++;
			[statusLabel_ setText:[NSString stringWithFormat:@"%@ %3d / %3d 冊", STATUS_DOWNLOADING_BOOKS, updateTotalDownloadCount_, updateRequestFileCount_]];
			info = [_tmpDlDic objectForKey:key];
			FileDownloader *fd = [[FileDownloader alloc] init];
			[fd download:info.uuid url:info.url];
			[fd release];
			
			// 一冊ずつDL
			break;
		}
	}
	
	else {
		return NO;
	}
	
	return YES;
}

- (void)setBooks:(BOOL)animation {

	_scrollView.contentOffset = CGPointMake(0, 0);
	
#ifdef BOOK_ANIMATION_SETUP
	if (animation == YES)
		[self initAnimation:SET_BOOK_ANIM_ID duration:0.2f];
#endif
	
	NSInteger page, h_line, w_line;
	NSInteger W_MARGIN_A = (WINDOW_AW - W_COUNT_A * W_BOOK) / (W_COUNT_A + 1);
	NSInteger HxW_A = H_COUNT_A * W_COUNT_A;
	NSInteger HxW_B = H_COUNT_B * W_COUNT_B;
	NSInteger i = 0;
	float offY;
	for (UIButton *btn in _buttons) {
		CGRect frame = btn.frame;
		if (_windowMode == MODE_A) {
			page = i / HxW_A;
			w_line = (i % HxW_A) % W_COUNT_A;
			h_line = (i % HxW_A) / W_COUNT_A;
			offY = H_BOOK - frame.size.height;
			frame.origin.x = (W_MARGIN_A + W_BOOK) * w_line + W_MARGIN_A + page * WINDOW_AW;
			frame.origin.y = 137 * h_line + 65 + (offY / 2);
//			NSLog(@"setImageToBooks %f", btn.frame.origin.y);
		}
		else {
			page = i / HxW_B;
			w_line = (i % HxW_B) % W_COUNT_B;
			h_line = (i % HxW_B) / W_COUNT_B;
			frame.origin.x = 190 * w_line + 60 + page * WINDOW_BW;
			frame.origin.y = 234 * h_line + 74;
		}
		
		btn.frame = frame;
		i++;
	}
	
	
#ifdef BOOK_ANIMATION_SETUP
	if (animation == YES)
		[UIView commitAnimations];
#endif

}

- (void)releaseBackground:(NSInteger)windowModeType {
	NSMutableArray *targetList = (windowModeType = MODE_A) ? _aBgList : _bBgList;
	
	if (targetList) {
		for (UIImageView *v in targetList) {
			v.image = nil;
			[v removeFromSuperview];
		}
		[targetList removeAllObjects];
	}
}

- (void)releaseBooks:(BOOL)scrollHidden {
	for (UIButton *button in _buttons) {
		button.imageView.image = nil;
		[button removeFromSuperview];
	}
	[_buttons removeAllObjects];
	
	_scrollView.hidden = scrollHidden;
	_scrollView.scrollEnabled = NO;
}

- (void)changeOrientation:(BOOL)animation {

	NSInteger pageCount = 1;
	NSInteger i;
	UIImageView *imageView;
	NSString *path;
	UIImage *image;
	CGRect frame;
	
	if (_windowMode == MODE_A) {
		pageCount = [_bookCollection count] / (H_COUNT_A * W_COUNT_A) + 1;
	}
	else {
		pageCount = [_bookCollection count] / (H_COUNT_B * W_COUNT_B) + 1;
	}

	[self releaseBackground:_windowMode];
	for (i = 0; i < pageCount; i++) {
		imageView = [[UIImageView alloc] init];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		frame = imageView.frame;
		
		if (_windowMode == MODE_A) {
			[_aBgList addObject:imageView];
			path = [[NSBundle mainBundle] pathForResource:@"bk_a" ofType:@"png"];
			frame.size.width = WINDOW_AW;
			frame.size.height = WINDOW_AH;
			frame.origin.x = WINDOW_AW * i;
		}
		else {
			[_bBgList addObject:imageView];
			path = [[NSBundle mainBundle] pathForResource:@"bk_b" ofType:@"png"];
			frame.size.width = WINDOW_BW;
			frame.size.height = WINDOW_BH;
			frame.origin.x = WINDOW_BW * i;
		}
		
		image = [[UIImage alloc] initWithContentsOfFile:path];
		imageView.image = image;
		imageView.alpha = 0;
		imageView.frame = frame;
		[_scrollView insertSubview:imageView atIndex:0];
		[image release];
	}
	
	frame = _scrollView.frame;
	frame.size.width = WINDOW_BW;
	frame.size.height = WINDOW_AH;
	_scrollView.frame = frame;
	
	if (animation == YES)
		[self initAnimation:CHANGE_ORIENTATION_ANIM_ID duration:0.2f];
	
	frame = _scrollView.frame;
	if (_windowMode == MODE_A) {
		frame.size.width = WINDOW_AW;
		frame.size.height = WINDOW_AH;
		_scrollView.contentSize = CGSizeMake(WINDOW_AW * pageCount, WINDOW_AH);
		for (UIImageView *v in _aBgList) {
			v.alpha = 1;
		}
		for (UIImageView *v in _bBgList) {
			v.alpha = 0;
		}
	}
	else {
		frame.size.width = WINDOW_BW;
		frame.size.height = WINDOW_BH;
		_scrollView.contentSize = CGSizeMake(WINDOW_BW * pageCount, WINDOW_BH);
		for (UIImageView *v in _bBgList) {
			v.alpha = 1;
		}
		for (UIImageView *v in _aBgList) {
			v.alpha = 0;
		}
	}
	frame.origin.x = 0;
	frame.origin.y = 0;
	_scrollView.frame = frame;
	
#ifdef BOOK_ANIMATION_SETUP
	for (UIButton *btn in _buttons) {
		CGRect frame = btn.frame;
		if (_windowMode == MODE_A) {
			frame.origin.x = 42;
			frame.origin.y = 112;
		}
		else {
			frame.origin.x = 52;
			frame.origin.y = 106;
		}
		
		btn.frame = frame;
	}
#endif	
	
	if (animation == YES) {
		[UIView commitAnimations];
	} else {
		currentPage_ = 0;
		[self setImageToBooks];
		[self setBooks:NO];
	}

}

- (void)reloadBooks {
	[self initBooks];
	[self changeOrientation:NO];
	_scrollView.hidden = NO;
	_scrollView.scrollEnabled = YES;
}

- (void)setMenuBarItems:(BOOL)book list:(BOOL)list buy:(BOOL)buy refresh:(BOOL)refresh trash:(BOOL)trash{
	
	self.bookBarButton.style = (book == YES) ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
	self.bookBarButton.enabled = book;
	
	self.listBarButton.style = (list == YES) ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
	self.listBarButton.enabled = list;
	
	self.buyBarButton.style = (buy == YES) ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
	self.buyBarButton.enabled = buy;
	
	self.refreshBarButton.style = (refresh == YES) ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
	self.refreshBarButton.enabled = refresh;
	
	self.trashBarButton.style = (trash == YES) ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
	self.trashBarButton.enabled = trash;
}

// 詳細の表示
- (void)showDetail:(NSInteger)bookIndex {
	DetailViewCtrl *ctrl;
	if (_windowMode == MODE_A)
		ctrl = [[DetailViewCtrl alloc] initWithNibName:@"DetailViewA" bundle:nil];
	else
		ctrl = [[DetailViewCtrl alloc] initWithNibName:@"DetailViewB" bundle:nil];
	
	_detailViewCtrl = [ctrl retain];
	[_detailViewCtrl.view setAlpha:0];
	
	BookInfo *info = [_bookCollection getAt:bookIndex];
	NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, info.uuid];
	NSString *image_path = [Util makeBookPathFormat:documentDir pageNo:1 extension:BOOK_EXTENSION];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
//	NSLog(@"author: %@ title: %@ review: %@ path: %@", info.author, info.title, info.review, image_path);
	if (image) {
		_detailViewCtrl.frontImage.image = image;
		_detailViewCtrl.titleText.text = [info.title retain];
		_detailViewCtrl.authorText.text = [info.author retain];
		_detailViewCtrl.reviewView.text = [info.review retain];
		[image release];
	}
	[image_path release];
	[documentDir release];
	[self.view addSubview:_detailViewCtrl.view];
	[ctrl release];
	
	[self initAnimation:nil duration:0.15f];
	[_detailViewCtrl.view setAlpha:1];
	[UIView commitAnimations];
}

// 本の表示
- (void)showBook:(NSUInteger)bookIndex selectPage:(NSUInteger)selectPage {
	BookInfo *info = [_bookCollection getAt:bookIndex];

	// Create length info of the selected book.
	NSString *bookDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, info.uuid];
	NSArray *files = [[NSFileManager defaultManager] directoryContentsAtPath:bookDir];
	[info setLength:[files count]];
	[bookDir release];
	
	ReadViewCtrl *ctrl = [[ReadViewCtrl alloc] initWithNibName:@"ReadView" bundle:nil];
	_readViewCtrl = [ctrl retain];
	[_readViewCtrl setup:info.uuid selectPage:selectPage pageNum:info.length fakePage:info.fake direction:info.direction windowMode:_windowMode];
	[self.view insertSubview:_readViewCtrl.view belowSubview:_detailViewCtrl.view];
	
	[self initAnimation:DETAIL_TO_READ_ANIM_ID duration:0.5f];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	
	[_readViewCtrl.view setAlpha:0];
	[_detailViewCtrl.view setAlpha:1];
	[_detailViewCtrl viewWillDisappear:YES];
	[_readViewCtrl.view setAlpha:1];
	[_detailViewCtrl.view setAlpha:0];
	[_detailViewCtrl viewDidDisappear:YES];
	[UIView commitAnimations];
	
	[ctrl release];
}

- (void)releaseListView {
	if (_listViewCtrl != nil) {
		[_listViewCtrl.view removeFromSuperview];
		[_listViewCtrl release];
		_listViewCtrl = nil;
	}
}

- (void)releaseBuyView {
	if (_buyViewCtrl != nil) {
		[_buyViewCtrl.view removeFromSuperview];
		[_buyViewCtrl release];
		_buyViewCtrl = nil;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	NSInteger requireMode;
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		requireMode = MODE_A;
	}
	else {
//		requireMode = MODE_B;
		return NO;
	}
	
	if (requireMode != _windowMode)
	{
		_windowMode = requireMode;
		[self changeOrientation:YES];
		
		if (_readViewCtrl != nil)
			[_readViewCtrl shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
    return YES;
}

- (void)releaseXML {
	if (_xmlCtrl) {
		[_xmlCtrl release];
		_xmlCtrl = nil;
	}
}

- (void)networkActivityIndicator:(BOOL)hidden {
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = !hidden;
}

-(void)onAnimationEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if ([animationID isEqualToString:LOGO_ANIM_ID]) {
		[_logoView.view removeFromSuperview];
		[_logoView release];
		
		[self updateXML:NO];
	}
	
	else if ([animationID isEqualToString:CHANGE_ORIENTATION_ANIM_ID]) {
		if (_windowMode == MODE_A) {
			[self releaseBackground:MODE_B];
		}
		else {
			[self releaseBackground:MODE_A];
		}
		
		[self setBooks:YES];
	}

	else if ([animationID isEqualToString:SET_BOOK_ANIM_ID]) {
	}
	
	else if ([animationID isEqualToString:DETAIL_TO_SELECT_ANIM_ID] || [animationID isEqualToString:DETAIL_TO_READ_ANIM_ID]) {
		[_detailViewCtrl.view removeFromSuperview];
		[_detailViewCtrl release];
		_detailViewCtrl = nil;
	}
	
	else if ([animationID isEqualToString:READ_TO_SELECT_ANIM_ID]) {
		[_readViewCtrl.view removeFromSuperview];
		[_readViewCtrl release];
		_readViewCtrl = nil;
	}
}

// Logo終了タイマー
- (void)onLogoTimer:(NSTimer*)timer {
	[_logoView requestEnd];
}

// Parseが完了したら
- (void)onParseEndSelect:(NSNotification *)notification {
	NSNumber *checkToServerNum = [[notification userInfo] objectForKey:@"CHECK_TO_SERVER"];
	BookCollection *collection = (BookCollection *)[[notification userInfo] objectForKey:@"BOOK_COLLECTION"];
	if ([checkToServerNum boolValue]) {
		BookInfo *info;
		NSString *bookDir;
		NSFileManager *fm = [NSFileManager defaultManager];
		
		NSInteger length = [collection count];
		updateRequestFileCount_ = 0;
		updateTotalDownloadCount_ = 0;
		for (NSInteger i = 0; i < length; i++) {
			info = [collection getAt:i];
	//		NSLog(@"uuid: %@ download: %@ url: %@ md5: %@ category: %@ title: %@ author: %@ length: %d direction: %d review: %@",
	//			  info.uuid,
	//			  info.download,
	//			  info.url,
	//			  info.md5,
	//			  info.category,
	//			  info.title,
	//			  info.author,
	//			  info.length,
	//			  info.direction,
	//			  info.review
	//			  );

			bookDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, info.uuid];
	//		NSLog(@"bookDir: %@", bookDir);
			if ([fm fileExistsAtPath:bookDir]) {
				if (info.oldVersion) {
					// ここで削除
					[fm removeItemAtPath:bookDir error:nil];
					
					// ここはDLしたいinfoを追加
					[_tmpDlDic setValue:info forKey:info.uuid];
					updateRequestFileCount_++;
				}
			}
			else {
				// ここはDLしたいinfoを追加
				[_tmpDlDic setValue:info forKey:info.uuid];
				updateRequestFileCount_++;
			}
			[bookDir release];
		}
	}
	else {
		NSLog(@"skip to check server.");
	}

	
	_bookCollection = [collection retain];
	[self networkActivityIndicator:NO];
	[_activitiyView setHidden:NO];
	[statusLabel_ setHidden:NO];
	
	// List has no books.
	if (![self startToDownloadBookFromQueue]) {
		[self updateXMLFinish];
	}
}

// 本のDLが完了した時のEvent
- (void)onDLBookSuccessSelect:(NSNotification *)notification {
	
	FileDownloader *fd = (FileDownloader *)[notification object];
	NSString *zipPath = [fd path];
	NSString *outDir = [fd pathWithoutExtension];
	NSString *tmpDir = [[NSString alloc] initWithFormat:@"%@_tmp", [fd pathWithoutExtension]];
	
	ZipArchive* za = [[ZipArchive alloc] init];
	if([za UnzipOpenFile:zipPath]) {
		BOOL ret = [za UnzipFileTo:tmpDir overWrite:YES];
		if(NO == ret) {
			NSLog(@"unzip error");
		}
		[za UnzipCloseFile];
	}
	[za release];
	
	NSArray *files;
	NSFileManager *fm = [NSFileManager defaultManager];
	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpDir error:nil];
	if ([files count] > 0) {
		NSString *srcDir = [[NSString alloc] initWithFormat:@"%@/%@", tmpDir, [files objectAtIndex:0]];
//		NSLog(@"srcDir: %@ outDir: %@", srcDir, outDir);
		NSDictionary *attribs = [fm attributesOfItemAtPath:srcDir error:nil];
		if ([attribs objectForKey:NSFileType] == NSFileTypeDirectory) {
			[fm moveItemAtPath:srcDir toPath:outDir error:nil];
			[fm removeItemAtPath:tmpDir error:nil];
		}

		// Rename tmp directory if doesn't exist inner directory.
		else {
			[fm moveItemAtPath:tmpDir toPath:outDir error:nil];
		}
		[srcDir release];
	}
	
	// Remove the zip file.
	[fm removeItemAtPath:zipPath error:nil];
	zipPath = nil;
	
	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:outDir error:nil];
	NSUInteger count = 1;
	NSString *srcName;
	NSString *outName;
	for (NSString *file in files) {
		srcName = [[NSString alloc] initWithFormat:@"%@/%@", outDir, file];
		outName = [Util makeBookPathFormat:outDir pageNo:count extension:@"jpg"];
//		NSLog(@"srcName: %@ outName: %@", srcName, outName);
		[fm moveItemAtPath:srcName toPath:outName error:nil];
		[srcName release];
		[outName release];
		
		count++;
	}
	outDir = nil;
	
	[tmpDir release];
	[_tmpDlDic removeObjectForKey:[fd uuid]];
	
	// List has no books.
	if (![self startToDownloadBookFromQueue]) {
		if (_updating)
			[self updateXMLFinish];
	}
}

// 本のDLが失敗した時のEvent
- (void)onDLBookErrorSelect:(NSNotification *)notification {
	FileDownloader *fd = (FileDownloader *)[notification object];
	[_tmpDlDic removeObjectForKey:[fd uuid]];
	
	// List has no books.
	if (![self startToDownloadBookFromQueue]) {
		if (_updating)
			[self updateXMLFinish];
	}
}

// Login開始
- (void)onAuthenticationSelect:(NSNotification *)notification {
	LoginViewCtrl *ctrl = [[LoginViewCtrl alloc] initWithNibName:@"LoginView" bundle:nil];
	[self presentModalViewController:ctrl animated:YES];
	[ctrl release];
}

// Login終了
- (void)onLoginFinishSelect:(NSNotification *)notification {
	[self dismissModalViewControllerAnimated:YES];
}

// しおりの保存
- (void)onBookmarkSaveSelect:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	[_bookmarkDic setObject:[userInfo objectForKey:BOOKMARK_PAGE] forKey:[userInfo objectForKey:BOOKMARK_UUID]];
	[_bookmarkDic writeToFile:_bookmarkPath atomically:NO];
}

// 本が選択されて詳細画面が表示
- (void)onBookClick:(UIButton*)sender {
	
	_selectBookIndex = [sender tag];
	[self showDetail:_selectBookIndex];
}

// Logoアニメーション終了
- (void)onLogoEndSelect:(NSNotification *)notification {
	[self initAnimation:LOGO_ANIM_ID duration:0.25f];
	[_logoView.view setAlpha:0.0f];
	[UIView commitAnimations];	
}

// 詳細画面を消すアニメーション
- (void)onDetailDisappearSelect:(NSNotification *)notification {

	[self initAnimation:DETAIL_TO_SELECT_ANIM_ID duration:0.5f];
	[_detailViewCtrl.view setAlpha:0];
	CGRect frame = _detailViewCtrl.view.frame;
	frame.size.width = 0;
	frame.size.height = 0;
	if (_windowMode == MODE_A) {
		frame.origin.x = WINDOW_AW / 2;
		frame.origin.y = WINDOW_AH / 2;
	} else {
		frame.origin.x = WINDOW_BW / 2;
		frame.origin.y = WINDOW_BH / 2;
	}

	_detailViewCtrl.view.frame = frame;
	[UIView commitAnimations];
}

// 本画面から選択画面
- (void)onReadToSelect:(NSNotification *)notification {
	
	[self reloadBooks];

	[self initAnimation:READ_TO_SELECT_ANIM_ID duration:0.5f];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[_readViewCtrl.view setAlpha:1];
	[_readViewCtrl viewWillDisappear:YES];
	[_readViewCtrl.view setAlpha:0];
	[_readViewCtrl viewDidDisappear:YES];
	[UIView commitAnimations];
}

// 詳細画面から読む画面
- (void)onDetailToReadSelect:(NSNotification *)notification {
	
	[self setMenuBarItems:NO list:YES buy:YES refresh:YES trash:YES];
	[self releaseListView];
	[self releaseBackground:_windowMode];
	[self releaseBooks:YES];
	
	
	BookInfo *info = [_bookCollection getAt:_selectBookIndex];
	// ここでブックマークチェック
	NSString* _savedPage = [_bookmarkDic objectForKey:info.uuid];
	if(_savedPage) {
		_bookmarkPage = [_savedPage intValue];
		NSLog(@"saved page: %d", _bookmarkPage);
		[self showAlert:nil message:BOOKMARK_MESSAGE btn1:@"NO" btn2:@"YES" tag:BOOKMARK_ALERT_TAG];
	}
	
	else {
		[self showBook:_selectBookIndex selectPage:1];
	}
}

// 一覧画面から詳細画面
- (void)onListToDetailSelect:(NSNotification *)notification {
	NSNumber *number = (NSNumber *)[notification object];
	NSInteger bookIndex = [number intValue];
	_selectBookIndex = bookIndex;
	[self showDetail:bookIndex];
}

// メニュのブックボタンが押された場合
- (IBAction)onMenuBookClick:(id)sender {
	
	// buy viewからきた場合はリロードしておく？
	if (_buyViewCtrl) {
		
	}
	[self releaseBuyView];
	[self releaseListView];
	[self reloadBooks];
	[self setMenuBarItems:NO list:YES buy:YES refresh:YES trash:YES];
}

// 一覧ボタンが選択された時
- (IBAction)onMenuListClick:(id)sender {
	[self releaseBackground:_windowMode];
	[self releaseBooks:YES];
	
	ListViewCtrl *ctrl;
	if (_windowMode == MODE_A)
		ctrl = [[ListViewCtrl alloc] initWithNibName:@"ListViewA" bundle:nil];
	else
		ctrl = [[ListViewCtrl alloc] initWithNibName:@"ListViewB" bundle:nil];
	_listViewCtrl = [ctrl retain];
	[_listViewCtrl setBookCollection:_bookCollection];
	[self.view insertSubview:ctrl.view atIndex:0];
	[ctrl release];
	[self setMenuBarItems:YES list:NO buy:NO refresh:NO trash:NO];
}

// 購入ボタンが選択されたとき
- (IBAction)onMenuBuyClick:(id)sender {
	if (USE_WEBKIT) {
		[self releaseBackground:_windowMode];
		[self releaseBooks:YES];
		
		BuyViewCtrl *ctrl;
		if (_windowMode == MODE_A)
			ctrl = [[BuyViewCtrl alloc] initWithNibName:@"BuyViewA" bundle:nil];
		else
			ctrl = [[BuyViewCtrl alloc] initWithNibName:@"BuyViewB" bundle:nil];
		_buyViewCtrl = [ctrl retain];
		[self.view insertSubview:ctrl.view atIndex:0];
		[ctrl release];
		[self setMenuBarItems:YES list:NO buy:NO refresh:NO trash:NO];
	}
	
	else {
		NSURL *url = [[NSURL alloc] initWithString:TOP_URL];
		UIApplication *app = [UIApplication sharedApplication];
		[app openURL:url];
		[url release];
	}
}

// 更新ボタンが選択されたとき
- (IBAction)onMenuRefreshClick:(id)sender {
	[self setMenuBarItems:NO list:NO buy:NO refresh:NO trash:NO];
	[self releaseBooks:NO];
	[self updateXML:YES];
}

// 削除ボタンが選択されたとき
- (IBAction)onMenuTrashClick:(id)sender {
	[self showAlert:WARNING_TITLE message:TRASH_WARNING_MESSAGE btn1:@"OK" btn2:@"Cancel" tag:TRASH_ALERT_TAG];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	// Trash alert
	if ([alertView tag] == TRASH_ALERT_TAG) {
		
		// Trash
		if (buttonIndex == 0) {
			[self trashAllData];
		}
	}
	
	else if ([alertView tag] == RELOAD_DATA_ALERT_TAG) {
		if (buttonIndex == 0) {
//		if (buttonIndex == 1) {
			[self updateXML:YES];
		}
	}
	
	else if ([alertView tag] == BOOKMARK_ALERT_TAG) {
		[self showBook:_selectBookIndex selectPage:((buttonIndex == 1) ? _bookmarkPage : 1)];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[self releaseXML];
	[self releaseListView];
	[self releaseBuyView];
	[_bookmarkPath release];
	[_bookmarkDic release];
	[_tmpDlDic release];
	[_aBgList release];
	[_bBgList release];
	[_buttons release];
	[_bookCollection release];
	[self.bookBarButton release];
	[self.listBarButton release];
	[self.buyBarButton release];
	[self.refreshBarButton release];
	[self.trashBarButton release];
	[self.scrollView release];
	[self.activitiyView release];
	[self.statusLabel release];
    [super dealloc];
}

@end
