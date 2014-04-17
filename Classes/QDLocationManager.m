//
//  QDLocationManager.m
//  QDLocationManager
//
//  Created by Nikolay on 17/04/14.
//
//

#import "QDLocationManager.h"

#define kQDLocationManagerMinDistance 1.0

@interface QDLocationManagerListenerWrapper : NSObject

@property (nonatomic, strong) id listener;
@property (nonatomic, assign) double distance;
@property (nonatomic, strong) CLLocation *lastUpdatedLocation;
@property (nonatomic, strong) QDLocationManagerResultBlock resultBlock;

- (instancetype)initWithListner:(id)listener distance:(double)distance resultBlock:(QDLocationManagerResultBlock)resultBlock;
- (void)updateLocationIfNeeded:(CLLocation*)location;

@end

@implementation QDLocationManagerListenerWrapper

- (instancetype)initWithListner:(id)listener distance:(double)distance resultBlock:(QDLocationManagerResultBlock)resultBlock{
    self = [super init];
    if (self) {
        self.listener = listener;
        self.distance = distance;
        self.resultBlock = resultBlock;
    }
    return self;
}

- (void)updateLocationIfNeeded:(CLLocation*)location{
    if (_distance < [_lastUpdatedLocation distanceFromLocation:location] || !_lastUpdatedLocation) {
        _lastUpdatedLocation = [location copy];
        _resultBlock(location);
    }
}

@end


@interface QDLocationManager () <CLLocationManagerDelegate>

@end

@implementation QDLocationManager {
    CLLocationManager *locationManager;
    
	NSMutableArray *listenerWrappers;
}

+ (instancetype) sharedManager {
    static QDLocationManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[QDLocationManager alloc] init];
    });
    return instance;
}

- (instancetype) init {
	self = [super init];
    if (self) {
    	listenerWrappers = [NSMutableArray array];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager setActivityType:CLActivityTypeFitness];
        
        [self checkLocationAccuracy];
    }
    return self;
}

- (void) addListener:(id)listener forDistance:(double)distance resultBlock:(QDLocationManagerResultBlock)resultBlock{
    NSAssert(distance >= kQDLocationManagerMinDistance, @"Invalid distance");
    
    QDLocationManagerListenerWrapper *wrapper = [self getWrapperForListener:listener distance:distance];
    
    if (!wrapper) {
        wrapper = [[QDLocationManagerListenerWrapper alloc] initWithListner:listener distance:distance resultBlock:resultBlock];
        [listenerWrappers addObject:wrapper];
        
        if (listenerWrappers.count == 1) {
            [self startLocationUpdates];
        }
    }else{
        wrapper.distance = distance;
        wrapper.resultBlock = resultBlock;
    }
    
    [self checkLocationAccuracy];
}


- (void) removeListener:(id)listener {
    NSMutableArray *wrappers = [NSMutableArray array];
    
    for (QDLocationManagerListenerWrapper *wrapper in listenerWrappers){
        if (wrapper.listener == listener)
            [wrappers addObject:wrapper];
    }
    
    [self removeWrappers:wrappers];
}

- (void)removeListener:(id)listener forDistance:(double)distance{
    QDLocationManagerListenerWrapper *result = nil;
    
    for (QDLocationManagerListenerWrapper *wrapper in listenerWrappers){
        if (wrapper.listener == listener && wrapper.distance == distance){
            result = wrapper;
            break;
        }
    }
    
    if (result)
        [self removeWrappers:@[result]];
}

- (void)removeWrappers:(NSArray*)wrappers{
    if (wrappers.count > 0) {
        [listenerWrappers removeObjectsInArray:wrappers];
        
        if (listenerWrappers.count == 0) {
            [self stopLocationUpdates];
        }
        
        [self checkLocationAccuracy];
    }
}

- (QDLocationManagerListenerWrapper*)getWrapperForListener:(id)listener distance:(double)distance{
    QDLocationManagerListenerWrapper *result = nil;
    
    for (QDLocationManagerListenerWrapper *wrapper in listenerWrappers) {
        if (wrapper.listener == listener && wrapper.distance == distance) {
            result = wrapper;
            break;
        }
    }
    return result;
}

- (CLAuthorizationStatus)authorizationStatus{
    return [CLLocationManager authorizationStatus];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	_lastUpdatedLocation = [locations lastObject];
    
    for (QDLocationManagerListenerWrapper *wrapper in listenerWrappers)
        [wrapper updateLocationIfNeeded:_lastUpdatedLocation];
}

#pragma mark - Private

- (void) startLocationUpdates {
	[locationManager startUpdatingLocation];
}

- (void) stopLocationUpdates {
	[locationManager stopUpdatingLocation];
}

- (void)checkLocationAccuracy{
    double minDist = MAXFLOAT;
    
    for (QDLocationManagerListenerWrapper *wrapper in listenerWrappers)
        minDist = (wrapper.distance<minDist)?wrapper.distance:minDist;
    
    [locationManager setDesiredAccuracy:minDist];
}

@end

