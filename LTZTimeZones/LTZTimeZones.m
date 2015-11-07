//
//  LTZTimeZones.m
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "LTZTimeZones.h"

@implementation LTZTimeZones

+ (LTZTimeZones *)sharedManager {
	static LTZTimeZones *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		sharedInstance->timeZones = LTZTimeZones.timeZones;
	});
	
	return sharedInstance;
}

+ (NSArray *)timeZones {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"timezones" ofType:@"json"];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (!fileExists) {
		return nil;
	}
	
	NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
	
	[inputStream open];
	id timeZones = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
	[inputStream close];
	
	return timeZones;
}

+ (void)timeZoneForLocation:(NSString *)search completionHandler:(void (^)(NSString *search, NSArray *locations))completionHandler {
	[[NSBlockOperation blockOperationWithBlock:^{
		NSString *asciiSearch = [search stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"Æ" withString:@"AE"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"æ" withString:@"ae"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"Œ" withString:@"OE"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"œ" withString:@"oe"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"ĳ" withString:@"ij"];
		asciiSearch = [asciiSearch stringByFoldingWithOptions:(NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch | NSCaseInsensitiveSearch)
													   locale:[NSLocale systemLocale]];
		
		NSString *regexSearch = [@"\\b" stringByAppendingString:asciiSearch];
		
		NSMutableArray *locations = [[NSMutableArray alloc] init];
		for (NSDictionary *loc in [LTZTimeZones sharedManager]->timeZones) {
			NSString *asciiName = loc[@"asciiname"];
			NSString *stateAbbr = loc[@"state"];
			NSString *stateName = loc[@"state_name"];
			NSString *countryName = loc[@"country_name"];
			BOOL match = NO;
			if (asciiSearch.length <= 2) {
				if (stateAbbr != nil) {
					match = ([stateAbbr rangeOfString:regexSearch options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)].location != NSNotFound);
				}
			} else {
				match = ([asciiName rangeOfString:regexSearch options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)].location != NSNotFound);
				if (!match && (stateName != nil)) {
					match = ([stateName rangeOfString:regexSearch options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)].location != NSNotFound);
				}
				if (!match) {
					NSString *asciiCountryName = [countryName stringByFoldingWithOptions:(NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch | NSCaseInsensitiveSearch)
																				  locale:[NSLocale systemLocale]];
					match = ([asciiCountryName rangeOfString:regexSearch options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)].location != NSNotFound);
				}
			}
			if (match) {
				LTZLocation *location = [[LTZLocation alloc] init];
				location.city = loc[@"name"];
				location.state = stateName;
				location.country = countryName;
				location.stateAbbreviation = stateAbbr;
				location.countryCode = loc[@"country_code"];
				location.timeZone = [NSTimeZone timeZoneWithName:loc[@"timezone"]];
				[locations addObject:location];
			}
		}
		
		[locations sortUsingComparator:^NSComparisonResult(LTZLocation *obj1, LTZLocation *obj2) {
			return [obj1.name compare:obj2.name];
		}];
		
		if (completionHandler != nil) {
			completionHandler(search, locations);
		}
	}] start];
}

@end
