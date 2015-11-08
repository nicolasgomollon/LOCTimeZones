//
//  MasterViewController.h
//  TimeZonesSample
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTZSearchController.h"

@interface MasterViewController : UIViewController <LTZSearchDelegate> {
	UILabel *selectionLabel;
}

@end
