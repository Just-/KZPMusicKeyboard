//
//  KZPMusicKeyboardDataAggregator.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicKeyboardDelegate.h"
@import KZPUtilities;

@protocol KZPMusicDataAggregatorDelegate <NSObject>

- (void)provideManualSpellingForNoteValues:(NSArray *)noteValues;

@end

@interface KZPMusicKeyboardDataAggregator : NSObject

@property (weak, nonatomic) id<KZPMusicKeyboardDataDelegate> musicalDelegate;
@property (weak, nonatomic) id<KZPMusicDataAggregatorDelegate> delegate;

@property (nonatomic, setter=enableChordDetection:) BOOL chordDetectionEnabled;
@property (nonatomic) NSUInteger chordSensitivity;
@property (nonatomic) BOOL manualSpellingEnabled;

- (void)reset;
- (void)resetPitchData;
- (void)receiveDuration:(unsigned int)duration rest:(BOOL)rest dotted:(BOOL)dotted tied:(BOOL)tied;
- (void)receiveSpelling:(MusicSpelling)spelling;
- (void)receivePitch:(NSUInteger)pitch;
- (void)receivePitchArray:(NSArray *)pitches withSpellingArray:(NSArray *)spellings;

- (void)flush;

@end
