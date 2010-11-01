//
//  ListViewCtrl.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/03.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortType.h"

@class BookCollection;

@interface ListViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_list;
	UISegmentedControl *_segment;
	BookCollection *_collection;
}

@property (nonatomic, retain) IBOutlet UITableView *list;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;

- (void)setBookCollection:(BookCollection *)collection;
- (void)sort:(SortType)type;
- (IBAction)changed:(id)sender;

@end
