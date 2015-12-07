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

@protocol KZPMusicDataAggregatorDelegate <NSObject>

- (void)provideManualSpellingForNoteValues:(NSArray *)noteValues;

@end

@interface KZPMusicKeyboardDataAggregator : NSObject

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> musicalDelegate;
@property (weak, nonatomic) id<KZPMusicDataAggregatorDelegate> delegate;

@property (nonatomic, getter=chordDetectionEnabled, setter=enableChordDetection:) BOOL chordDetection;
@property (nonatomic) NSUInteger chordSensitivity;
@property (nonatomic, getter=manualSpellingEnabled, setter=enableManualSpelling:) BOOL manualSpelling;
@property (nonatomic) MusicSpelling spellingBias;

- (void)reset;
- (void)resetPitchData;
- (void)receiveDuration:(unsigned int)duration rest:(BOOL)rest dotted:(BOOL)dotted tied:(BOOL)tied;
- (void)receiveSpelling:(MusicSpelling)spelling;
- (void)receivePitch:(NSUInteger)pitch;

- (void)receiveSpellingArray:(NSArray *)spellings;
- (void)receivePitchArray:(NSArray *)pitches;

- (void)flush;

@end
