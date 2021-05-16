//
//  MidiBirdConfig.m
//  MidiBird
//
//  Created by Sinri Edogawa on 2020/5/13.
//  Copyright © 2020 Sinri Edogawa. All rights reserved.
//

#import "MidiBirdConfig.h"

static MidiBirdConfig*configInstance;

@implementation MidiBirdConfig

-(instancetype)init{
    self=[super init];
    if(self){
        _configTempo=1;
        _configTSNumerator=4;
        _configTSDenominator=2;
        _configTSMetronome=24;
        _configTS32ndCount=8;
    }
    return self;
}

+(NSInteger)tempoStandard{
    return 0x078300;
}

+(MidiBirdConfig*)sharedInstance{
    if(configInstance==nil){
        configInstance = [[MidiBirdConfig alloc]init];
    }
    return configInstance;
}

@end
