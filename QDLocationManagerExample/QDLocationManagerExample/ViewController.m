//
//  ViewController.m
//  QDLocationManagerExample
//
//  Created by Nikolay on 15/04/14.
//
//

#import "ViewController.h"
#import "QDLocationManager.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocation *firstLoc;

@property (weak, nonatomic) IBOutlet UILabel *fiftyMetersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenMetersLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLocationLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[QDLocationManager sharedManager] addListener:self forDistance:1.0 resultBlock:^(CLLocation *location) {
        _firstLoc = [location copy];
        
        [_firstLocationLabel setText:[NSString stringWithFormat:@"%0.2f %0.2f", _firstLoc.coordinate.latitude, _firstLoc.coordinate.longitude]];
        
        [self labelsSetup];
        
        [[QDLocationManager sharedManager] removeListener:self forDistance:1.0];
    }];
}

- (void)labelsSetup{
    [[QDLocationManager sharedManager] addListener:self forDistance:10 resultBlock:^(CLLocation *location) {
        [_tenMetersLabel setText:[NSString stringWithFormat:@"%f", [_firstLoc distanceFromLocation:location]]];
    }];
    
    [[QDLocationManager sharedManager] addListener:self forDistance:50 resultBlock:^(CLLocation *location) {
        [_fiftyMetersLabel setText:[NSString stringWithFormat:@"%f", [_firstLoc distanceFromLocation:location]]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
