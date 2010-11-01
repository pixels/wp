    //
//  ListViewCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/03.
//  Copyright 2010 3di. All rights reserved.
//

#import "ListViewCtrl.h"
#import "BookCollection.h"
#import "BookInfo.h"
#import "ListCellCtrl.h"
#import "Util.h"
#import "Define.h"

@implementation ListViewCtrl
@synthesize segment = _segment;
@synthesize list = _list;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setBookCollection:(BookCollection *)collection {
	_collection = [collection retain];
	
	[self sort:SORT_TITLE];
}

- (void)sort:(SortType)type {
	[_collection sort:type];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *identifier = @"identifier";
	ListCellCtrl *cell = (ListCellCtrl*)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}

	BookInfo *info = [_collection getAt:[indexPath row]];
	cell.titleLabel.text = info.title;
	cell.authorLabel.text = info.author;
	cell.tag = [indexPath row];
	
	NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@/%@", [Util getLocalDocument], BOOK_DIRECTORY, info.uuid];
	NSString *image_path = [Util makeBookPathFormat:documentDir pageNo:1 extension:BOOK_EXTENSION];
	if (image_path) {
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
		if (image) {
			cell.imageView.image = image;
			[image release];
		}
	}
	[image_path release];
	[documentDir release];
		

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	NSLog(@"myValue:%d", indexPath.row);
	
	NSNumber *number = [NSNumber numberWithInt:indexPath.row];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:LIST_TO_DETAIL_EVENT object:number userInfo:nil];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [_collection count];
}

- (IBAction)changed:(id)sender {
	UISegmentedControl *sc = (UISegmentedControl *)sender;
	NSInteger index = sc.selectedSegmentIndex;
//	NSLog(@"changed index: %d", index);

	[self sort:(SortType)index];
	[_list reloadData];
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
	[_collection release];
	[self.segment release];
	[self.list release];
    [super dealloc];
}


@end
