//
//  MasterViewController.m
//  TimeZonesSample
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController

- (void)loadView {
	[super loadView];
	
	self.title = NSLocalizedString(@"Time Zones Sample", nil);
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	
	selectionLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
	selectionLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	selectionLabel.backgroundColor = [UIColor clearColor];
	selectionLabel.numberOfLines = 0;
	selectionLabel.textAlignment = NSTextAlignmentCenter;
	selectionLabel.textColor = [UIColor blackColor];
	selectionLabel.text = NSLocalizedString(@"<none>", nil);
	[self.view addSubview:selectionLabel];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed)];
	self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)searchButtonPressed {
	LTZSearchController *searchController = [[LTZSearchController alloc] init];
	searchController.delegate = self;
	[self.navigationController pushViewController:searchController animated:YES];
}

#pragma mark - LTZSearchDelegate

- (void)searchDidSelectLocation:(LTZLocation *)location {
	[self.navigationController popViewControllerAnimated:YES];
	selectionLabel.text = [NSString stringWithFormat:@"%@\n%@ (%@)", location.name, location.timeZone.name, location.timeZone.abbreviation];
}

@end
