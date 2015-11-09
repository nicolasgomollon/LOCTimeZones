//
//  LTZSearchCell.m
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/9/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "LTZSearchCell.h"

@implementation LTZSearchCell

@synthesize location, titleLabel, subtitleLabel, detailLabel;

+ (CGFloat)preferredHeight {
	return [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize + [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].pointSize + 15.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleDefault;
		self.isAccessibilityElement = YES;
		self.shouldGroupAccessibilityChildren = YES;
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]"
																				 options:0
																				 metrics:nil
																				   views:@{@"titleLabel": self.titleLabel}]];
		
		titleLabelConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
															attribute:NSLayoutAttributeHeight
															relatedBy:NSLayoutRelationEqual
															   toItem:nil
															attribute:0
														   multiplier:1.0f
															 constant:(self.titleLabel.font.pointSize + 11.0f)];
		
		[self.contentView addConstraint:titleLabelConstraint];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-[detailLabel]-|"
																				 options:0
																				 metrics:nil
																				   views:@{@"titleLabel": self.titleLabel, @"detailLabel": self.detailLabel}]];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subtitleLabel]|"
																				 options:0
																				 metrics:nil
																				   views:@{@"subtitleLabel": self.subtitleLabel}]];
		
		subtitleLabelConstraint = [NSLayoutConstraint constraintWithItem:self.subtitleLabel
															   attribute:NSLayoutAttributeHeight
															   relatedBy:NSLayoutRelationEqual
															   toItem:nil
															   attribute:0
														   multiplier:1.0f
															 constant:(self.subtitleLabel.font.pointSize + 12.0f)];
		
		[self.contentView addConstraint:subtitleLabelConstraint];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[subtitleLabel]-[detailLabel]-|"
																				 options:0
																				 metrics:nil
																				   views:@{@"subtitleLabel": self.subtitleLabel, @"detailLabel": self.detailLabel}]];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailLabel]|"
																				 options:0
																				 metrics:nil
																				   views:@{@"detailLabel": self.detailLabel}]];
		
		detailLabelConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:0
															multiplier:1.0f
															  constant:0.0f];
		
		[self.contentView addConstraint:detailLabelConstraint];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
	self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	
	CGSize detailTextSize = [self.detailLabel.text boundingRectWithSize:self.contentView.frame.size
																options:NSStringDrawingUsesLineFragmentOrigin
															 attributes:@{NSFontAttributeName: self.detailLabel.font}
																context:nil].size;
	
	detailLabelConstraint.constant = ceil(detailTextSize.width);
	titleLabelConstraint.constant = (self.titleLabel.font.pointSize + 11.0f);
	subtitleLabelConstraint.constant = (self.subtitleLabel.font.pointSize + 12.0f);
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.titleLabel.text = nil;
	self.subtitleLabel.text = nil;
	self.detailLabel.text = nil;
}

- (void)setLocation:(LTZLocation *)_location {
	location = _location;
	
	self.titleLabel.text = location.name;
	self.subtitleLabel.text = location.timeZone.name;
	self.detailLabel.text = location.timeZone.abbreviation;
}

- (UILabel *)titleLabel {
	if (!titleLabel) {
		titleLabel = [[UILabel alloc] init];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textAlignment = NSTextAlignmentLeft;
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
		titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:titleLabel];
	}
	return titleLabel;
}

- (UILabel *)subtitleLabel {
	if (!subtitleLabel) {
		subtitleLabel = [[UILabel alloc] init];
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.textAlignment = NSTextAlignmentLeft;
		subtitleLabel.textColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
		subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:subtitleLabel];
	}
	return subtitleLabel;
}

- (UILabel *)detailLabel {
	if (!detailLabel) {
		detailLabel = [[UILabel alloc] init];
		detailLabel.backgroundColor = [UIColor clearColor];
		detailLabel.textAlignment = NSTextAlignmentRight;
		detailLabel.textColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
		detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
		detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:detailLabel];
	}
	return detailLabel;
}

@end
