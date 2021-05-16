//
//  ConfigViewController.m
//  MidiBird
//
//  Created by Sinri Edogawa on 2020/5/13.
//  Copyright © 2020 Sinri Edogawa. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()
@property (weak) IBOutlet NSTextField *configTempoTextInput;
@property (weak) IBOutlet NSTextField *configTSNumeratorTextInput;
@property (weak) IBOutlet NSTextField *configTSDenominatorTextInput;
@property (weak) IBOutlet NSTextField *configTSMetronomeTextInput;
@property (weak) IBOutlet NSTextField *configTS32ndCountTextInput;

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)viewWillAppear{
    [super viewWillAppear];
    
    MidiBirdConfig*config=[MidiBirdConfig sharedInstance];
    
    [_configTempoTextInput setFloatValue:config.configTempo];
    [_configTSNumeratorTextInput setIntegerValue:config.configTSNumerator];
    [_configTSDenominatorTextInput setIntegerValue:config.configTSDenominator];
    [_configTSMetronomeTextInput setIntegerValue:config.configTSMetronome];
    [_configTS32ndCountTextInput setIntegerValue:config.configTS32ndCount];
}

- (IBAction)saveMidiWorkerParameters:(id)sender {
    MidiBirdConfig*config=[MidiBirdConfig sharedInstance];
    [config setConfigTempo:[_configTempoTextInput floatValue]];
    [config setConfigTSNumerator:[_configTSNumeratorTextInput integerValue]];
    [config setConfigTSDenominator:[_configTSDenominatorTextInput integerValue]];
    [config setConfigTSMetronome:[_configTSMetronomeTextInput integerValue]];
    [config setConfigTS32ndCount:[_configTS32ndCountTextInput integerValue]];
}

@end
