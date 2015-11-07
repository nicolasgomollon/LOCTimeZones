//
//  LTZTimeZones.h
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTZLocation.h"

@interface LTZTimeZones : NSObject {
	NSArray *timeZones;
}

+ (LTZTimeZones *)sharedManager;
+ (void)timeZoneForLocation:(NSString *)search completionHandler:(void (^)(NSString *search, NSArray *locations))completionHandler;

@end
