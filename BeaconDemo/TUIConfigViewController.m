//
//  TUIConfigViewController.m
//  BeaconDemo
//
//  Created by Diego Lafuente Garcia on 08/05/14.
//  Copyright (c) 2014 Diego Lafuente Garcia. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TUIConfigViewController.h"

@interface TUIConfigViewController () <CBPeripheralManagerDelegate>

// User interface
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
// Beacons
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
// Actions
- (IBAction)transmitBeaconClicked:(id)sender;

@end

@implementation TUIConfigViewController

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
    [self initBeacon];
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Labels -

- (void)setLabels {
    _uuidLabel.text = self.beaconRegion.proximityUUID.UUIDString;
    _majorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.major];
    _minorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.minor];
    _identityLabel.text = self.beaconRegion.identifier;
}


#pragma mark - Beacons -

- (void)initBeacon
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:1
                                                                minor:1
                                                           identifier:@"com.tuitravel-ad.rep"];
}


#pragma mark - Actions -

- (IBAction)transmitBeaconClicked:(id)sender
{
    _beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

#pragma mark - PeripheralManagerDelegate methods -

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [_peripheralManager startAdvertising:_beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [_peripheralManager stopAdvertising];
    }
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
