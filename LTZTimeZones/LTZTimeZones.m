//
//  LTZTimeZones.m
//  LTZTimeZones
//
//  Created by Nicolas Gomollon on 11/7/15.
//  Copyright (c) 2015 Techno-Magic. All rights reserved.
//

#import "LTZTimeZones.h"

@interface LTZSearchableLocation : LTZLocation

@property (nonatomic, strong) NSString *asciiCity;
@property (nonatomic, strong) NSString *asciiCountry;
@property (nonatomic, strong) NSString *searchable;

@end

@implementation LTZSearchableLocation
@end

@implementation LTZTimeZones

+ (LTZTimeZones *)sharedManager {
	static LTZTimeZones *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		sharedInstance->timeZones = LTZTimeZones.timeZones;
		sharedInstance->searchQueue = [[NSOperationQueue alloc] init];
		sharedInstance->searchQueue.maxConcurrentOperationCount = 1;
		if ([sharedInstance->searchQueue respondsToSelector:@selector(qualityOfService)]) {
			sharedInstance->searchQueue.qualityOfService = NSQualityOfServiceUserInteractive;
		}
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
	NSMutableArray *timeZones = [[NSMutableArray alloc] init];
	for (NSDictionary *loc in [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil]) {
		LTZSearchableLocation *location = [[LTZSearchableLocation alloc] init];
		location.city = loc[@"name"];
		location.state = loc[@"state_name"];
		location.country = loc[@"country_name"];
		location.stateAbbreviation = loc[@"state"];
		location.countryCode = loc[@"country_code"];
		location.timeZone = [NSTimeZone timeZoneWithName:loc[@"timezone"]];
		location.asciiCity = loc[@"asciiname"];
		location.asciiCountry = [loc[@"country_name"] stringByFoldingWithOptions:(NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch | NSCaseInsensitiveSearch)
																		  locale:[NSLocale systemLocale]];
		NSMutableArray *searchableLocArr = [[NSMutableArray alloc] init];
		[searchableLocArr addObject:location.asciiCity];
		if (location.state != nil) {
			[searchableLocArr addObject:location.state];
		}
		[searchableLocArr addObject:location.asciiCountry];
		location.searchable = [searchableLocArr componentsJoinedByString:@", "];
		[timeZones addObject:location];
	}
	[timeZones sortUsingComparator:^NSComparisonResult(LTZLocation *obj1, LTZLocation *obj2) {
		return [obj1.name compare:obj2.name];
	}];
	[inputStream close];
	
	return timeZones;
}

+ (NSOperation *)timeZoneForLocation:(NSString *)search completionHandler:(void (^)(NSString *search, NSArray *locations))completionHandler {
	NSOperation *searchOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSString *asciiSearch = [search stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"Æ" withString:@"AE"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"æ" withString:@"ae"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"Œ" withString:@"OE"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"œ" withString:@"oe"];
		asciiSearch = [asciiSearch stringByReplacingOccurrencesOfString:@"ĳ" withString:@"ij"];
		
		NSString *pattern = [@".*\\b" stringByAppendingString:asciiSearch];
		pattern = [pattern stringByAppendingString:@".*"];
		
		NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"searchable", pattern];
		NSArray *locations = [[LTZTimeZones sharedManager]->timeZones filteredArrayUsingPredicate:locationPredicate];
		
		if (completionHandler != nil) {
			completionHandler(search, locations);
		}
	}];
	[[LTZTimeZones sharedManager]->searchQueue addOperation:searchOperation];
	return searchOperation;
}

@end
