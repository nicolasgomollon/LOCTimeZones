//
//  LTZLocation.h
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTZLocation : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) NSString *stateAbbreviation;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSTimeZone *timeZone;

@end
