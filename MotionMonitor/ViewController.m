//
//  ViewController.m
//  MotionMonitor
//
//  Created by Alex Chekodanov on 09.09.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;

@property (strong, nonatomic) CMMotionManager *motionManager;
//@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSTimer *updateTimer;

@end

@implementation ViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.motionManager = [[CMMotionManager alloc] init];
    //self.queue = [[NSOperationQueue alloc] init];
    if (self.motionManager.accelerometerAvailable)
    {
        self.motionManager.accelerometerUpdateInterval = 1.0 / 10.0;
        /*[self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData *  accelerometerData, NSError * error) {
            NSString *labelText;
            if (error)
            {
                [self.motionManager stopAccelerometerUpdates];
                labelText = [NSString stringWithFormat:@"Accelerometer encountered error: %@", error];
            }
            else
            {
                labelText = [NSString stringWithFormat:@"Accelerometer\n---\n""x: %+.2f\ny: %+.2f\nz: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.accelerometerLabel.text = labelText;
            });
        }];*/
    }
    else
        self.accelerometerLabel.text = @"This device has no accelerometer.";
    
    if (self.motionManager.gyroAvailable)
    {
        self.motionManager.gyroUpdateInterval = 1.0/10.0;
        /*[self.motionManager startGyroUpdatesToQueue:self.queue withHandler:^(CMGyroData * gyroData, NSError * error) {
            NSString *labelText;
            if (error)
            {
                [self.motionManager stopGyroUpdates];
                labelText = [NSString stringWithFormat:@"Gyroscope encountered error: %@", error];
            }
            else
            {
                labelText = [NSString stringWithFormat:@"Gyroscope\n---\n""x: %+.2f\ny: %+.2f\nz: %+.2f",gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.gyroscopeLabel.text = labelText;
            });
        }];*/
    }
    else
        self.gyroscopeLabel.text = @"This device has no gyroscope";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.motionManager startAccelerometerUpdates];
    [self.motionManager startGyroUpdates];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)updateDisplay
{
    if (self.motionManager.accelerometerAvailable)
    {
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        self.accelerometerLabel.text = [NSString stringWithFormat:@"Accelerometer\n---\n""x: %+.2f\ny: %+.2f\nz: %+.2f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
    }
    if (self.motionManager.gyroAvailable)
    {
        CMGyroData *gyroData = self.motionManager.gyroData;
        self.gyroscopeLabel.text = [NSString stringWithFormat:@"Gyroscope\n---\n""x: %+.2f\ny: %+.2f\nz: %+.2f",gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
    }
}

@end
