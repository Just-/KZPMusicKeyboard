//
//  KZPSampler.h
//  KZPNameTone
//
//  Created by Matt Rankin on 13/10/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@interface KZPSampler : NSObject

@property (nonatomic) NSUInteger gain;
@property (nonatomic) NSUInteger presetNumber;

- (instancetype)initWithAudioController:(AEAudioController *)audioController;
- (AEAudioUnitChannel *)channel;

- (BOOL)loadSoundfontWithName:(NSString *)soundfontName;

- (void)issueMIDIEventWithStatus:(UInt32)status byte1:(UInt32)byte1 byte2:(UInt32)byte2;

@end
