//
//  DetailViewController.h
//  TimeZonesSample
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
	UILabel *detailDescriptionLabel;
}

@property (nonatomic, strong) id detailItem;

@end

