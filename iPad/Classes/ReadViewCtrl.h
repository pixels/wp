//
//  ReadViewCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/27.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReadViewACtrl;
@class ReadViewBCtrl;

@interface ReadViewCtrl : UIViewController {
	UISlider *_slider;
	UILabel *startLabel_;
	UILabel *endLabel_;
	NSInteger _windowMode;
	NSInteger _direction;
	NSString *_uuid;
	NSInteger _pageNum;
	NSInteger _fakePage;
	NSUInteger _selectPage;
	ReadViewACtrl *_readViewACtrl;
	ReadViewBCtrl *_readViewBCtrl;
}

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;

- (void)setup:(NSString *)uuid selectPage:(NSUInteger)selectPage pageNum:(NSInteger)pageNum fakePage:(NSInteger)fakePage direction:(NSInteger)direction windowMode:(NSInteger)windowMode;
- (void)initAnimation:(NSString *)animationID duration:(NSTimeInterval)duration;
- (void)changeOrientation;
- (void)cleanupCurrentView:(NSInteger)requireMode;
- (void)pageNext;
- (void)pagePrev;
- (void)onUpdateSlider:(UISlider *)aSlider;
- (void)onTouchImage:(NSNotification *)notification;
- (IBAction)onBackClick:(id)sender;
@end
