//
//  LTZSearchController.h
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTZLocation.h"

@protocol LTZSearchDelegate <NSObject>

@required
- (void)searchDidSelectLocation:(LTZLocation *)location;

@end

@interface LTZSearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
	UISearchBar *searchBar;
	UITableView *tableView;
	NSOperation *searchOperation;
	NSArray *results;
}

@property (nonatomic, strong) id<LTZSearchDelegate> delegate;

@end
