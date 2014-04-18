<h2>Installation</h2>

    pod 'QDLocationManager', '~> 0.0.2'
    
    
<h2>How to use</h2>

Add listener for distance = 10m.

    [[QDLocationManager sharedManager] addListener:self forDistance:10.0 resultBlock:^(CLLocation *location) {
        //do stuff
    }];

Remove listener only for distance = 10m.

    [[QDLocationManager sharedManager] removeListener:self forDistance:10.0];
    
    
Remove listener for all distances.

    [[QDLocationManager sharedManager] removeListener:self];


<h2>Licence</h2>

QDLocationManager is available under the MIT license. See the LICENSE file for more info.
