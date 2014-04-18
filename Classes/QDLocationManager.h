//
//  QDLocationManager.h
//  QDLocationManager
//
//  Created by Nikolay on 17/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^QDLocationManagerResultBlock)(CLLocation *location);

@interface QDLocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocation *lastUpdatedLocation;

+ (instancetype) sharedManager;

- (CLAuthorizationStatus)authorizationStatus;

- (void) addListener:(id)listener forDistance:(double)distance resultBlock:(QDLocationManagerResultBlock)resultBlock;
- (void) removeListener:(id)listener;
- (void) removeListener:(id)listener forDistance:(double)distance;

@end
