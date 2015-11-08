//
//  LTZSearchController.m
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "LTZSearchController.h"
#import "LTZTimeZones.h"

@implementation LTZSearchController

- (void)loadView {
	[super loadView];
	
	self.title = NSLocalizedString(@"Time Zone", nil);
	self.view.backgroundColor = [UIColor whiteColor];
	
	searchBar = [[UIView alloc] initWithFrame:CGRectZero];
	searchBar.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
	searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:searchBar];
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][searchBar(44.0)]"
																	  options:0
																	  metrics:nil
																		views:@{@"topLayoutGuide": self.topLayoutGuide, @"searchBar": searchBar}]];
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|"
																	  options:0
																	  metrics:nil
																		views:@{@"searchBar": searchBar}]];
	
	searchBarHighlight = [[UIView alloc] initWithFrame:CGRectZero];
	searchBarHighlight.backgroundColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
	searchBarHighlight.translatesAutoresizingMaskIntoConstraints = NO;
	[searchBar addSubview:searchBarHighlight];
	
	[searchBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[highlight(0.5)]|"
																	  options:0
																	  metrics:nil
																		views:@{@"highlight": searchBarHighlight}]];
	
	[searchBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[highlight]|"
																	  options:0
																	  metrics:nil
																		views:@{@"highlight": searchBarHighlight}]];
	
	searchField = [[UITextField alloc] initWithFrame:CGRectZero];
	searchField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	searchField.autocorrectionType = UITextAutocorrectionTypeNo;
	searchField.borderStyle = UITextBorderStyleRoundedRect;
	searchField.clearButtonMode = UITextFieldViewModeAlways;
	searchField.delegate = self;
	searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
	searchField.keyboardType = UIKeyboardTypeDefault;
	searchField.placeholder = NSLocalizedString(@"Enter a city name", nil);
	searchField.returnKeyType = UIReturnKeySearch;
	searchField.translatesAutoresizingMaskIntoConstraints = NO;
	[searchBar addSubview:searchField];
	
	[searchBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[searchField]-|"
																	  options:0
																	  metrics:nil
																		views:@{@"searchField": searchField}]];
	
	[searchBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[searchField]-|"
																	  options:0
																	  metrics:nil
																		views:@{@"searchField": searchField}]];
	
	tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:tableView];
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBar][tableView][bottomLayoutGuide]"
																	  options:0
																	  metrics:nil
																		views:@{@"searchBar": searchBar, @"tableView": tableView, @"bottomLayoutGuide": self.bottomLayoutGuide}]];
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
																	  options:0
																	  metrics:nil
																		views:@{@"tableView": tableView}]];
	
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillChange:)
												 name:UIKeyboardWillChangeFrameNotification
											   object:nil];
	
	[searchField becomeFirstResponder];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
	[self keyboardWillChange:notification];
}

- (void)keyboardWillChange:(NSNotification *)notification {
	CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, keyboardSize.height, 0.0f);
	[UIView animateWithDuration:duration animations:^{
		tableView.contentInset = contentInsets;
		tableView.scrollIndicatorInsets = contentInsets;
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	[UIView animateWithDuration:duration animations:^{
		tableView.contentInset = UIEdgeInsetsZero;
		tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
	}];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
	[searchOperation cancel];
	if (text.length > 0) {
		searchOperation = [LTZTimeZones timeZoneForLocation:text completionHandler:^(NSString *search, NSArray *locations) {
			searchOperation = nil;
			dispatch_async(dispatch_get_main_queue(), ^{
				if (textField.text.length > 0) {
					results = locations;
					[tableView reloadData];
				} else {
					results = nil;
					[tableView reloadData];
				}
			});
		}];
	} else {
		results = nil;
		[tableView reloadData];
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	[searchOperation cancel];
	results = nil;
	[tableView reloadData];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	LTZLocation *location = results[indexPath.row];
	cell.textLabel.text = location.name;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(searchDidSelectLocation:)]) {
		[self.delegate searchDidSelectLocation:results[indexPath.row]];
	}
}

@end
