//
//  LTZLocation.m
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "LTZLocation.h"

@implementation LTZLocation

- (NSString *)name {
	NSMutableArray *name = [[NSMutableArray alloc] init];
	[name addObject:self.city];
	if (self.state != nil) {
		[name addObject:self.state];
	}
	[name addObject:self.country];
	return [name componentsJoinedByString:@", "];
}

@end
