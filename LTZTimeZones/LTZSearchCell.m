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
	return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize + [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].pointSize + 15.0f;
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
		
		titleLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
																  attribute:NSLayoutAttributeHeight
																  relatedBy:NSLayoutRelationEqual
																	 toItem:nil
																  attribute:NSLayoutAttributeNotAnAttribute
																 multiplier:1.0f
																   constant:(self.titleLabel.font.pointSize + 11.0f)];
		
		[self.contentView addConstraint:titleLabelHeightConstraint];
		
		titleLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
																attribute:NSLayoutAttributeLeft
																relatedBy:NSLayoutRelationEqual
																   toItem:self.contentView
																attribute:NSLayoutAttributeLeft
															   multiplier:1.0f
																 constant:0.0f];
		
		[self.contentView addConstraint:titleLabelLeftConstraint];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subtitleLabel]|"
																				 options:0
																				 metrics:nil
																				   views:@{@"subtitleLabel": self.subtitleLabel}]];
		
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
																	 attribute:NSLayoutAttributeLeft
																	 relatedBy:NSLayoutRelationEqual
																		toItem:self.titleLabel
																	 attribute:NSLayoutAttributeLeft
																	multiplier:1.0f
																	  constant:0.0f]];
		
		subtitleLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.subtitleLabel
																	 attribute:NSLayoutAttributeHeight
																	 relatedBy:NSLayoutRelationEqual
																		toItem:nil
																	 attribute:NSLayoutAttributeNotAnAttribute
																	multiplier:1.0f
																	  constant:(self.subtitleLabel.font.pointSize + 12.0f)];
		
		[self.contentView addConstraint:subtitleLabelHeightConstraint];
		
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailLabel]|"
																				 options:0
																				 metrics:nil
																				   views:@{@"detailLabel": self.detailLabel}]];
		
		detailLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
																  attribute:NSLayoutAttributeWidth
																  relatedBy:NSLayoutRelationEqual
																	 toItem:nil
																  attribute:NSLayoutAttributeNotAnAttribute
																 multiplier:1.0f
																   constant:0.0f];
		
		[self.contentView addConstraint:detailLabelWidthConstraint];
		
		detailLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
																  attribute:NSLayoutAttributeRight
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.contentView
																  attribute:NSLayoutAttributeRight
																 multiplier:1.0f
																   constant:0.0f];
		
		[self.contentView addConstraint:detailLabelRightConstraint];
		
		titleLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.detailLabel
																 attribute:NSLayoutAttributeLeft
																multiplier:1.0f
																  constant:0.0f];
		
		[self.contentView addConstraint:titleLabelRightConstraint];
		
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
																	 attribute:NSLayoutAttributeRight
																	 relatedBy:NSLayoutRelationEqual
																		toItem:self.titleLabel
																	 attribute:NSLayoutAttributeRight
																	multiplier:1.0f
																	  constant:0.0f]];
		
		// This is an ugly hack to force `textLabel` to set an x origin in `layoutSubviews`.
		self.textLabel.text = @" ";
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.titleLabel.font = [UIFont systemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize];
	self.subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
	self.detailLabel.font = [UIFont systemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize];
	
	CGSize detailTextSize = [self.detailLabel.text boundingRectWithSize:self.contentView.frame.size
																options:NSStringDrawingUsesLineFragmentOrigin
															 attributes:@{NSFontAttributeName: self.detailLabel.font}
																context:nil].size;
	
	detailLabelWidthConstraint.constant = ceil(detailTextSize.width);
	titleLabelHeightConstraint.constant = (self.titleLabel.font.pointSize + 11.0f);
	subtitleLabelHeightConstraint.constant = (self.subtitleLabel.font.pointSize + 12.0f);
	
	if (self.textLabel.frame.origin.x > 0.0f) {
		titleLabelLeftConstraint.constant = self.textLabel.frame.origin.x;
		titleLabelRightConstraint.constant = -self.textLabel.frame.origin.x;
		detailLabelRightConstraint.constant = -self.textLabel.frame.origin.x;
	}
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
		titleLabel.font = [UIFont systemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize];
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
		detailLabel.font = [UIFont systemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize];
		detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:detailLabel];
	}
	return detailLabel;
}

@end
