//
//  TUITrackViewController.m
//  BeaconDemo
//
//  Created by Diego Lafuente Garcia on 08/05/14.
//  Copyright (c) 2014 Diego Lafuente Garcia. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TUITrackViewController.h"

@interface TUITrackViewController () <CLLocationManagerDelegate>

// User interface
@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
// Beacons
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TUITrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [self initRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Beacons -

- (void)initRegion
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"54fbdbd7-621f-4153-9466-47c86ecf886b"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.tuitravel-ad.kontakt"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


#pragma mark - CLLocationManagerDelegate methods -

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    _beaconFoundLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    //CLBeacon *beacon = [[CLBeacon alloc] init];
    CLBeacon *beacon = [beacons lastObject];
    
    _beaconFoundLabel.text = @"Yes";
    _proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    _majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    _minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    _accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown)
    {
        _distanceLabel.text = @"Unknown Proximity";
    }
    else if (beacon.proximity == CLProximityImmediate)
    {
        _distanceLabel.text = @"Immediate";
    }
    else if (beacon.proximity == CLProximityNear)
    {
        _distanceLabel.text = @"Near";
    }
    else if (beacon.proximity == CLProximityFar)
    {
        _distanceLabel.text = @"Far";
    }
    _rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
