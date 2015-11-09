//
//  LTZSearchCell.h
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/9/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTZLocation.h"

@interface LTZSearchCell : UITableViewCell {
	NSLayoutConstraint *titleLabelConstraint;
	NSLayoutConstraint *subtitleLabelConstraint;
	NSLayoutConstraint *detailLabelConstraint;
}

@property (nonatomic, strong) LTZLocation *location;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

+ (CGFloat)preferredHeight;

@end
