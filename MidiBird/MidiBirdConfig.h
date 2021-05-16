//
//  MidiBirdConfig.h
//  MidiBird
//
//  Created by Sinri Edogawa on 2020/5/13.
//  Copyright © 2020 Sinri Edogawa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MidiBirdConfig : NSObject

@property float configTempo;
@property NSInteger configTSNumerator;
@property NSInteger configTSDenominator;
@property NSInteger configTSMetronome;
@property NSInteger configTS32ndCount;

+(MidiBirdConfig*)sharedInstance;
+(NSInteger)tempoStandard;

-(instancetype)init;

@end

NS_ASSUME_NONNULL_END
