//
//  DetailViewController.m
//  TimeZonesSample
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	detailDescriptionLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	detailDescriptionLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	detailDescriptionLabel.font = [UIFont systemFontOfSize:17.0f];
	detailDescriptionLabel.textAlignment = NSTextAlignmentCenter;
	detailDescriptionLabel.textColor = [UIColor blackColor];
	[self.view addSubview:detailDescriptionLabel];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
		_detailItem = newDetailItem;
		
		// Update the view.
		[self configureView];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	if (self.detailItem) {
		detailDescriptionLabel.text = [self.detailItem description];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self configureView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
