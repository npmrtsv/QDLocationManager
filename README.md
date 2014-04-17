<h2>Installation</h2>

    pod 'QDLocationManager', '~> 0.0.1'
    
    
<h2>How to use</h2>

    [[QDLocationManager sharedManager] addListener:self forDistance:10.0 resultBlock:^(CLLocation *location) {
        //do stuff
    }];

<h2>Licence</h2>

QDLocationManager is available under the MIT license. See the LICENSE file for more info.
