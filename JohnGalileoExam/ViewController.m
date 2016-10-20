//
//  ViewController.m
//  JohnGalileoExam
//
//  Created by Bogdan on 10/19/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import "ViewController.h"
#import <GalileoControl/GalileoControl.h>

@interface ViewController () <GCGalileoDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self disableUI];
    
    [GCGalileo sharedGalileo].delegate = self;
    [[GCGalileo sharedGalileo] waitForConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Disable/Enable UI...

- (void)disableUI {
    [self.view setUserInteractionEnabled:NO];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)enableUI {
    [self.view setUserInteractionEnabled:YES];
    self.view.backgroundColor = [UIColor greenColor];
}

#pragma mark -
#pragma mark - Button Action Methods...

- (IBAction)onPanClockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisPan] incrementTargetPosition:90.0
                                                                                 completionBlock:completionBlock waitUntilStationary:NO];
}

- (IBAction)onPanAnticlockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisPan] incrementTargetPosition:-90.0
                                                                                 completionBlock:completionBlock
                                                                             waitUntilStationary:NO];
}

- (IBAction)onTiltClockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisTilt] incrementTargetPosition:90
                                                                                  completionBlock:completionBlock
                                                                              waitUntilStationary:NO];
}

- (IBAction)onTiltAnticlockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisTilt] incrementTargetPosition:-90
                                                                                  completionBlock:completionBlock
                                                                              waitUntilStationary:NO];
}

#pragma mark -
#pragma mark - GalileoDelegate Methods...

- (void)galileoDidConnect {
    [self enableUI];
    
    _connectStatusLbl.text = @"Galileo is Connected";
    _connectStatusLbl.textColor = [UIColor whiteColor];
    _onConnectView.backgroundColor = [UIColor greenColor];
}

- (void)galileoDidDisconnect {
    [self disableUI];
    
    _connectStatusLbl.text = @"Galileo is not Connected";
    _connectStatusLbl.textColor = [UIColor redColor];
    _onConnectView.backgroundColor = [UIColor whiteColor];
    
    [[GCGalileo sharedGalileo] waitForConnection];
}

#pragma mark -
#pragma mark PositionControl delegate

- (void) controlDidReachTargetPosition
{
    // Re-enable the UI now that the target has been reached, assuming we are still connected to Galileo
    if ([[GCGalileo sharedGalileo] isConnected]) [self enableUI];
}

@end
