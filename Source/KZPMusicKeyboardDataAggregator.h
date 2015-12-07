//
//  KZPMusicKeyboardDataAggregator.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicSciNotation.h"

typedef enum {
    KBD__NOTE_ON,
    KBD__NOTE_OFF
} inputType;

@interface KZPMusicKeyboardDataAggregator : NSObject

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> musicalDelegate;

@property (nonatomic, getter=chordDetectionEnabled, setter=enableChordDetection:) BOOL chordDetection;
@property (nonatomic) NSUInteger chordSensitivity;

- (void)reset;
- (void)receiveDuration:(unsigned int)duration rest:(BOOL)rest dotted:(BOOL)dotted tied:(BOOL)tied;
- (void)receiveSpelling:(MusicSpelling)spelling;
- (void)receivePitch:(NSUInteger)pitch;

@end
