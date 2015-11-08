# LTZTimeZones

LTZTimeZones is a drop-in time zone selection manager that works completely offline. LTZTimeZones uses location and time zone data gathered from [GeoNames](http://www.geonames.org), along with some modifications.


## Usage

1) Drag-and-drop the `LTZTimeZones` folder into your Xcode project.

2) Initialize a shared instance of `LTZTimeZones`:
```objective-c
#import "LTZTimeZones.h"
```
```objective-c
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
	[LTZTimeZones sharedManager];
});
```

3) Display the `LTZSearchController`:
```objective-c
#import "LTZSearchController.h"
```
```objective-c
LTZSearchController *searchController = [[LTZSearchController alloc] init];
// Don't forget to set the delegate!
searchController.delegate = self;
[self.navigationController pushViewController:searchController animated:YES];
```

4) Implement `LTZSearchDelegate`:
```objective-c
- (void)searchDidSelectLocation:(LTZLocation *)location {
	// Pop the search controller.
	[self.navigationController popViewControllerAnimated:YES];
	// Do something useful with `location`!
	selectionLabel.text = [NSString stringWithFormat:@"%@\n%@ (%@)", location.name, location.timeZone.name, location.timeZone.abbreviation];
}
```

See the TimeZonesSample demo project included in this repository for a working example of the project.


## Requirements

LTZTimeZones works on iOS 7 and above.


## License

LTZTimeZones is released under the MIT License.