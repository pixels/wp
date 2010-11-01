//
//  LoginViewCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/18.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewCtrl : UIViewController {
	UITextField *_nameTI;
	UITextField *_passTI;
	UIButton *_okButton;
	UIButton *_cancelButton;
	UIButton *_newButton;
}

@property (nonatomic, retain) IBOutlet UITextField *nameTI;
@property (nonatomic, retain) IBOutlet UITextField *passTI;
@property (nonatomic, retain) IBOutlet UIButton *okButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *newButton;

- (void)loginFinish;
- (IBAction)onOKButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;
- (IBAction)onNewButton:(id)sender;

@end
